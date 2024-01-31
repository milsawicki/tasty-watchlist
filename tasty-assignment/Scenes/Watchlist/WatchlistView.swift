//
//  WatchlistView.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 31/01/2024.
//

import UIKit

class WatchlistView: UIView {
    let tableView = UITableView()
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        return indicator
    }()

    init() {
        super.init(frame: .zero)
        addSubview(tableView)
        addSubview(loadingIndicator)
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
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalTo(self)
        }
    }
}
