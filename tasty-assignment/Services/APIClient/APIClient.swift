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
    func fetch<T: Codable>(request: Request, expectedResponseType: T.Type) -> AnyPublisher<T, Error> {
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
            .decode(type: T.self, decoder: JSONDecoder())
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

enum APIError: Error {
    case invalidURL
    case responseError
    case parsingError
}
