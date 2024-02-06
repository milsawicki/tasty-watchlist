//
//  AppSettingsTests.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 06/02/2024.
//

@testable import tasty_assignment
import XCTest

final class AppSettingsTests: XCTestCase {
    func test_setInitialState_withFirstLaunch_shouldMarkAppAsLaunchedAndAddWatchlist() {
        let appSettings = MockAppSettings()
        let storage = MockWatchlistStorage()
        let mockServiceProvider = MockServiceProvider(watchlistStorage: storage, appSettings: appSettings)

        _ = AppCoordinator(serviceProvider: mockServiceProvider)

        XCTAssertTrue(appSettings.hasLaunchedBefore, "AppSettings' 'hasLaunchedBefore' should be true after initial launch")
        XCTAssertEqual(storage.addedWatchlistName, "My first list", "The added watchlist should be named 'My first list'")
        XCTAssertEqual(storage.addedWatchlistSymbols, ["AAPL", "MSFT", "GOOG"], "The added watchlist should contain symbols ['AAPL', 'MSFT', 'GOOG']")
    }

    func test_setInitialState_withSubsequentLaunch_shouldNotAddWatchlist() {
        let appSettings = MockAppSettings()
        let storage = MockWatchlistStorage()
        let mockServiceProvider = MockServiceProvider(watchlistStorage: storage, appSettings: appSettings)

        XCTAssertEqual(storage.addWatchlistMethodCallCount, 0, "Watchlist should not be added before initializing AppCoordinator")
        _ = AppCoordinator(serviceProvider: mockServiceProvider)
        XCTAssertEqual(storage.addWatchlistMethodCallCount, 1, "Watchlist should be added only once after first initialization of AppCoordinator")
        _ = AppCoordinator(serviceProvider: mockServiceProvider)
        XCTAssertEqual(storage.addWatchlistMethodCallCount, 1, "Watchlist should not be added again on subsequent initialization of AppCoordinator")
        XCTAssertTrue(appSettings.hasLaunchedBefore, "AppSettings' 'hasLaunchedBefore' should be true after initial launch")
        XCTAssertEqual(storage.addedWatchlistName, "My first list", "The added watchlist should be named 'My first list' after first initialization")
        XCTAssertEqual(storage.addedWatchlistSymbols, ["AAPL", "MSFT", "GOOG"], "The added watchlist should contain symbols ['AAPL', 'MSFT', 'GOOG'] after first initialization")
    }
}
