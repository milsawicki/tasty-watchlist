//
//  AppCoordinator.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 01/02/2024.
//

import Foundation
import XCoordinator

enum AppRoute: Route {
    case watchlist
    case manageWatchlists
    case addSymbolToWatchlist
    case symbolDetails(symbol: String)
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    let apiClient: APIClient = DefaultAPIClient()
    lazy var watchlistService: WatchlistService = WatchlistService(apiClient: apiClient)
    let watchlistStorage: WatchlistStorageProtocol = WatchlistStorage()
    init() {
        super.init(initialRoute: .watchlist)
    }

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .watchlist:
            let viewModel = WatchlistViewModel(
                service: watchlistService,
                watchlistStorage: watchlistStorage,
                router: weakRouter
            )
            let viewController = WatchlistViewController(viewModel: viewModel)
            return .push(viewController)
        case .manageWatchlists:
            let viewModel = MyWatchlistsViewModel(watchlistStorage: watchlistStorage)
            let viewController = MyWatchlistsViewController(viewModel: viewModel)
            return .push(viewController)
        case let .symbolDetails(symbol):
            let viewModel = SymbolDetailsViewModel(symbol: symbol)
            let viewController = SymbolDetailsViewController(viewModel: viewModel)
            return .push(viewController)
        case .addSymbolToWatchlist:
            let viewModel = SearchSymbolViewModel(service: watchlistService)
            let viewController = AddWatchlistItemViewController(viewModel: viewModel)
            return .present(viewController)
        }
    }
}
