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

class WatchlistService: QuoutesServiceProtocol {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func fetchQuotes(for symbol: String) -> AnyPublisher<StockQuoteResponse, Error> {
        apiClient.fetch(
            request: QuotesRequest(symbol: symbol),
            expectedResponseType: StockQuoteResponse.self
        )
    }

    func searchSymbol(for query: String) -> AnyPublisher<SearchSymbolItemsResponse, Error> {
        apiClient.fetch(
            request: SearchSymbolRequest(query: query),
            expectedResponseType: SearchSymbolItemsResponse.self,
            hasTopLevelKey: true
        )
    }
    
    func fetchQuotes5sRefreshRate(for symbol: String) -> AnyPublisher<StockQuoteResponse, Error> {
        Timer.publish(every: 5, on: .main, in: .common).autoconnect()
            .flatMap { _ in
                self.fetchQuotes(for: symbol)
            }
            .eraseToAnyPublisher()
    }
}
