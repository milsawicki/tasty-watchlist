//
//  WatchlistItemTableViewCell.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 24/01/2024.
//

import UIKit

class WatchlistItemTableViewCell: UITableViewCell {
    private let symbolNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let bidPriceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let askPriceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let lastPriceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bidPriceLabel, askPriceLabel, lastPriceLabel])
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

    private func addStackView() {
        priceStackView.backgroundColor = .orange
    }

    func setupView() {
        [
            symbolNameLabel,
            priceStackView,
        ]
        .forEach { addSubview($0) }

        addStackView()
        bidPriceLabel.textAlignment = .center
        askPriceLabel.textAlignment = .center
        lastPriceLabel.textAlignment = .center

        [bidPriceLabel, askPriceLabel, lastPriceLabel]
            .forEach {
                $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
                $0.textColor = .black
            }
        setupConstraints()
    }

    func decorate(with item: WatchlistItem) {
        symbolNameLabel.text = item.symbol
        bidPriceLabel.text = "120"
        askPriceLabel.text = "120"
        lastPriceLabel.text = "120"
    }
}

private extension WatchlistItemTableViewCell {
    func setupConstraints() {
        symbolNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            symbolNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            symbolNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
        ])
        priceStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            priceStackView.topAnchor.constraint(equalTo: topAnchor),
            priceStackView.leadingAnchor.constraint(equalTo: symbolNameLabel.trailingAnchor, constant: 8),
            priceStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            priceStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
