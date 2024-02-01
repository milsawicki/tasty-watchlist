//
//  WatchlistViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import Combine
import Foundation
import XCoordinator

struct Watchlist: Codable {
    let id: UUID
    var name: String
    var symbols: [String]

    init(name: String, symbols: [String] = []) {
        id = UUID()
        self.name = name
        self.symbols = symbols
    }
}

class WatchlistViewModel: ObservableObject {
    var currentWatchlistName: String {
        currentWatchlist?.name ?? ""
    }

    var currentWatchlist: Watchlist? {
        watchlistStorage.fetchWatchlist(by: watchlistId)
    }

    var symbols: [String] {
        watchlistStorage.fetchSymbols(fromWatchlist: watchlistId) ?? []
    }

    var reloadData: (() -> Void)?

    private let service: WatchlistService
    private var watchlistStorage: WatchlistStorageProtocol
    private var router: WeakRouter<AppRoute>
    private var watchlistId: UUID
    init(
        watchlistId: UUID,
        service: WatchlistService,
        watchlistStorage: WatchlistStorageProtocol,
        router: WeakRouter<AppRoute>) {
        self.watchlistId = watchlistId
        self.service = service
        self.watchlistStorage = watchlistStorage
        self.router = router
    }

    func fetchQuotes(for symbol: String) -> AnyPublisher<StockQuoteResponse, Error> {
        service.fetchQuotes(for: symbol)
    }

    func delete(symbol: String) {
        guard let id = currentWatchlist?.id else { return }
        watchlistStorage.removeSymbol(from: id, symbol: symbol)
    }

    func showSymbolDetails(_ symbol: String) {
        router.trigger(.symbolDetails(symbol: symbol))
    }

    func showAddSymbol() {
        guard let id = currentWatchlist?.id else { return }
        router.trigger(.addSymbolToWatchlist(watchlistId: id) { [weak self] in
            self?.reloadData?()
        })
    }

    func manageWatchlists() {
        router.trigger(.manageWatchlists)
    }
}
