//
//  WatchlistViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import Combine
import Foundation

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
        currentWatchlist.name
    }

    var currentWatchlist: Watchlist {
        watchlistStorage.loadWatchlists().first ?? Watchlist(name: "", symbols: [])
    }

    var symbols: [String] {
        currentWatchlist.symbols
    }

    @Published var quotesResult: AsyncResult<[StockQuoteResponse], Error> = .pending
    private let service: WatchlistService
    private var watchlistStorage: WatchlistStorageProtocol

    init(service: WatchlistService, watchlistStorage: WatchlistStorageProtocol) {
        self.service = service
        self.watchlistStorage = watchlistStorage
    }

    func fetchQuotes(for symbol: String) -> AnyPublisher<StockQuoteResponse, Error> {
        service.fetchQuotes(for: symbol)
    }

    func delete(symbol: String) {
        watchlistStorage.removeSymbol(from: currentWatchlist.id, symbol: symbol)
    }
}
