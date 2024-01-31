//
//  MyWatchlistsView.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 30/01/2024.
//

import UIKit

class MyWatchlistsView: UIView {
    let watchlistsTableView = UITableView()

    init() {
        super.init(frame: .zero)
        addSubview(watchlistsTableView)
        setupConstraints()
        watchlistsTableView.register(MyWatchlistsTableViewCell.self, forCellReuseIdentifier: String(describing: MyWatchlistsTableViewCell.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupConstraints() {
        watchlistsTableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
