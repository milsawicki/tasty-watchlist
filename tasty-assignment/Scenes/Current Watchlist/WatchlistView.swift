//
//  WatchlistView.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 31/01/2024.
//

import UIKit

class WatchlistView: UIView {
    let tableView = UITableView()
    let emptyView = EmptyStateView()
    var addButtonTapped: (() -> Void)? {
        didSet {
            emptyView.addButtonTapped = addButtonTapped
        }
    }

    init() {
        super.init(frame: .zero)
        addSubview(tableView)
        addSubview(emptyView)
        setupConstraints()
        tableView.backgroundView = emptyView
        emptyView.configure(withMessage: "Your watchlist is empty. \nAdd new symbols to start tracking!", buttonText: "Add Symbol")
    }

    @available(*, unavailable, message: "Use init() method instead.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showEmptyView() {
        emptyView.isHidden = false
    }

    func hideEmptyView() {
        emptyView.isHidden = true
    }
}

private extension WatchlistView {
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
