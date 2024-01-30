//
//  Publishers.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 27/01/2024.
//

import Combine

extension Publisher {
    func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        map(Result.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
