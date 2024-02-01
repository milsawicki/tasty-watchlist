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
    case addSymbolToWatchlist(watchlistId: UUID, completion: () -> ())
    case symbolDetails(symbol: String)
    case dismiss
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
        case .dismiss:
            return .dismiss()
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
        case let .addSymbolToWatchlist(uuid, completion):
            let viewModel = SearchSymbolViewModel(
                service: watchlistService,
                watchlistStorage: watchlistStorage,
                router: weakRouter,
                watchlistId: uuid,
                addSymbolCompletion: completion
            )
            let viewController = SearchSymbolViewController(viewModel: viewModel)
            return .present(viewController)
        }
    }
}
