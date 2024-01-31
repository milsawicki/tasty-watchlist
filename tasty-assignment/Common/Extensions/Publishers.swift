//
//  Publishers.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 27/01/2024.
//

import Combine

extension Publisher {
    func asResult() -> AnyPublisher<AsyncResult<Output, Failure>, Never> {
        map(AsyncResult.success)
            .catch { Just(.failure($0)) }
            .eraseToAnyPublisher()
    }
}
