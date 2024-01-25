//
//  SceneDelegate.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 22/01/2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let viewController = WatchlistViewController(viewModel: WatchlistViewModel())
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()
    }


}

