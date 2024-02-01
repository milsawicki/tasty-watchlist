//
//  AppCoordinator.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 01/02/2024.
//

import Foundation
import UIKit
import XCoordinator

enum AppRoute: Route {
    case showWatchlist(watchlist: Watchlist)
    case manageWatchlists
    case addSymbolToWatchlist(watchlistId: UUID, completion: () -> Void)
    case symbolDetails(symbol: String)
    case createWatchlist(completion: () -> Void)
    case disSelect(watchlist: Watchlist)
    case dismiss
}

class AppCoordinator: NavigationCoordinator<AppRoute> {
    let apiClient: APIClient = DefaultAPIClient()
    lazy var watchlistService: WatchlistService = WatchlistService(apiClient: apiClient)
    let watchlistStorage: WatchlistStorageProtocol = WatchlistStorage()
    init() {
        super.init(initialRoute: .showWatchlist(watchlist: watchlistStorage.loadWatchlists().first!))
    }

    override func prepareTransition(for route: AppRoute) -> NavigationTransition {
        switch route {
        case .dismiss:
            return .dismiss()
        case let .showWatchlist(watchlist):
            let viewModel = WatchlistViewModel(
                watchlistId: watchlist.id,
                service: watchlistService,
                watchlistStorage: watchlistStorage,
                router: weakRouter
            )
            let viewController = WatchlistViewController(viewModel: viewModel)
            return .push(viewController)
        case .manageWatchlists:
            let viewModel = MyWatchlistsViewModel(watchlistStorage: watchlistStorage, router: weakRouter)
            let viewController = MyWatchlistsViewController(viewModel: viewModel)
            return .push(viewController)
        case let .symbolDetails(symbol):
            let viewModel = SymbolDetailsViewModel(symbol: symbol, watchlistService: watchlistService)
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
        case let .createWatchlist(completion):
            let viewModel = CreateWatchlistViewModel(watchlistStorage: watchlistStorage, watchlistService: watchlistService)
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
                service: watchlistService,
                watchlistStorage: watchlistStorage,
                router: weakRouter
            )
            let viewController = WatchlistViewController(viewModel: viewModel)
            return .set([viewController])
        }
    }
}

struct CreateWatchlistViewModel {
    private var watchlistStorage: WatchlistStorageProtocol
    private let watchlistService: WatchlistService

    init(watchlistStorage: WatchlistStorageProtocol, watchlistService: WatchlistService) {
        self.watchlistStorage = watchlistStorage
        self.watchlistService = watchlistService
    }

    func createWatchlist(with name: String) {
        watchlistStorage.addWatchlist(name: name)
    }
}
