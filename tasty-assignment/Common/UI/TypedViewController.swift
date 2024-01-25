//
//  TypedViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import UIKit

/// Serves as a base for view controllers with programatically created `View`
class TypedViewController<ViewType: UIView>: UIViewController {
    /// Custom typed view.
    var customView: ViewType

    init(customView: ViewType = ViewType()) {
        self.customView = customView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // - SeeAlso: UIViewController.loadView()
    override func loadView() {
        view = customView
    }

    // - SeeAlso: UIViewController.viewDidLoad()
    override func viewDidLoad() {
    }
}
