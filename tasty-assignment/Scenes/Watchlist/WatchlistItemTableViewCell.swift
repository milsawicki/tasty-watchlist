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
        let stackView = UIStackView(arrangedSubviews: [stockStackView, quotesStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    private lazy var stockStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [symbolNameLabel, companyNameLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bold(size: 14)
        return label
    }()

    private let symbolNameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.regular(size: 14)
        return label
    }()

    let quotesStackView = QuotesStackView()

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

    func decorate(with item: StockQuoteResponse) {
        symbolNameLabel.text = item.symbol
        companyNameLabel.text = item.companyName
        quotesStackView.decorate(with: item)
    }
}

private extension WatchlistItemTableViewCell {
    func setupView() {
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
