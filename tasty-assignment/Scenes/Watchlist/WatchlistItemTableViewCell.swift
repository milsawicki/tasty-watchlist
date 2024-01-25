//
//  WatchlistItemTableViewCell.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 24/01/2024.
//

import UIKit
import SnapKit

class WatchlistItemTableViewCell: UITableViewCell {
    private let symbolNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let bidPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private let askPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private let lastPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    private lazy var wrapperStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [symbolNameLabel, priceStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bidPriceLabel, lastPriceLabel, askPriceLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    // - SeeAlso: UITableViewCell.init(style:reuseIdentifier)
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }


    func setupView() {
        addSubview(wrapperStackView)
        setupConstraints()
    }

    func decorate(with item: WatchlistItem) {
        symbolNameLabel.text = item.symbol
        bidPriceLabel.text = "BID 120"
        askPriceLabel.text = "ASK 121"
        lastPriceLabel.text = "LAST 120.4"
    }
}

private extension WatchlistItemTableViewCell {
    func setupConstraints() {
        wrapperStackView.snp.makeConstraints({ make in
            make.leading.equalTo(self).offset(8)
            make.trailing.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        })
    }
}
