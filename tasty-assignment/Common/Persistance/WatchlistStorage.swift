//
//  WatchlistStorage.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 31/01/2024.
//

import Foundation

/// Protocol for managing a collection of watchlists.
///
/// This protocol defines the necessary operations for managing watchlists,
/// each containing a name and an array of symbols. It supports adding, removing,
/// as well as adding and removing symbols within them.
protocol WatchlistStorageProtocol {
    /// Loads and returns the array of current watchlists.
    ///
    /// - Returns: An array of `Watchlist` objects representing all current watchlists.
    func loadWatchlists() -> [Watchlist]

    /// Adds a new watchlist with to the storage.
    /// - Parameter watchlist: The watchlist for that will be added to storage.
    func addWatchlist(_ watchlist: Watchlist)

    /// Adds a new watchlist with the given name.
    ///
    /// - Parameter name: The name for the new watchlist.
    func addWatchlist(name: String)

    /// Adds a new watchlist with the given name and symbols.
    ///
    /// - Parameters:
    /// - name: The name for the new watchlist.
    /// - symbols: The symbol to be removed from the watchlist.
    func addWatchlist(name: String, with symbols: [String])

    /// Removes a watchlist with the specified id.
    ///
    /// - Parameter id: The id of the watchlist to be removed.
    func removeWatchlist(id: UUID)

    /// Adds a symbol to the specified watchlist.
    ///
    /// - Parameters:
    ///   - watchlistName: The UUID of the watchlist to which the symbol will be added.
    ///   - symbol: The symbol to be added to the watchlist.
    func addSymbol(to watchlistId: UUID, symbol: String)

    /// Removes a symbol from the specified watchlist.
    ///
    /// - Parameters:
    ///   - watchlistId: The id of the watchlist from which the symbol will be removed.
    ///   - symbol: The symbol to be removed from the watchlist.
    func removeSymbol(from watchlistId: UUID, symbol: String)

    /// Fetches a watchlist by its UUID.
    ///
    /// - Parameter id: The UUID of the watchlist to fetch.
    /// - Returns: The `Watchlist` object if found, otherwise `nil`.
    func fetchWatchlist(by id: UUID) -> Watchlist?

    /// Fetches symbols from a watchlist by its UUID.
    ///
    /// - Parameter id: The UUID of the watchlist from which to fetch symbols.
    /// - Returns: An array of symbols if the watchlist is found, otherwise `nil`.
    func fetchSymbols(fromWatchlist id: UUID) -> [String]?

    /// Removes all items from the current watchlist.
    func removeAll()
}

class WatchlistStorage: WatchlistStorageProtocol {
    private let defaults: UserDefaultsProtocol
    private let watchlistKey = Configs.UserDefaultsKeys.watchlistsStorage

    init(userDefaults: UserDefaultsProtocol) {
        self.defaults = userDefaults
    }

    func loadWatchlists() -> [Watchlist] {
        guard let data = defaults.object(forKey: watchlistKey) as? Data else {
            return []
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Watchlist].self, from: data)
        } catch {
            print("Error decoding watchlists: \(error)")
            return []
        }
    }

    private func saveWatchlists(_ watchlists: [Watchlist]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(watchlists)
            defaults.set(data, forKey: watchlistKey)
        } catch {
            print("Error encoding watchlists: \(error)")
        }
    }

    func addWatchlist(_ watchlist: Watchlist) {
        var watchlists = loadWatchlists()
        watchlists.append(watchlist)
        saveWatchlists(watchlists)
    }

    func addWatchlist(name: String) {
        var watchlists = loadWatchlists()
        let newWatchlist = Watchlist(name: name, symbols: [])
        watchlists.append(newWatchlist)
        saveWatchlists(watchlists)
    }

    func removeWatchlist(id: UUID) {
        var watchlists = loadWatchlists()
        watchlists.removeAll { $0.id == id }
        saveWatchlists(watchlists)
    }

    func addSymbol(to watchlistId: UUID, symbol: String) {
        var watchlists = loadWatchlists()
        if let index = watchlists.firstIndex(where: { $0.id == watchlistId }) {
            watchlists[index].symbols.append(symbol)
        }
        saveWatchlists(watchlists)
    }

    func removeSymbol(from watchlistId: UUID, symbol: String) {
        var watchlists = loadWatchlists()
        if let index = watchlists.firstIndex(where: { $0.id == watchlistId }) {
            watchlists[index].symbols.removeAll { $0 == symbol }
        }
        saveWatchlists(watchlists)
    }

    func fetchWatchlist(by id: UUID) -> Watchlist? {
        let watchlists = loadWatchlists()
        return watchlists.first { $0.id == id }
    }

    func fetchSymbols(fromWatchlist id: UUID) -> [String]? {
        let watchlists = loadWatchlists()
        return watchlists.first { $0.id == id }?.symbols
    }
    
    func addWatchlist(name: String, with symbols: [String]) {
        var watchlists = loadWatchlists()
        let newWatchlist = Watchlist(name: name, symbols: symbols)
        watchlists.append(newWatchlist)
        saveWatchlists(watchlists)
    }

    func removeAll() {
        var watchlists = loadWatchlists()
        watchlists.removeAll()
        saveWatchlists(watchlists)
    }
}
