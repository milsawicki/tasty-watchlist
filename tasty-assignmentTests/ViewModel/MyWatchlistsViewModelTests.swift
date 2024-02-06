//
//  MyWatchlistsViewModelTests.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 03/02/2024.
//

@testable import tasty_assignment
import XCoordinator
import XCTest

class MyWatchlistsViewModelTests: XCTestCase {
    var sut: MyWatchlistsViewModel!
    var mockStorage: WatchlistStorageProtocol!
    var mockCoordinator: MockAppCoordinator!

    override func setUp() {
        super.setUp()
        mockStorage = WatchlistStorage(userDefaults: MockUserDefaults())
        mockCoordinator = MockAppCoordinator()
        sut = MyWatchlistsViewModel(watchlistStorage: mockStorage, router: mockCoordinator.weakRouter)
    }

    override func tearDown() {
        sut = nil
        mockStorage = nil
        mockCoordinator = nil
        super.tearDown()
    }

    func test_deleteWatchlist_withValidWatchlist_shouldCallReloadData() {
        mockStorage.addWatchlist(name: "Watchlist", with: [])
        var reloadDataCalled = false
        sut.reloadData = { reloadDataCalled = true }

        sut.delete(watchlist: mockStorage.loadWatchlists().first!)

        XCTAssertTrue(reloadDataCalled, "Reload data should be called after deletion.")
        XCTAssertEqual(mockStorage.loadWatchlists().count, 0, "Watchlist should be empty.")
    }

    func test_shouldAllowDelete_whenMultipleWatchlists_shouldReturnTrue() {
        mockStorage.addWatchlist(name: "Watchlist 1")
        mockStorage.addWatchlist(name: "Watchlist 2")
        XCTAssertTrue(sut.shouldAllowDelete, "Deletion should be allowed with multiple watchlists")
    }

    func test_didSelectWatchlist_withValidWatchlist_shouldTriggerRouter() {
        let watchlist = Watchlist(name: "testWatchlist")
        sut.didSelect(watchlist: watchlist)
        XCTAssertEqual(
            mockCoordinator.lastCalledRoute,
            .disSelect(watchlist: watchlist), "Correct route should be triggered on watchlist selection"
        )
    }

    func test_watchlistForRowIndex_withValidIndex_shouldReturnCorrectWatchlist() {
        let expectedWatchlist = Watchlist(name: "b")
        mockStorage.addWatchlist(expectedWatchlist)
        XCTAssertEqual(sut.watchlist(for: 0).name, expectedWatchlist.name, "Should return the correct watchlist for given row index")
        XCTAssertEqual(sut.watchlist(for: 0).id, expectedWatchlist.id, "Should return the correct watchlist for given row index")
    }
}
