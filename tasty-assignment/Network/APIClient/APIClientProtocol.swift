//
//  APIClient.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import Combine
import Foundation

/// A protocol defining the requirements for an API client in the application.
protocol APIClientProtocol {
    /// Executes a network request and returns a publisher for the response.
    ///  The `fetch` method is generic over a `Response` type that conforms to `Decodable`, allowing it to be used with a variety of response types. It takes a `Request` instance, which encapsulates all the necessary information for a network request, and returns a `ResultPublisher`. This publisher emits either the fetched data or an `APIError` in case of failure.
    /// - Parameters:
    ///   - request: A `Request` instance containing all necessary information for the network request.
    ///
    /// - Returns: A `ResultPublisher<Response, APIError>` which is a type alias for `AnyPublisher<Result<Response, APIError>, Never>`. This publisher will emit either a successful response or an error, but never fail itself.
    func fetch<Response: Decodable>(request: Request) -> ResultPublisher<Response, APIError>
}

typealias ResultPublisher<T, E> = AnyPublisher<AsyncResult<T, E>, Never>

final class DefaultAPIClient: APIClientProtocol {
    let jsonDecoder: JSONDecoder

    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
    }

    func fetch<Response: Decodable>(request: Request) -> ResultPublisher<Response, APIError> {
        var urlRequest = request.asURLRequest()

        switch request.authorizationType {
        case .none:
            break
        case .iex:
            urlRequest.url = urlRequest.url?.appendingFinancialDataToken()
        }

        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.headers

        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .flatMap { [weak self] output -> AnyPublisher<AsyncResult<Response, APIError>, Never> in
                guard let self = self else { return AnyPublisher<AsyncResult<Response, APIError>, Never>(Empty()) }
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    return .just(.failure(APIError.responseError))
                }
                if let data = try? self.jsonDecoder.decode(Response.self, from: output.data) {
                    return .just(.success(data))
                } else {
                    return .just(.failure(.parsingError))
                }
            }
            .prepend(AsyncResult.pending)
            .replaceError(with: .failure(.parsingError))
            .eraseToAnyPublisher()
    }
}
