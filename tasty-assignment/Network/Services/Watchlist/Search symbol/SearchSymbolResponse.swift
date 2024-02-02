//
//  SearchSymbolResponse.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import Foundation

struct SearchSymbolItemsResponse: Codable {
    let items: [SearchSymbolResponse]
    
    init() {
        items = []
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try container.decode([SearchSymbolResponse].self, forKey: .items)
    }
}

struct SearchSymbolResponse: Codable, Hashable {
    let symbol: String
    let description: String
    let instrumentType: String

    enum CodingKeys: String, CodingKey {
        case symbol
        case description
        case instrumentType = "instrument-type"
    }
}


