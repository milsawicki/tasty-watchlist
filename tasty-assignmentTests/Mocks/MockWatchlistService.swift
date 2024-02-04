//
//  WatchlistServiceMock.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 04/02/2024.
//

import Foundation
@testable import tasty_assignment

class MockWatchlistService: WatchlistServiceProtocol {
    
    var expectedChartResponse: ResultPublisher<[StockChartDataResponse], APIError>!
    var expectedSearchSymbolResponse: ResultPublisher<[SearchSymbolResponse], APIError>!
    var expectedQuotesResponse: ResultPublisher<StockQuoteResponse, APIError>!

    func fetchQuotes(for symbol: String) -> ResultPublisher<StockQuoteResponse, APIError> {
        expectedQuotesResponse
    }

    func fetchChartData(for symbol: String) -> ResultPublisher<[StockChartDataResponse], APIError> {
        expectedChartResponse
    }

    func searchSymbol(for query: String) -> ResultPublisher<[SearchSymbolResponse], APIError> {
        expectedSearchSymbolResponse
    }
}
