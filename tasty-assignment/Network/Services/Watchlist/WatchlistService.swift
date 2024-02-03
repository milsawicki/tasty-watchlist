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
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchQuotes(for symbol: String) -> ResultPublisher<StockQuoteResponse, APIError> {
        apiClient.fetchs(request: QuotesRequest(symbol: symbol))
    }

    func searchSymbol(for query: String) -> ResultPublisher<[SearchSymbolResponse], APIError> {
        ResultPublisher<TopLevelContainer<SearchSymbolItemsResponse>, APIError>(
            apiClient.fetchs(request: SearchSymbolRequest(query: query))
        )
        .map {
            .success($0.value?.data.items ?? [])
        }
        .eraseToAnyPublisher()
    }
    
    func fetchChartData(for symbol: String) -> ResultPublisher<[StockChartDataResponse], APIError> {
        apiClient.fetchs(request: StockChartDataRequest(query: symbol))
    }
}
