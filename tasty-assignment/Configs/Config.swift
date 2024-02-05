//
//  Config.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 01/02/2024.
//

import Foundation
import ArkanaKeys
struct Configs {
    struct Network {
        static let tastyApiBaseUrl = "api.tastyworks.com"
        static let iexBaseUrl = "cloud.iexapis.com/stable"
    }

    struct UserDefaultsKeys {
        static let watchlistsStorage = "watchlistsStorage"
    }

    struct Keys {
        static let iex = ArkanaKeys.Keys.Global().iEX_API_KEY
    }
}
