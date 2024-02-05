//
//  WatchlistViewModel.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import Combine
import Foundation
import XCoordinator

/// ViewModel for managing a watchlist in the application.
final class WatchlistViewModel: ObservableObject {
    /// Indicates whether an empty state should be shown based on the symbols array count.
    var shouldShowEmpty: Bool {
        symbols.isEmpty
    }

    /// The number of rows to be displayed, equivalent to the count of symbols in the watchlist.
    var numberOfRows: Int {
        symbols.count
    }

    /// The name of the current watchlist.
    var currentWatchlistName: String {
        currentWatchlist?.name ?? ""
    }

    /// The current watchlist being managed.
    var currentWatchlist: Watchlist? {
        watchlistStorage.fetchWatchlist(by: watchlistId)
    }

    /// The symbols in the current watchlist.
    var symbols: [String] {
        watchlistStorage.fetchSymbols(fromWatchlist: watchlistId) ?? []
    }

    /// A closure to be called when the view needs to reload its data.
    var reloadData: (() -> Void)?

    private let service: WatchlistServiceProtocol
    private var watchlistStorage: WatchlistStorageProtocol
    private var router: WeakRouter<AppRoute>
    private var watchlistId: UUID

    /// Initializes the ViewModel with the watchlist ID and necessary services.
    /// - Parameters:
    ///   - watchlistId: The UUID of the watchlist.
    ///   - service: Service for watchlist-related network calls.
    ///   - watchlistStorage: Storage service for managing watchlist data.
    ///   - router: Router for handling navigation.
    init(
        watchlistId: UUID,
        service: WatchlistServiceProtocol,
        watchlistStorage: WatchlistStorageProtocol,
        router: WeakRouter<AppRoute>
    ) {
        self.watchlistId = watchlistId
        self.service = service
        self.watchlistStorage = watchlistStorage
        self.router = router
    }

    /// Called when the view is loaded, triggering a reload of data.
    func viewDidLoad() {
        reloadData?()
    }

    /// Fetches quotes for a given symbol.
    /// - Parameter symbol: The symbol for which to fetch quotes.
    /// - Returns: A publisher emitting the fetched quotes or an API error.
    func fetchQuotes(for symbol: String) -> ResultPublisher<StockQuoteResponse, APIError> {
        service.fetchQuotes(for: symbol)
    }

    /// Deletes a symbol from the watchlist.
    /// - Parameter symbol: The symbol to be deleted.
    func delete(symbol: String) {
        guard let id = currentWatchlist?.id else { return }
        watchlistStorage.removeSymbol(from: id, symbol: symbol)
        reloadData?()
    }

    /// Shows details for a given symbol.
    /// - Parameter symbol: The symbol for which to show details.
    func showSymbolDetails(_ symbol: String) {
        router.trigger(.symbolDetails(symbol: symbol))
    }

    /// Navigates to the screen for adding a new symbol to the watchlist.
    func showAddSymbol() {
        guard let id = currentWatchlist?.id else { return }
        router.trigger(.addSymbolToWatchlist(watchlistId: id) { [weak self] in
            self?.reloadData?()
        })
    }

    /// Returns the symbol for a given row index.
    /// - Parameter row: The index of the row.
    /// - Returns: The symbol at the specified row.
    func symbol(for row: Int) -> String {
        symbols[row]
    }

    /// Navigates to the screen for managing watchlists.
    func manageWatchlists() {
        router.trigger(.manageWatchlists)
    }
}
