//
//  SymbolDetailsViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 01/02/2024.
//

import Combine
import DGCharts
import Foundation

class SymbolDetailsViewModel {
    private let watchlistService: WatchlistServiceProtocol
    @Published var symbol: String

    init(symbol: String, watchlistService: WatchlistServiceProtocol) {
        self.symbol = symbol
        self.watchlistService = watchlistService
    }

    func fetchQuotes() -> AnyPublisher<StockQuoteResponse, Error> {
        watchlistService.fetchQuotes(for: symbol)
    }

    func fetchChartData() -> AnyPublisher<[CandleChartDataEntry], Error> {
        watchlistService.fetchChartData(for: symbol)
            .map {
                $0.enumerated()
                    .map { index, entry in
                        CandleChartDataEntry(
                            x: Double(index),
                            shadowH: entry.high,
                            shadowL: entry.low,
                            open: entry.open,
                            close: entry.close
                        )
                    }
            }
            .eraseToAnyPublisher()
    }
}
