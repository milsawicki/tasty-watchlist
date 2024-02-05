//
//  MockUserDefaults.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 05/02/2024.
//

import Foundation
@testable import tasty_assignment

class MockUserDefaults: UserDefaultsProtocol {
    var store = [String: Any]()

    func object(forKey defaultName: String) -> Any? {
        return store[defaultName]
    }

    func set(_ value: Any?, forKey defaultName: String) {
        store[defaultName] = value
    }
}

