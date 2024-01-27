//
//  APIError.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case responseError
    case parsingError
}
