//
//  UserDefaultsWrapper.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 05/02/2024.
//

import Foundation


/// A property wrapper that simplifies storing and retrieving values from UserDefaults.
/// This wrapper provides a generic way to interact with UserDefaults, abstracting the
/// underlying `UserDefaults` API and providing type safety.
/// /// Example:
/// ```
/// @UserDefaultsWrapper(key: "userAge", defaultValue: 18)
/// var userAge: Int
/// ```
@propertyWrapper
struct UserDefaultsWrapper<T> {
    let key: String
    let defaultValue: T
    let userDefaults: UserDefaultsProtocol

    /// Initializes a new `UserDefaultsWrapper` instance.
      /// - Parameters:
      ///   - key: The key used to read/write in UserDefaults.
      ///   - defaultValue: The default value to return when no value is found in UserDefaults.
      ///   - userDefaults: An object conforming to `UserDefaultsProtocol`. Defaults to `UserDefaults.standard`.
    init(key: String, defaultValue: T, userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    /// The property's value read from or written to UserDefaults.
    var wrappedValue: T {
        get {
            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}

/// Protocol abstraction for UserDefaults. This allows for dependency injection and
/// easier testing by mocking UserDefaults.
protocol UserDefaultsProtocol {
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
}

/// Conforming the standard `UserDefaults` to `UserDefaultsProtocol`.
extension Foundation.UserDefaults: UserDefaultsProtocol {}

