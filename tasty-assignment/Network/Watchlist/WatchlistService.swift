//
//  WatchlistService.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 24/01/2024.
//

import Combine
import Foundation

protocol QuoutesServiceProtocol {
    func fetchQuotes(for symbol: String) -> AnyPublisher<StockQuoteResponse, Error>
}

final class WatchlistService: QuoutesServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchQuotes(for symbol: String) -> AnyPublisher<StockQuoteResponse, Error> {
        apiClient.fetch(
            request: QuotesRequest(symbol: symbol)
        )
    }

    func searchSymbol(for query: String) -> AnyPublisher<SearchSymbolItemsResponse, Error> {
        AnyPublisher<TopLevelContainer<SearchSymbolItemsResponse>, Error>(
            apiClient.fetch(request: SearchSymbolRequest(query: query))
        )
        .map { $0.data }
        .eraseToAnyPublisher()
    }
}
