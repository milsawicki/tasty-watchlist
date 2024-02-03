//
//  AddWatchlistItemViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import Combine
import UIKit
import XCoordinator

final class SearchSymbolViewModel {
    @Published var loadingPublisher: Bool = false
    @Published var emptyPublisher: Bool = false
    @Published var searchResult: AsyncResult<[SearchSymbolResponse], APIError> = .pending
    var queryPublisher = PassthroughSubject<String, Never>()
    private let service: WatchlistService
    private let watchlistStorage: WatchlistStorageProtocol
    private var cancellables = Set<AnyCancellable>()
    private var watchlistId: UUID
    private var router: WeakRouter<AppRoute>
    private var addSymbolCompletion: () -> Void
    var numberOfRows: Int {
        searchResult.value?.count ?? 0
    }

    init(
        service: WatchlistService,
        watchlistStorage: WatchlistStorageProtocol,
        router: WeakRouter<AppRoute>,
        watchlistId: UUID,
        addSymbolCompletion: @escaping () -> Void
    ) {
        self.watchlistStorage = watchlistStorage
        self.service = service
        self.watchlistId = watchlistId
        self.router = router
        self.addSymbolCompletion = addSymbolCompletion
    }

    func bind(queryPublisher: AnyPublisher<String, Never>) {
        queryPublisher
            .map { $0.isEmpty }
            .combineLatest($searchResult.compactMap { $0.isLoading })
            .map { !$0 && $1 }
            .assign(to: &$loadingPublisher)

        queryPublisher
            .map { $0.isEmpty }
            .combineLatest($searchResult.compactMap { $0.error != nil })
            .map { !$0 && $1 }
            .assign(to: &$emptyPublisher)

        queryPublisher
            .map { !$0.isEmpty }
            .combineLatest(
                $searchResult
                    .filter { $0.isSuccess }
                    .compactMap { $0.value?.isEmpty }
            )
            .map { $0 && $1 }
            .assign(to: &$emptyPublisher)

        queryPublisher
            .filter { !$0.isEmpty }
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .print()
            .map { [weak self] symbol in
                guard let self = self else { return ResultPublisher<[SearchSymbolResponse], APIError>(Empty()) }
                return self.service.searchSymbol(for: symbol).eraseToAnyPublisher()
            }
            .switchToLatest()
            .assign(to: &$searchResult)
    }

    func addSymbolToWatchlist(_ symbol: String) {
        guard let watchlist = watchlistStorage.loadWatchlists().first(where: { $0.id == watchlistId }),
              !watchlist.symbols.contains(where: { $0 == symbol }) else { return }
        watchlistStorage.addSymbol(to: watchlistId, symbol: symbol)
        router.trigger(.dismiss)
        addSymbolCompletion()
    }

    func symbol(for row: Int) -> SearchSymbolResponse? {
        searchResult.value?[row]
    }

    func dismiss() {
        router.trigger(.dismiss)
    }
}
