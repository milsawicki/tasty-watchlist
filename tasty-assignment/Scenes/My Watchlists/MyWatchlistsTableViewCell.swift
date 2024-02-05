//
//  MyWatchlistsTableViewCell.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 30/01/2024.
//

import UIKit

class MyWatchlistsTableViewCell: UITableViewCell {
    private var watchlistNameLabel = UILabel()

    // - SeeAlso: UITableViewCell.init(style:reuseIdentifier)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(watchlistNameLabel)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(with watchlist: Watchlist) {
        watchlistNameLabel.text = watchlist.name
    }
    
    private func setupView() {
        watchlistNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(snp.leading).offset(16)
        }
    }
}
