//
//  APIClient.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import Combine
import Foundation

protocol APIClient {}

class DefaultAPIClient: APIClient {}

extension APIClient {
    /// Fetches data from a network request and decodes the JSON response into a specified `Codable` type.
    ///
    /// The function uses Combine's `AnyPublisher` to provide a stream of data or errors, allowing for clean and reactive data handling.
    ///
    /// - Parameters:
    ///   - request: The network request to be executed. This should be an instance of a `Request` type, encapsulating all the necessary information for making the request (e.g., URL, HTTP method, headers).
    ///   - expectedResponseType: The expected type of the response. The function will try to decode the JSON into this type. The type must conform to the `Codable` protocol.
    ///   - hasTopLevelKey: A boolean indicating whether the JSON response contains a top-level key that should be omitted during the decoding process. Defaults to `false`.
    ///
    /// - Returns: A publisher emitting the decoded response object of type `T` or an error if the operation fails.
    func fetch<T: Codable>(request: Request, expectedResponseType: T.Type, hasTopLevelKey: Bool = false) -> AnyPublisher<T, Error> {
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
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw APIError.responseError
                }
                return output.data
            }
            .decode(type: T.self, decoder: hasTopLevelKey ? TopLevelKeyJSONDecoder() : JSONDecoder())
            .mapError { error -> APIError in
                switch error {
                case is URLError:
                    return .responseError
                case is DecodingError:
                    return .parsingError
                default:
                    return .responseError
                }
            }
            .eraseToAnyPublisher()
    }
}