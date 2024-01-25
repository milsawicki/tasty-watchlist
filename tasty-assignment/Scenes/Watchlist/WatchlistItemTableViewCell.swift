//
//  WatchlistItemTableViewCell.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 24/01/2024.
//

import SnapKit
import UIKit

class WatchlistItemTableViewCell: UITableViewCell {
    private let symbolNameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bold(size: 14)
        return label
    }()

    private let bidPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Typography.bold(size: 12)
        return label
    }()

    private let askPriceLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bold(size: 12)
        label.textAlignment = .center
        return label
    }()

    private let lastPriceLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bold(size: 14)
        label.textAlignment = .center
        return label
    }()

    private let askPriceHeader: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "ask".uppercased()
        label.font = Typography.light(size: 12)
        return label
    }()
    
    private let bidPriceHeader: UILabel = {
        let label = UILabel()
        label.text = "bid".uppercased()
        label.textAlignment = .center
        label.font = Typography.light(size: 12)
        return label
    }()
    
    private let lastPriceHeader: UILabel = {
        let label = UILabel()
        label.text = "last".uppercased()
        label.textAlignment = .center
        label.font = Typography.light(size: 12)
        return label
    }()

    private lazy var askStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [askPriceHeader, askPriceLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()

    private lazy var bidStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bidPriceHeader, bidPriceLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()

    private lazy var wrapperStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [symbolNameLabel, priceStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    private lazy var lastPriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [lastPriceHeader, lastPriceLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bidStackView, askStackView, lastPriceStackView])
        stackView.axis = .horizontal
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
        selectionStyle = .none
        addSubview(wrapperStackView)
        setupConstraints()
    }

    func decorate(with item: WatchlistItem) {
        symbolNameLabel.text = "\(item.symbol)"
        bidPriceLabel.text = "\(item.bidPrice)"
        askPriceLabel.text = "\(item.askPrice)"
        lastPriceLabel.text = "\(item.lastPrice)"
    }
}

private extension WatchlistItemTableViewCell {
    func setupConstraints() {
        wrapperStackView.snp.makeConstraints({ make in
            make.leading.equalTo(self).offset(8)
            make.trailing.equalTo(self).offset(-8)
            make.top.equalTo(self).offset(16)
            make.bottom.equalTo(self).offset(-16)
        })
    }
}
