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

    func fetchQuotes() -> ResultPublisher<StockQuoteResponse, APIError> {
        watchlistService.fetchQuotes(for: symbol)
    }

    func fetchChartData() -> ResultPublisher<[CandleChartDataEntry], APIError> {
        watchlistService.fetchChartData(for: symbol)
            .compactMap { $0.value }
            .map {
                .success(
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
                )
            }
            .eraseToAnyPublisher()
    }
}
