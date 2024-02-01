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

extension Date {
    // MARK: Private properties

    private static let calendar = Calendar(identifier: .gregorian)

    private static let dateFormatter = DateFormatter()

    // MARK: Methods

    /// Returns date with given components.
    /// - Parameters:
    ///   - day: Day of initialized date.
    ///   - month: Month of initialized date.
    ///   - year: Year of initialized date.
    static func from(day: Int = 1, month: Int = 1, year: Int = 1970) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return calendar.date(from: components)
    }

    /// Converts string to date with given format if possible.
    /// - Parameters:
    ///   - string: String to be converted.
    ///   - format: Date format of the string.
    static func from(string: String, format: String) -> Date? {
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
}
