//
//  Symbol.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import Foundation

/// Response for stock quote request.
struct StockQuoteResponse: Codable {
    let companyName: String
    let symbol: String
    let bidPrice: Double
    let askPrice: Double
    let latestPrice: Double

    enum CodingKeys: String, CodingKey {
        case symbol
        case bidPrice = "iexBidPrice"
        case askPrice = "iexAskPrice"
        case companyName
        case latestPrice
    }
}
