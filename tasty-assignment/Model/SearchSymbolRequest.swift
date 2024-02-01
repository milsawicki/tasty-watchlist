//
//  SearchSymbolRequest.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import Foundation

struct SearchSymbolRequest: Request {
    var apiPath: String {
        "/symbols/search/\(query)"
    }

    var basePath: String {
        Configs.Network.tastyApiBaseUrl
    }

    var method: HTTPMethod = .get

    var authorizationType: AuthorizationType = .iex

    private let query: String

    // MARK: Initializers

    /// Initializes the request.
    /// - Parameters:
    ///   - symbol: Symbol of stock for which quote should be provided.
    init(query: String) {
        self.query = query
    }
}
