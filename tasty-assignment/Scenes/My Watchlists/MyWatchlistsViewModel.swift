//
//  MyWatchlistsViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 31/01/2024.
//

import Foundation
import XCoordinator

/// ViewModel for managing watchlists in the application.
final class MyWatchlistsViewModel {
    
    ///An optional closure that is called when the watchlist data needs to be reloaded.
    var reloadData: (() -> Void)?

    /// An array of `Watchlist` items, loaded from `watchlistStorage`.
    var watchlists: [Watchlist] {
        watchlistStorage.loadWatchlists()
    }

    /// A Boolean value indicating whether deletion of a watchlist is allowed. Deletion is allowed if there are more than one watchlists.
    var shouldAllowDelete: Bool {
        watchlists.count > 1
    }

    private let router: WeakRouter<AppRoute>
    private let watchlistStorage: WatchlistStorageProtocol

    init(watchlistStorage: WatchlistStorageProtocol, router: WeakRouter<AppRoute>) {
        self.watchlistStorage = watchlistStorage
        self.router = router
    }
 
    /// Deletes a specified watchlist.
    func delete(watchlist: Watchlist) {
        watchlistStorage.removeWatchlist(id: watchlist.id)
        reloadData?()
    }
    
    /// Triggers the creation of a new watchlist.
    func createWatchlist(completion: @escaping (() -> Void)) {
        router.trigger(.createWatchlist(completion: completion))
    }
    
    /// Handles the selection of a watchlist.
    func didSelect(watchlist: Watchlist) {
        router.trigger(.disSelect(watchlist: watchlist))
    }
    
    /// Returns the watchlist for a specified row index.
    func watchlist(for row: Int) -> Watchlist {
        watchlists[row]
    }
}

