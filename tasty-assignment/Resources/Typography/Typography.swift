//
//  Typography.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 25/01/2024.
//

import UIKit

/// Default font used in the app.
enum Typography {
    static func bold(size: CGFloat) -> UIFont {
        .boldSystemFont(ofSize: size)
    }

    static func regular(size: CGFloat) -> UIFont {
        .systemFont(ofSize: size)
    }

    static func light(size: CGFloat) -> UIFont {
        .systemFont(ofSize: size, weight: .light)
    }
}
