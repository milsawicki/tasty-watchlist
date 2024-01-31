//
//  WatchlistViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import Combine
import Foundation

struct Watchlist: Hashable {
    let name: String
    let items: [WatchlistItem]
}

struct WatchlistItem: Hashable {
    let symbol: String
}

extension Watchlist {
    static let mocked: Watchlist = .init(
        name: "My Watchlist",
        items: [
            .init(symbol: "AAPL"),
            .init(symbol: "MSFT"),
            .init(symbol: "GOOG"),
        ]
    )
}

class WatchlistViewModel: ObservableObject {
    var currentWatchlistName: String {
        activeWatchlist.name
    }

    @Published var quotesResult: AsyncResult<[StockQuoteResponse], Error> = .pending
    var activeWatchlist: Watchlist = Watchlist.mocked
    private let service: WatchlistService
    private var cancellables: [AnyCancellable] = []
    init(service: WatchlistService) {
        self.service = service
    }

    func fetchQuotes(for symbol: String) -> AnyPublisher<StockQuoteResponse, Error> {
        service.fetchQuotes(for: symbol).eraseToAnyPublisher()
    }

    // TODO: refresh quotes for each cell

    func deleteSymbol() {
    }
}
