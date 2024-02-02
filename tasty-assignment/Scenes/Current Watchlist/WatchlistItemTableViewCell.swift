//
//  WatchlistItemTableViewCell.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 24/01/2024.
//

import Combine
import SnapKit
import UIKit
class WatchlistItemTableViewCell: UITableViewCell {
    private lazy var wrapperStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [symbolNameLabel, quotesStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        return stackView
    }()

    private let symbolNameLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bold(size: 16)
        return label
    }()

    private var cancellables: Set<AnyCancellable> = []
    private let quotesStackView = QuotesStackView()

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

    private func bind(_ quotesPublisher: AnyPublisher<AsyncResult<StockQuoteResponse, APIError>, Never>) {
        quotesPublisher
            .compactMap { $0.value?.symbol }
            .assign(to: \.text, on: symbolNameLabel)
            .store(in: &cancellables)

        quotesPublisher
            .compactMap { $0.value?.bidPrice }
            .map { "\($0)" }
            .assign(to: \.text, on: quotesStackView.bidPriceLabel)
            .store(in: &cancellables)

        quotesPublisher
            .compactMap { $0.value?.askPrice }
            .map { "\($0)" }
            .assign(to: \.text, on: quotesStackView.askPriceLabel)
            .store(in: &cancellables)

        quotesPublisher
            .compactMap { $0.value?.latestPrice }
            .map { "\($0)" }
            .assign(to: \.text, on: quotesStackView.lastPriceLabel)
            .store(in: &cancellables)
    }

    func bind(_ symbol: String, with publisher: AnyPublisher<StockQuoteResponse, APIError>) {
        symbolNameLabel.text = symbol

        let quotesPublisher = publisher
            .receive(on: DispatchQueue.main)
            .asResult()

        let timerPublisher = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .flatMap { _ in quotesPublisher }
            .eraseToAnyPublisher()
        bind(quotesPublisher)
        bind(timerPublisher)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
}

private extension WatchlistItemTableViewCell {
    func setupView() {
        selectionStyle = .none
        addSubview(wrapperStackView)
        setupConstraints()
    }

    func setupConstraints() {
        wrapperStackView.snp.makeConstraints { make in
            make.leading.equalTo(self).offset(8)
            make.trailing.equalTo(self).offset(-8)
            make.top.equalTo(self).offset(16)
            make.bottom.equalTo(self).offset(-16)
        }
    }
}
