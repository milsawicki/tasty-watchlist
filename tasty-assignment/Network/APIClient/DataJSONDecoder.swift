//
//  DataJSONDecoder.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import Foundation

/// `TopLevelKeyJSONDecoder` is a custom decoder that extends `JSONDecoder` to handle JSON responses with a top-level "data" key.
///
/// This decoder simplifies the decoding process when the JSON structure includes a top-level "data" key by automatically unwrapping it, allowing you to decode the expected type directly without creating additional container structures.
///
/// Usage:
/// When you expect a JSON response of the form `{ "data": { ... actual data ... } }`, use `TopLevelKeyJSONDecoder` instead of the standard `JSONDecoder`. It extracts the content within the "data" key and decodes it into the specified `Codable` type.
///
/// Example:
/// ```
/// let decoder = TopLevelKeyJSONDecoder()
/// let decodedData = try decoder.decode(MyModel.self, from: jsonData)
/// ```
/// In this example, `MyModel` is directly decoded from the content within the "data" key of the JSON.
///
class TopLevelKeyJSONDecoder: JSONDecoder {
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        let topLevelContainer = try super.decode(TopLevelContainer<T>.self, from: data)
        return topLevelContainer.data
    }
}

struct TopLevelContainer<T: Decodable>: Decodable {
    let data: T
}
