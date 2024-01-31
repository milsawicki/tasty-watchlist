//
//  WatchlistView.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 31/01/2024.
//

import UIKit

class WatchlistView: UIView {
    let tableView = UITableView()

    init() {
        super.init(frame: .zero)
        addSubview(tableView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension WatchlistView {
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
