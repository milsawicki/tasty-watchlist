//
//  MockAPIClient.swift
//  tasty-assignmentTests
//
//  Created by Milan Sawicki on 06/02/2024.
//

import Combine
import Foundation
@testable import tasty_assignment

class MockAPIClient: APIClientProtocol {
    var fetchBehaviour: ((Request) -> AnyPublisher<Result<Data, APIError>, Never>)?

    func fetch<Response: Decodable>(request: Request) -> ResultPublisher<Response, APIError> {
        guard let behaviour = fetchBehaviour else {
            return .just(.failure(.responseError))
        }

        return behaviour(request)
            .flatMap { result -> ResultPublisher<Response, APIError> in
                switch result {
                case let .success(data):
                    do {
                        let decodedData = try JSONDecoder().decode(Response.self, from: data)
                        return .just(.success(decodedData))
                    } catch {
                        return .just(.failure(.parsingError))
                    }
                case let .failure(error):
                    return Just(.failure(error))
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
