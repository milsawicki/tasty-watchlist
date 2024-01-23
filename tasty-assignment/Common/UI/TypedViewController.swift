//
//  TypedViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import UIKit

/// Serves as a base for view controllers with programatically created `View`
class TypedViewController<ViewType: UIView>: UIViewController {
    init(customView: ViewType = ViewType()) {
        super.init(nibName: nil, bundle: nil)
        self.view = customView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var customView: ViewType {
        guard let customView = view as? ViewType else {
            fatalError("View is not of type \(ViewType.self)")
        }
        return customView
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
