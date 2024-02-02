//
//  MyWatchlistsViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 31/01/2024.
//

import Foundation
import XCoordinator

final class MyWatchlistsViewModel {
    private let router: WeakRouter<AppRoute>
    private let watchlistStorage: WatchlistStorageProtocol

    var watchlists: [Watchlist] {
        watchlistStorage.loadWatchlists()
    }

    var shouldAllowDelete: Bool {
        watchlists.count > 1
    }

    init(watchlistStorage: WatchlistStorageProtocol, router: WeakRouter<AppRoute>) {
        self.watchlistStorage = watchlistStorage
        self.router = router
    }

    func delete(watchlist: Watchlist) {
        watchlistStorage.removeWatchlist(id: watchlist.id)
    }
    
    func createWatchlist(completion: @escaping (() -> Void)) {
        router.trigger(.createWatchlist(completion: completion))
    }
    
    func didSelect(watchlist: Watchlist) {
        router.trigger(.disSelect(watchlist: watchlist))
    }
    
    func watchlist(for row: Int) -> Watchlist {
        watchlists[row]
    }
}
