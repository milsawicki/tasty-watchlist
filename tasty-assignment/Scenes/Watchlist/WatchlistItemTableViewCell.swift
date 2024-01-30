//
//  WatchlistItemTableViewCell.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 24/01/2024.
//

import SnapKit
import UIKit


class WatchlistItemTableViewCell: UITableViewCell {
    private lazy var wrapperStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [symbolNameLabel, priceView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    private let symbolNameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bold(size: 14)
        return label
    }()

    let priceView = QuotePricesView()

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

    func bind(with item: StockQuoteResponse) {
        symbolNameLabel.text = "\(item.symbol)"
        priceView.decorate(with: item)
    }
}

private extension WatchlistItemTableViewCell {
    private func setupView() {
        selectionStyle = .none
        addSubview(wrapperStackView)
        setupConstraints()
    }

    func setupConstraints() {
        wrapperStackView.snp.makeConstraints({ make in
            make.leading.equalTo(self).offset(8)
            make.trailing.equalTo(self).offset(-8)
            make.top.equalTo(self).offset(16)
            make.bottom.equalTo(self).offset(-16)
        })
    }
}
