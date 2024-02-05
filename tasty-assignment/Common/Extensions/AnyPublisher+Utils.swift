//
//  AnyPublisher+Utils.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 05/02/2024.
//

import Combine

/// Extension of `AnyPublisher` to provide convenience methods for creating publishers.
extension AnyPublisher {
    /// Creates a publisher that immediately emits a given value and then finishes.
    /// - Parameter output: The value to be emitted by the publisher.
    /// - Returns: An `AnyPublisher` instance that emits the provided value and then completes.
    static func just(_ output: Output) -> Self {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }

    /// Creates a publisher that immediately terminates with the provided error.
    /// - Parameter error: The error with which the publisher should fail.
    /// - Returns: An `AnyPublisher` instance that immediately fails with the provided error.
    static func fail(with error: Failure) -> Self {
        Fail(error: error).eraseToAnyPublisher()
    }
}
