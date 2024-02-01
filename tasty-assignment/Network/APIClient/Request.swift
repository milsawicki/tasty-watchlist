//
//  Request.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import Foundation

/// Describes an entity capable of being converted into url request.
protocol URLRequestConvertible {
    /// Returns the entity converted into url request.
    func asURLRequest() -> URLRequest
}

enum AuthorizationType {
    case none
    case iex
}

/// Represents an api request.
protocol Request: URLRequestConvertible {
    /// Scheme used by this request.
    var scheme: String { get }
    /// Base path against which url should be resolved.
    var basePath: String { get }
    /// Path of the api which is used.
    var apiPath: String { get }
    /// HTTP method used by this request.
    var method: HTTPMethod { get }
    /// Body associated with this request.
    var authorizationType: AuthorizationType { get set }
}

extension Request {
    var scheme: String {
        "https://"
    }

    var authorizationType: AuthorizationType {
        .none
    }

    var headers: [String: String]? {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
    }
}

extension URLRequestConvertible where Self: Request {
    func asURLRequest() -> URLRequest {
        let urlPath = scheme
            .appending(basePath)
            .appending(apiPath)

        let components = URLComponents(string: urlPath)

        guard let url = components?.url else {
            fatalError("Could not initialize URL for path: \(urlPath)")
        }
        var urlRequest = URLRequest(url: url)

        headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }

        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

extension URL {
    /// Returns this URL modified by appending parameter with given value.
    func appending(parameter: String, value: String) -> URL {
        guard var components = URLComponents(string: absoluteString) else {
            return self
        }
        let queryItems = components.queryItems ?? []
        components.queryItems = queryItems + [URLQueryItem(name: parameter, value: value)]
        return components.url ?? self
    }

    /// Returns this URL with financial data token appended.
    func appendingFinancialDataToken() -> URL {
        appending(parameter: "token", value: )
    }
}
