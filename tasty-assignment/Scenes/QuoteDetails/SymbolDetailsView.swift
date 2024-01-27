//
//  QuoteDetailsView.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 27/01/2024.
//

import UIKit

class SymbolDetailsView: UIView {
    let chartView = ChartView()

    let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bold(size: 16)
        label.textAlignment = .center
        return label
    }()

    let quoteDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Typography.bold(size: 12)
        return label
    }()

    let quoteView = QuotePricesView()

    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [symbolLabel, quoteDescriptionLabel])
        stackView.axis = .vertical
        return stackView
    }()

    init() {
        super.init(frame: .zero)
        addSubview(headerStackView)
        addSubview(chartView)
        addSubview(quoteView)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SymbolDetailsView {
    func setupConstraints() {
        headerStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(safeAreaLayoutGuide)
        }

        chartView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.top.equalTo(headerStackView.snp.bottom)
            make.height.equalTo(300)
        }

        quoteView.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom)
            make.leading.trailing.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(84)
        }
    }
}