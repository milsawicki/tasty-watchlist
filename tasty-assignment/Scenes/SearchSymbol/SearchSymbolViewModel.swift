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
    @Published var searchResult: AsyncResult<[SearchSymbolResponse], Error> = .pending
    private let service: WatchlistService
    private let watchlistStorage: WatchlistStorageProtocol
    private var cancellables = [AnyCancellable]()
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

    func bind(query: AnyPublisher<String, Never>) {
        query
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.global())
            .flatMap { [weak self] symbol in
                guard let self = self else { return Empty<[SearchSymbolResponse], Error>().eraseToAnyPublisher() }
                return self.service.searchSymbol(for: symbol).eraseToAnyPublisher()
            }
            .asResult()
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
