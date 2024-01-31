//
//  QuotePricesView.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 27/01/2024.
//

import UIKit

class QuotesStackView: UIView {
    let bidPriceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Typography.bold(size: 12)
        return label
    }()

    let askPriceLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bold(size: 12)
        label.textAlignment = .center
        return label
    }()

    let lastPriceLabel: UILabel = {
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

    private lazy var lastPriceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [lastPriceHeader, lastPriceLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    private lazy var wrappingStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bidStackView, askStackView, lastPriceStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        addSubview(wrappingStackView)
        setupConstraints()
    }

    func decorate(with item: StockQuoteResponse) {
        bidPriceLabel.text = "\(item.bidPrice)"
        askPriceLabel.text = "\(item.askPrice)"
        lastPriceLabel.text = "\(item.latestPrice)"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension QuotesStackView {
    func setupConstraints() {
        wrappingStackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self)
        }
    }
}
