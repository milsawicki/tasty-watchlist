//
//  AppSettings.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 05/02/2024.
//

import Foundation

protocol AppSettingsProtocol {
    var hasLaunchedBefore: Bool { get set }
}

class AppSettings: AppSettingsProtocol {
    @UserDefaultsWrapper(key: Configs.UserDefaultsKeys.hasLaunchedBefore, defaultValue: false)
    var hasLaunchedBefore: Bool
}
