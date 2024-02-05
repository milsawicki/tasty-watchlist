//
//  AppCoordinator.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 01/02/2024.
//

import Foundation
import UIKit
import XCoordinator

/// This enum defines different navigational routes within the application, each associated with specific app functionalities. It conforms to `Route` and is `Equatable` to facilitate route comparisons.
enum AppRoute: Route, Equatable {
    /// Navigates to a screen showing the details of a specific watchlist.
    case showWatchlist(watchlist: Watchlist)
    /// Navigates to a screen for managing all watchlists.
    case manageWatchlists
    ///  Presents a UI to add a symbol to a watchlist, identified by `watchlistId`. The `completion` closure is called after the operation.
    case addSymbolToWatchlist(watchlistId: UUID, completion: () -> Void)
    /// Displays details for a specific financial symbol.
    case symbolDetails(symbol: String)
    /// Presents a UI to create a new watchlist. The `completion` closure is called after creating the watchlist.
    case createWatchlist(completion: () -> Void)
    /// Used for deselecting or performing an action related to a specific watchlist.
    /// - `dismiss`: Represents a route for dismissing the current view or screen.
    case disSelect(watchlist: Watchlist)
    /// Represents a route for dismissing the current view or screen.
    case dismiss
    
    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.manageWatchlists, .manageWatchlists), (.dismiss, .dismiss):
            return true
        case let (.showWatchlist(watchlist1), .showWatchlist(watchlist2)):
            return watchlist1 == watchlist2
        case let (.addSymbolToWatchlist(id1, _), .addSymbolToWatchlist(id2, _)):
            return id1 == id2
        case let (.symbolDetails(symbol1), .symbolDetails(symbol2)):
            return symbol1 == symbol2
        case let (.disSelect(watchlist1), .disSelect(watchlist2)):
            return watchlist1 == watchlist2
        default:
            return false
        }
    }
}

final class AppCoordinator: NavigationCoordinator<AppRoute> {

    let serviceProvider: AppCoordinatorProvider
    init(serviceProvider: ServiceProvider) {
        self.serviceProvider = serviceProvider
        super.init(initialRoute: .manageWatchlists)
    }

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .dismiss:
            return .dismiss()
        case let .showWatchlist(watchlist):
            let viewModel = WatchlistViewModel(
                watchlistId: watchlist.id,
                service: serviceProvider.watchlistService,
                watchlistStorage: serviceProvider.watchlistStorage,
                router: weakRouter
            )
            let viewController = WatchlistViewController(viewModel: viewModel)
            return .push(viewController)
        case .manageWatchlists:
            let viewModel = MyWatchlistsViewModel(watchlistStorage: serviceProvider.watchlistStorage, router: weakRouter)
            let viewController = MyWatchlistsViewController(viewModel: viewModel)
            return .set([viewController])
        case let .symbolDetails(symbol):
            let viewModel = SymbolDetailsViewModel(symbol: symbol, watchlistService: serviceProvider.watchlistService)
            let viewController = SymbolDetailsViewController(viewModel: viewModel)
            return .push(viewController)
        case let .addSymbolToWatchlist(uuid, completion):
            let viewModel = SearchSymbolViewModel(
                service: serviceProvider.watchlistService,
                watchlistStorage: serviceProvider.watchlistStorage,
                router: weakRouter,
                watchlistId: uuid,
                addSymbolCompletion: completion
            )
            let viewController = SearchSymbolViewController(viewModel: viewModel)
            return .present(viewController)
        case let .createWatchlist(completion):
            let viewModel = CreateWatchlistViewModel(watchlistStorage: serviceProvider.watchlistStorage)
            let alertController = UIAlertController(title: "Create new watchlist", message: nil, preferredStyle: .alert)
            alertController.addTextField { textField in
                textField.placeholder = "Watchlist name..."
            }

            let okAction = UIAlertAction(title: "Add", style: .default) { _ in
                if let value = alertController.textFields?.first?.text {
                    viewModel.createWatchlist(with: value)
                    completion()
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            return .present(alertController)
        case let .disSelect(watchlist: watchlist):
            let viewModel = WatchlistViewModel(
                watchlistId: watchlist.id,
                service: serviceProvider.watchlistService,
                watchlistStorage: serviceProvider.watchlistStorage,
                router: weakRouter
            )
            let viewController = WatchlistViewController(viewModel: viewModel)
            return .set([viewController])
        }
    }
}
