//
//  SymbolSearchResultTableViewCell.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 27/01/2024.
//

import UIKit

class SymbolSearchResultTableViewCell: UITableViewCell {
    private lazy var symbolStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [symbolNameLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()

    private lazy var detailsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [listedMarketLabel, typeLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()

    private var symbolNameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bold(size: 14)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.light(size: 12)
        return label
    }()

    private let listedMarketLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = Typography.bold(size: 14)
        return label
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = Typography.light(size: 12)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func decorate(with searchResult: SearchSymbolResponse) {
        symbolNameLabel.text = searchResult.symbol
        descriptionLabel.text = searchResult.description
        listedMarketLabel.text = searchResult.listedMarket
        typeLabel.text = searchResult.instrumentType
    }
}

private extension SymbolSearchResultTableViewCell {
    func setupView() {
        selectionStyle = .none
        addSubview(symbolStackView)
        addSubview(detailsStackView)
        setupConstraints()
    }

    func setupConstraints() {
        symbolStackView.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-8)
            make.width.equalTo(self).multipliedBy(0.7)
        }
        detailsStackView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(8)
            make.trailing.bottom.equalTo(self).offset(-8)
            make.width.equalTo(self).multipliedBy(0.3)
        }
    }
}
