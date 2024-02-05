//
//  UserDefaultsWrapperTest.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 05/02/2024.
//

import XCTest
@testable import tasty_assignment

class UserDefaultsWrapperTests: XCTestCase {
    
    func test_UserDefaultsWrapper() {
        let mockUserDefaults = MockUserDefaults()
        var wrapper = UserDefaultsWrapper(key: "testKey", defaultValue: "Default", userDefaults: mockUserDefaults)

        // Test default value
        XCTAssertEqual(wrapper.wrappedValue, "Default")

        // Test setting a new value
        wrapper.wrappedValue = "NewValue"
        XCTAssertEqual(wrapper.wrappedValue, "NewValue")
        XCTAssertEqual(mockUserDefaults.store["testKey"] as? String, "NewValue")
    }
}
