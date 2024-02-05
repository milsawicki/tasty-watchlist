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
    var mockStorage: MockWatchlistStorage!
    var mockCoordinator: MockAppCoordinator!

    override func setUp() {
        super.setUp()
        mockStorage = MockWatchlistStorage()
        mockCoordinator = MockAppCoordinator()
        sut = MyWatchlistsViewModel(watchlistStorage: mockStorage, router: mockCoordinator.weakRouter)
    }

    override func tearDown() {
        sut = nil
        mockStorage = nil
        mockCoordinator = nil
        super.tearDown()
    }

    func test_deleteWatchlist_shouldDeleteExepctedWatchlist() {
        // Given
        let watchlist = Watchlist(name: "test")
        mockStorage.loadWatchlistsReturnValue = [watchlist]

        // When
        sut.delete(watchlist: watchlist)

        // Then
        XCTAssertEqual(mockStorage.removedWatchlistId, watchlist.id)
    }

    func test_watchlist_selection_triggers_correct_route() {
        // given
        let watchlist = Watchlist(name: "testWatchlist")

        // When
        sut.didSelect(watchlist: watchlist)

        // Then
        XCTAssertEqual(
            mockCoordinator.lastCalledRoute,
            .disSelect(watchlist: watchlist), "Correct route should be triggered on watchlist selection"
        )
    }

    func test_watchlist_for_index_returns_correct_item() {
        // Given
        let expectedWatchlist = Watchlist(name: "b")

        // When
        mockStorage.loadWatchlistsReturnValue = [Watchlist(name: "a"), expectedWatchlist, Watchlist(name: "c")]

        // Then
        XCTAssertEqual(sut.watchlist(for: 1).name, expectedWatchlist.name)
        XCTAssertEqual(sut.watchlist(for: 1).id, expectedWatchlist.id)
    }
}
