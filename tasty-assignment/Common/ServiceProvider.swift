//
//  ServiceProvider.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 05/02/2024.
//

import Foundation

/// `ServiceProvider` is a class responsible for providing various services and components
/// throughout the application. It acts as a centralized point for managing dependencies and makes
/// it easier to replace or mock these services during testing.
class ServiceProvider {
    // Services and storage used throughout the application.
    internal let watchlistService: WatchlistServiceProtocol
    internal let watchlistStorage: WatchlistStorageProtocol
    internal let apiClient: APIClientProtocol
    internal let userDefaults: UserDefaultsProtocol
    /// Initializes a new `ServiceProvider` instance with specified services and storage.
    /// - Parameters:
    ///   - watchlistService: A service to manage watchlist-related functionalities.
    ///   - wastchlistStorage: A storage mechanism for persisting watchlists.
    ///   - apiClient: A client for handling API requests.
    ///   - userDefaults: A client for handling API requests.
    init(
        watchlistService: WatchlistServiceProtocol,
        wastchlistStorage: WatchlistStorageProtocol,
        apiClient: APIClientProtocol,
        userDefaults: UserDefaultsProtocol
    ) {
        self.watchlistService = watchlistService
        self.watchlistStorage = wastchlistStorage
        self.apiClient = apiClient
        self.userDefaults = userDefaults
    }
}

extension ServiceProvider {
    /// Creates a default instance of `ServiceProvider` with default implementations  for each service and storage. Useful for standard application setup.
    static func defaultProvider() -> ServiceProvider {
        let apiClient = DefaultAPIClient()
        let defaults = UserDefaults.standard
        return ServiceProvider(
            watchlistService: WatchlistService(apiClient: apiClient),
            wastchlistStorage: WatchlistStorage(userDefaults: defaults),
            apiClient: apiClient,
            userDefaults: defaults
        )
    }
}

/// `AppCoordinatorProvider` protocol defines the required properties for a coordinator
/// to function within the application, specifically the services it needs to perform  its tasks.
protocol AppCoordinatorProvider {
    var watchlistService: WatchlistServiceProtocol { get }
    var userDefaults: UserDefaultsProtocol { get }
    var watchlistStorage: WatchlistStorageProtocol { get }
}

/// Extending `ServiceProvider` to conform to `AppCoordinatorProvider` ensures that  it can be used by coordinators within the application.
extension ServiceProvider: AppCoordinatorProvider {}
