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

struct WatchlistItem {
    let symbol: String
    let companyName: String
    let bidPrice: Double
    let askPrice: Double
    let lastPrice: Double
}

extension Watchlist {
    static let mocked: Watchlist = .init(
        name: "My Watchlist",
        items: [
            .init(symbol: "AAPL", companyName: "Apple", bidPrice: 12, askPrice: 12, lastPrice: 20),
            .init(symbol: "MSFT", companyName: "Microsoft", bidPrice: 12, askPrice: 12, lastPrice: 20),
            .init(symbol: "GOOG", companyName: "Google", bidPrice: 12, askPrice: 12, lastPrice: 20),
        ]
    )
}

class WatchlistViewModel: ObservableObject {
    private var activeWatchlist: Watchlist = Watchlist.mocked

    private var cancellables: [AnyCancellable] = []
    var title: String {
        activeWatchlist.name
    }

    @Published var items: [WatchlistItem] = []

    func fetchQuotes() {
        activeWatchlist
            .items
            .publisher
            .map { $0 } // TODO: Implement fetching quotes here
            .collect()
            .sink { [weak self] in self?.items = $0 }
            .store(in: &cancellables)
    }
}
