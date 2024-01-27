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
    var currentWatchlistName: String {
        activeWatchlist.name
    }

    private var activeWatchlist: Watchlist = Watchlist.mocked
    private let service: WatchlistService
    private var cancellables: [AnyCancellable] = []

    @Published var items: [WatchlistItem] = []

    init(service: WatchlistService) {
        self.service = service
    }

    func fetchQuotes() {
        activeWatchlist
            .items
            .publisher
            .flatMap { item in
                self.service.fetchQuotes(for: item.symbol)
            }
            .collect()
            
            .eraseToAnyPublisher()

            .sink(receiveCompletion: { error in
                print(error)
            }, receiveValue: { response in
                
                self.items = response
                    .map { quoteItem in
                    WatchlistItem(
                        symbol: quoteItem.companyName,
                        companyName: quoteItem.symbol,
                        bidPrice: quoteItem.bidPrice,
                        askPrice: quoteItem.askPrice,
                        lastPrice: quoteItem.latestPrice
                    )
                }
            })

            .store(in: &cancellables)
    }
}
