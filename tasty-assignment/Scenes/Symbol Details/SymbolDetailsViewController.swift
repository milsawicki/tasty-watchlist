//
//  SymbolDetailsViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 27/01/2024.
//

import Combine
import UIKit

class SymbolDetailsViewController: TypedViewController<SymbolDetailsView> {
    private let viewModel: SymbolDetailsViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SymbolDetailsViewModel) {
        let customView = SymbolDetailsView()
        self.viewModel = viewModel
        super.init(customView: customView)
    }

    @available(*, unavailable, message: "Use init(viewModel: SymbolDetailsViewModel) instead.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .red
        setupBindings()
    }
}

private extension SymbolDetailsViewController {
    func setupBindings() {
        viewModel.$symbol
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.text, on: customView.symbolLabel)
            .store(in: &cancellables)

        viewModel.fetchChartData()
            .receive(on: DispatchQueue.main)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] entries in
                self?.customView.updateChart(with: entries)
            }
            .store(in: &cancellables)

        let quotesPublisher = viewModel.fetchQuotes()
            .receive(on: DispatchQueue.main)
            .asResult()
            .filter { $0.isSuccess }
            .compactMap { $0.value }

        let timerPublisher = Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .flatMap { _ in quotesPublisher }
            .eraseToAnyPublisher()
        
        bind(quotesPublisher.eraseToAnyPublisher())
        bind(timerPublisher.eraseToAnyPublisher())
    }
    
    func bind(_ publisher: AnyPublisher<StockQuoteResponse, Never>) {
        publisher
        .sink { [weak self] response in
            guard let self = self else { return }
            customView.quoteView.askPriceLabel.text = "\(response.askPrice)"
            customView.quoteView.bidPriceLabel.text = "\(response.bidPrice)"
            customView.quoteView.lastPriceLabel.text = "\(response.latestPrice)"
        }
        .store(in: &cancellables)
    }
}
