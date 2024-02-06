//
//  MockWatchlistStorage.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 06/02/2024.
//

import Foundation
@testable import tasty_assignment

class MockWatchlistStorage: WatchlistStorageProtocol {
    var addedWatchlistName: String!
    var addWatchlistMethodCallCount = 0
    var addedWatchlistSymbols: [String]!
    func loadWatchlists() -> [Watchlist] {
        fatalError("Mock not implemented yet.")
    }

    func addWatchlist(_ watchlist: Watchlist) {
        fatalError("Mock not implemented yet.")
    }

    func addWatchlist(name: String) {
        fatalError("Mock not implemented yet.")
    }

    func addWatchlist(name: String, with symbols: [String]) {
        addedWatchlistName = name
        addWatchlistMethodCallCount += 1
        addedWatchlistSymbols = symbols
    }

    func removeWatchlist(id: UUID) {
        fatalError("Mock not implemented yet.")
    }

    func addSymbol(to watchlistId: UUID, symbol: String) {
        fatalError("Mock not implemented yet.")
    }

    func removeSymbol(from watchlistId: UUID, symbol: String) {
        fatalError("Mock not implemented yet.")
    }

    func fetchWatchlist(by id: UUID) -> Watchlist? {
        fatalError("Mock not implemented yet.")
    }

    func fetchSymbols(fromWatchlist id: UUID) -> [String]? {
        fatalError("Mock not implemented yet.")
    }

    func removeAll() {
        fatalError("Mock not implemented yet.")
    }
}
