//
//  WatchlistStorageTests.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 05/02/2024.
//

import XCTest
@testable import tasty_assignment

final class WatchlistStorageTests: XCTestCase {
    var mockUserDefaults: MockUserDefaults!
    var storage: WatchlistStorage!

    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        storage = WatchlistStorage(userDefaults: mockUserDefaults)
    }

    override func tearDown() {
        mockUserDefaults = nil
        storage = nil
        super.tearDown()
    }

    func test_addWatchlist_withNameOnly_shouldAddWatchlistWithName() {
        storage.addWatchlist(name: "New Watchlist")
        let watchlists = storage.loadWatchlists()
        XCTAssertEqual(watchlists.count, 1, "There should be one watchlist")
        XCTAssertEqual(watchlists.first?.name, "New Watchlist", "Watchlist name should match")
    }

    func test_removeWatchlist_withValidId_shouldRemoveSpecifiedWatchlist() {
        let watchlist = Watchlist(name: "mocked")
        // Add and then remove the watchlist
        storage.addWatchlist(watchlist)
        storage.removeWatchlist(id: watchlist.id)
        let watchlists = storage.loadWatchlists()
        XCTAssertTrue(watchlists.allSatisfy { $0.id != watchlist.id }, "Watchlist should be removed")
    }

    func test_addWatchlist_withNameAndSymbols_shouldAddWatchlistWithSymbols() {
        storage.addWatchlist(name: "Tech Stocks", with: ["AAPL", "GOOG"])
        let watchlists = storage.loadWatchlists()
        XCTAssertEqual(watchlists.count, 1, "There should be one watchlist")
        XCTAssertEqual(watchlists.first?.symbols, ["AAPL", "GOOG"], "Symbols should match")
    }

    func test_fetchWatchlist_withValidId_shouldReturnSpecifiedWatchlist() {
        let addedWatchlist = Watchlist(name: "Watchlist")
        storage.addWatchlist(addedWatchlist)
        let fetchedWatchlist = storage.fetchWatchlist(by: addedWatchlist.id)
        XCTAssertNotNil(fetchedWatchlist, "Watchlist should be fetched")
        XCTAssertEqual(fetchedWatchlist?.id, addedWatchlist.id, "Fetched watchlist ID should match")
    }

    func test_removeSymbol_fromWatchlistWithValidId_shouldRemoveSymbolFromWatchlist() {
        let watchlist = Watchlist(name: "My Watchlist", symbols: ["AMZN", "FB"])
        storage.addWatchlist(watchlist)
        storage.removeSymbol(from: watchlist.id, symbol: "FB")
        let fetchedWatchlist = storage.fetchWatchlist(by: watchlist.id)
        XCTAssertFalse(fetchedWatchlist?.symbols.contains("FB") ?? true, "Symbol should be removed")
    }
    
    func test_addSymbol_toWatchlistWithValidId_shouldAddSymbolToWatchlist() {
        let addedWatchlist = Watchlist(name: "My watchlist")
        storage.addWatchlist(addedWatchlist)
        storage.addSymbol(to: addedWatchlist.id, symbol: "MSFT")
        let watchlist = storage.fetchWatchlist(by: addedWatchlist.id)
        XCTAssertTrue(watchlist?.symbols.contains("MSFT") ?? false, "Symbol should be added")
    }

    func test_removeAll_whenCalled_shouldClearAllWatchlists() {
        storage.addWatchlist(name: "Watchlist 1")
        storage.addWatchlist(name: "Watchlist 2")
        storage.removeAll()
        let watchlists = storage.loadWatchlists()
        XCTAssertTrue(watchlists.isEmpty, "All watchlists should be removed")
    }
}
