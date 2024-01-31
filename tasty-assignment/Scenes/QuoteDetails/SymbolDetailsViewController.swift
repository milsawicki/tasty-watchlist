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
    }
}

private extension SymbolDetailsViewController {
    func setupBindings() {
        viewModel.$symbol
            .compactMap { $0 }
            .assign(to: \.text, on: customView.symbolLabel)
            .store(in: &cancellables)
    }
}

class SymbolDetailsViewModel {
    @Published var symbol: String

    init(symbol: String) {
        self.symbol = symbol
    }
}
