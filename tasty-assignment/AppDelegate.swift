//
//  AppDelegate.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 22/01/2024.
//

import UIKit
import XCoordinator
import XCoordinatorCombine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupDefaultWatchlist()
        return true
    }

    private func setupDefaultWatchlist() {
        let storage = WatchlistStorage()
        let defaultWatchlists = storage.loadWatchlists()

//        storage.removeAll()
        if defaultWatchlists.isEmpty {
            let defaultWatchlist = Watchlist(name: "My first list", symbols: ["AAPL", "GOOGL", "MSFT"])
            storage.addWatchlist(defaultWatchlist)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
