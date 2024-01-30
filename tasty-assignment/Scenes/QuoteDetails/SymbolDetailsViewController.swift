//
//  SymbolDetailsViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 27/01/2024.
//

import Combine
import UIKit

class SymbolDetailsViewController: TypedViewController<SymbolDetailsView> {
    let viewModel: SymbolDetailsViewModel

    private var cancellables = [AnyCancellable]()
    init(viewModel: SymbolDetailsViewModel) {
        let customView = SymbolDetailsView()
        self.viewModel = viewModel
        super.init(customView: customView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupBindings()
//        customView.quoteView.decorate(with: viewModel.item)
    }
}

private extension SymbolDetailsViewController {
    func setupBindings() {
        viewModel.$item
            .map { $0.symbol }
            .assign(to: \.text, on: customView.symbolLabel)
            .store(in: &cancellables)
        
        viewModel.$item
            .map { $0.companyName }
            .assign(to: \.text, on: customView.quoteDescriptionLabel)
            .store(in: &cancellables)
    }
}

class SymbolDetailsViewModel {
    @Published var item: WatchlistItem

    init(item: WatchlistItem) {
        self.item = item
    }
}
