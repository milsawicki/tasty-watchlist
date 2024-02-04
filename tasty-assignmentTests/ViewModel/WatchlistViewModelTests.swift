//
//  WatchlistViewModel.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 04/02/2024.
//

@testable import tasty_assignment
import XCTest

class WatchlistViewModelTests: XCTestCase {
    var mockStorage: MockWatchlistStorage!
    var mockCoordinator: MockAppCoordinator!
    var mockService: WatchlistServiceProtocol!
    var mockWatchlist = Watchlist(name: "mock")
    var sut: WatchlistViewModel!
    override func setUp() {
        super.setUp()
        sut = .init(
            watchlistId: mockWatchlist.id,
            service: mockService,
            watchlistStorage: mockStorage,
            router: mockCoordinator.weakRouter
        )
    }

    override func tearDown() {
        sut = nil
        mockService = nil
        mockCoordinator = nil
        mockStorage = nil
        super.tearDown()
    }

    func test_deleteSymbolFromWatchlist() {
        // when
        sut.delete(symbol: "apple")

        // then
    }
}
