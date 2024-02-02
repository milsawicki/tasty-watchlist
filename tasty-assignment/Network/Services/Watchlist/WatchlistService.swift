//
//  WatchlistService.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 24/01/2024.
//

import Combine
import Foundation

protocol WatchlistServiceProtocol {
    func fetchQuotes(for symbol: String) -> AnyPublisher<StockQuoteResponse, APIError>
    func searchSymbol(for query: String) -> AnyPublisher<[SearchSymbolResponse], APIError>
    func fetchChartData(for symbol: String) -> AnyPublisher<[StockChartDataResponse], APIError>
}

final class WatchlistService: WatchlistServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchQuotes(for symbol: String) -> AnyPublisher<StockQuoteResponse, APIError> {
        apiClient.fetch(
            request: QuotesRequest(symbol: symbol)
        )
    }

    func searchSymbol(for query: String) -> AnyPublisher<[SearchSymbolResponse], APIError> {
        AnyPublisher<TopLevelContainer<SearchSymbolItemsResponse>, APIError>(
            apiClient.fetch(request: SearchSymbolRequest(query: query))
        )
        .map { $0.data.items }
        .eraseToAnyPublisher()
    }
    
    func fetchChartData(for symbol: String) -> AnyPublisher<[StockChartDataResponse], APIError> {
        apiClient.fetch(request: StockChartDataRequest(query: symbol))
    }
}
