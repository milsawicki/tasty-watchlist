//
//  StockChartDataResponse.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 01/02/2024.
//

import Foundation

struct StockChartDataResponse: Codable {
    let open: Double
    let close: Double
    let high: Double
    let low: Double
    let date: String
}
