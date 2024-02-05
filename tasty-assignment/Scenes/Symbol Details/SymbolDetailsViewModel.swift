//
//  SymbolDetailsViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 01/02/2024.
//

import Combine
import DGCharts
import Foundation

/// ViewModel for handling the symbol details functionality.
final class SymbolDetailsViewModel {
    private let watchlistService: WatchlistServiceProtocol
    @Published var symbol: String

    /// Initializes the `SymbolDetailsViewModel` with a given symbol and watchlist service.
    /// - Parameters:
    ///   - symbol: A `String` representing the financial symbol.
    ///   - watchlistService: A `WatchlistServiceProtocol` instance to fetch data for the symbol.
    init(symbol: String, watchlistService: WatchlistServiceProtocol) {
        self.symbol = symbol
        self.watchlistService = watchlistService
    }

    /// Fetches the latest quotes for the symbol.
    /// - Returns: A `ResultPublisher` that emits a `StockQuoteResponse` or an `APIError`.
    func fetchQuotes() -> ResultPublisher<StockQuoteResponse, APIError> {
        watchlistService.fetchQuotes(for: symbol)
    }

    /// Fetches chart data for the symbol.
    /// - Returns: A `ResultPublisher` that emits an array of `CandleChartDataEntry` or an `APIError`.
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
