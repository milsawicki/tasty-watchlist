//
//  MockWatchlistStorage.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 04/02/2024.
//

import Foundation
@testable import tasty_assignment

class MockWatchlistStorage: WatchlistStorageProtocol {
    var loadWatchlistsCalled = false
    var loadWatchlistsReturnValue: [Watchlist]!
    var addWatchlistCalled = false
    var addWatchlistReceivedName: String?
    var fetchSymbolsCalled = false
    var removeAllCalled = false
    var fetchSymbolsReceivedId: UUID?
    var addSymbolReceivedWatchlistId: UUID?
    var addSymbolReceivedSymbol: String?
    var fetchSymbolsReturnValue: [String]?
    var removedWatchlistId: UUID?
    var removeSymbolReceivedWatchlistId: UUID?
    var removeSymbolReceivedSymbol: String?
    var addSymbolCalled = false
    var fetchWatchlistReceivedId: UUID?
    var fetchWatchlistReturnedValue: Watchlist!

    func loadWatchlists() -> [Watchlist] {
        loadWatchlistsCalled = true
        return loadWatchlistsReturnValue
    }

    func addWatchlist(name: String) {
        addWatchlistCalled = true
        addWatchlistReceivedName = name
    }

    func removeWatchlist(id: UUID) {
        removedWatchlistId = id
    }

    func addSymbol(to watchlistId: UUID, symbol: String) {
        addSymbolCalled = true
        addSymbolReceivedWatchlistId = watchlistId
        addSymbolReceivedSymbol = symbol
    }

    func removeSymbol(from watchlistId: UUID, symbol: String) {
        removeSymbolReceivedWatchlistId = watchlistId
        removeSymbolReceivedSymbol = symbol
    }

    func fetchWatchlist(by id: UUID) -> Watchlist? {
        fetchWatchlistReceivedId = id
        return fetchWatchlistReturnedValue
    }

    func removeAll() {
        removeAllCalled = true
    }

    func fetchSymbols(fromWatchlist id: UUID) -> [String]? {
        fetchSymbolsCalled = true
        fetchSymbolsReceivedId = id
        return fetchSymbolsReturnValue
    }
}
