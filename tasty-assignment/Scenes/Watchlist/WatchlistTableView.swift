//
//  WatchlistTableView.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 23/01/2024.
//

import UIKit

class WatchlistTableView: UITableView {
  
    init() {
        super.init(frame: .zero, style: .plain)
    }
    
    @available(*, unavailable, message: "Use init() instead")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
