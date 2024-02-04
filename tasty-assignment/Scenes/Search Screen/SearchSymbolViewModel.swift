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
    @Published var searchResult: AsyncResult<[SearchSymbolResponse], APIError> = .success([])
    var queryPublisher = PassthroughSubject<String, Never>()
    private let service: WatchlistServiceProtocol
    private let watchlistStorage: WatchlistStorageProtocol
    private var cancellables = Set<AnyCancellable>()
    private var watchlistId: UUID
    private var router: WeakRouter<AppRoute>
    private var addSymbolCompletion: () -> Void
    var numberOfRows: Int {
        searchResult.value?.count ?? 0
    }

    init(
        service: WatchlistServiceProtocol,
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
        $searchResult
            .map { $0.isLoading }
            .combineLatest(queryPublisher.map { !$0.isEmpty })
            .map { $0 && $1 }
            .assign(to: &$loadingPublisher)

        Publishers.Zip(
            queryPublisher.map { $0.isEmpty },
            $searchResult.compactMap { $0.value }.map { $0.isEmpty }
        )
        .dropFirst()
        .map { isQueryEmpty, isResultEmpty in
            return !isQueryEmpty && isResultEmpty
        }
        .assign(to: &$emptyPublisher)
        
        queryPublisher
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .flatMap { [weak self] symbol in
                guard let self = self else { return ResultPublisher<[SearchSymbolResponse], APIError>(Empty()) }
                return self.service.searchSymbol(for: symbol)
            }
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
