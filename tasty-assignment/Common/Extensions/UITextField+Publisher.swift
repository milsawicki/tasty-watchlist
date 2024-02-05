//
//  UITextField+Publisher.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import Combine
import UIKit

extension UITextField {
    /// This property utilizes Combine's `AnyPublisher` to create a stream of text changes in a `UITextField`. 
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .compactMap(\.text)
            .eraseToAnyPublisher()
    }
}
