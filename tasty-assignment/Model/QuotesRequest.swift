//
//  QuotesRequest.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 24/01/2024.
//

import Foundation

struct QuotesRequest: Request {
    var apiPath: String {
        "stock/\(symbol)/quote"
    }

    var method: HTTPMethod = .get

    var authorizationType: AuthorizationType = .iex

    private let symbol: String

    // MARK: Initializers

    /// Initializes the request.
    /// - Parameters:
    ///   - symbol: Symbol of stock for which quote should be provided.
    init(symbol: String) {
        self.symbol = symbol
    }
}
