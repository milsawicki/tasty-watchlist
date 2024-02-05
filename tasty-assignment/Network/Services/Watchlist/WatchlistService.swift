//
//  WatchlistService.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 24/01/2024.
//

import Combine
import Foundation

protocol WatchlistServiceProtocol {
    func fetchQuotes(for symbol: String) -> ResultPublisher<StockQuoteResponse, APIError>
    func fetchChartData(for symbol: String) -> ResultPublisher<[StockChartDataResponse], APIError>
    func searchSymbol(for query: String) -> ResultPublisher<[SearchSymbolResponse], APIError>
}

final class WatchlistService: WatchlistServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchQuotes(for symbol: String) -> ResultPublisher<StockQuoteResponse, APIError> {
        apiClient.fetch(request: QuotesRequest(symbol: symbol))
    }

    func searchSymbol(for query: String) -> ResultPublisher<[SearchSymbolResponse], APIError> {
        ResultPublisher<TopLevelContainer<SearchSymbolItemsResponse>, APIError>(
            apiClient.fetch(request: SearchSymbolRequest(query: query))
        )
        .compactMap {
            if let items = $0.value?.data.items {
                return .success(items)
            }
            return nil
        }
        .eraseToAnyPublisher()
    }

    func fetchChartData(for symbol: String) -> ResultPublisher<[StockChartDataResponse], APIError> {
        apiClient.fetch(request: StockChartDataRequest(query: symbol))
    }
}
