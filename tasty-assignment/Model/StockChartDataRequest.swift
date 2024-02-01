//
//  StockChartDataRequet.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 01/02/2024.
//

import Foundation

struct StockChartDataRequest: Request {

    var apiPath: String {
        "/stock/\(query)/chart/1m"
    }

    var basePath: String {
        "cloud.iexapis.com/stable"
    }

    var method: HTTPMethod = .get

    var authorizationType: AuthorizationType = .iex

    private let query: String

    // MARK: Initializers

    /// Initializes the request.
    /// - Parameters:
    ///   - symbol: Symbol of stock for which data should be provided.
    init(query: String) {
        self.query = query
    }
}
