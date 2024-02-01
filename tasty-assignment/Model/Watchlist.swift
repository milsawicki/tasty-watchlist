//
//  Watchlist.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 01/02/2024.
//

import Foundation

struct Watchlist: Codable {
    let id: UUID
    var name: String
    var symbols: [String]

    init(name: String, symbols: [String] = []) {
        id = UUID()
        self.name = name
        self.symbols = symbols
    }
}
