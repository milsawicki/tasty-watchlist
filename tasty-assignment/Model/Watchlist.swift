//
//  Watchlist.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 01/02/2024.
//

import Foundation

/// Represents a watchlist in the application.
struct Watchlist: Codable, Equatable {
    /// A unique identifier for the watchlist (UUID).
    let id: UUID
    /// The name of the watchlist.
    var name: String
    /// An array of strings representing the financial symbols included in the watchlist.
    var symbols: [String]

    /// Initialization:
    /// Can be initialized with a name and an optional array of symbols. If no symbols are provided, it initializes with an empty array.
    ///
    /// - Parameters:
    ///   - name: A `String` representing the name of the watchlist.
    ///   - symbols: An array of `String` representing the symbols in the watchlist. Defaults to an empty array.
    init(name: String, symbols: [String] = []) {
        id = UUID()
        self.name = name
        self.symbols = symbols
    }
}
