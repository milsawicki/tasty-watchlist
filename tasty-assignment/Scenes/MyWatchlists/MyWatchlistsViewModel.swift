//
//  MyWatchlistsViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 31/01/2024.
//

import Foundation

class MyWatchlistsViewModel {
    private let watchlistStorage: WatchlistStorageProtocol

    var watchlists: [Watchlist] {
        watchlistStorage.loadWatchlists()
    }

    init(watchlistStorage: WatchlistStorageProtocol) {
        self.watchlistStorage = watchlistStorage
    }

    func delete(watchlist: Watchlist) {
    }
}
