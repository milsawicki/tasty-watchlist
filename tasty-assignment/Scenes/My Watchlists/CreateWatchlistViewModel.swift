//
//  CreateWatchlistViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 05/02/2024.
//

import Foundation

/// ViewModel for creating a new watchlist.
struct CreateWatchlistViewModel {
    private let watchlistStorage: WatchlistStorageProtocol

    init(watchlistStorage: WatchlistStorageProtocol) {
        self.watchlistStorage = watchlistStorage
    }

    /// Creates a new watchlist with the given name.
    /// - Parameter name: A `String` representing the name of the new watchlist
    func createWatchlist(with name: String) {
        watchlistStorage.addWatchlist(name: name)
    }
}
