//
//  MockServiceProvider.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 06/02/2024.
//

import Foundation
@testable import tasty_assignment

// MockServiceProvider is a mock version of ServiceProvider for testing purposes.
final class MockServiceProvider: AppCoordinatorProvider {
    var watchlistService: WatchlistServiceProtocol
    var watchlistStorage: WatchlistStorageProtocol
    var apiClient: APIClientProtocol
    var userDefaults: UserDefaultsProtocol
    var appSettings: AppSettingsProtocol

    init(
        watchlistService: WatchlistServiceProtocol = MockWatchlistService(),
        watchlistStorage: WatchlistStorageProtocol = MockWatchlistStorage(),
        apiClient: APIClientProtocol = MockAPIClient(),
        userDefaults: UserDefaultsProtocol = MockUserDefaults(),
        appSettings: AppSettingsProtocol = MockAppSettings()
    ) {
        self.watchlistService = watchlistService
        self.watchlistStorage = watchlistStorage
        self.apiClient = apiClient
        self.userDefaults = userDefaults
        self.appSettings = appSettings
    }
}

