//
//  WatchlistViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import Combine
import Foundation

struct Watchlist {
    let name: String
    let items: [WatchlistItem]
}

struct WatchlistItem: Hashable {
    let symbol: String
    let companyName: String
}

extension Watchlist {
    static let mocked: Watchlist = .init(
        name: "My Watchlist",
        items: [
            .init(symbol: "AAPL", companyName: "Apple"),
            .init(symbol: "MSFT", companyName: "Microsoft"),
            .init(symbol: "GOOG", companyName: "Google"),
        ]
    )
}

class WatchlistViewModel: ObservableObject {
    var currentWatchlistName: String {
        activeWatchlist.name
    }

    @Published var result: AsyncResult<[StockQuoteResponse], Error> = .pending
    private var activeWatchlist: Watchlist = Watchlist.mocked
    private let service: WatchlistService
    private var cancellables: [AnyCancellable] = []
    init(service: WatchlistService) {
        self.service = service
    }

    func fetchQuotes() {
        Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .flatMap { _ in Just(AsyncResult<StockQuoteResponse, Error>.pending) }
            .flatMap { [unowned self] _ in
                self.activeWatchlist.items.publisher
                    .map { $0.symbol }
                    .flatMap { symbol in
                        self.service.fetchQuotes(for: symbol)
                    }
                    .collect()
                    .eraseToAnyPublisher()
            }
            .map { $0.sorted { $0.symbol < $1.symbol } }
            .asResult()
            .assign(to: &$result)
    }
    
    func deleteSymbol() {
        
    }
}
