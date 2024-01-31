//
//  AsyncResult.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 31/01/2024.
//

import Foundation

/// `AsyncResult` is a generic enum used to represent the state of an asynchronous operation.
/// It has three possible states: `pending`, `success`, and `failure`.
/// `Success` and `Failure` are generic types representing the result or error, respectively.
enum AsyncResult<Success, Failure> {
    /// Represents the initial state of an asynchronous operation, indicating that it is in progress.
    case pending

    /// Represents a successful completion of an asynchronous operation, containing the resulting value.
    case success(Success)

    /// Represents a failure of an asynchronous operation, containing an error.
    case failure(Failure)

    /// A computed property that returns `true` if the operation is still in progress.
    var isLoading: Bool {
        switch self {
        case .pending:
            return true
        default:
            return false
        }
    }

    /// A computed property that returns `true` if the operation was successful.
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    /// A computed property that returns the success value if the operation was successful, or `nil` otherwise.
    /// Useful for retrieving the result of the operation if it was successful.
    var value: Success? {
        switch self {
        case let .success(value):
            return value
        case .pending, .failure:
            return nil
        }
    }
}
