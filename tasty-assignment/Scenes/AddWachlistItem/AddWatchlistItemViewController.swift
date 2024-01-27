//
//  AddWatchlistItemViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import Combine
import CombineDataSources
import UIKit

class AddWatchlistItemViewController: TypedViewController<SymbolSearchView> {
    private let viewModel: SearchSymbolViewModel
    private var cancellables = [AnyCancellable]()

    init(viewModel: SearchSymbolViewModel) {
        let customView = SymbolSearchView()
        self.viewModel = SearchSymbolViewModel()
        super.init(customView: customView)
        customView.dismissView = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    @available(*, unavailable, message: "You should use init(viewModel:) method.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
}

private extension AddWatchlistItemViewController {
    func setupBindings() {
        viewModel.bind(query: customView.searchBar.textPublisher)

        viewModel
            .$searchResult
            .receive(on: DispatchQueue.main)
            .bind(
                subscriber: customView.resultTableView.rowsSubscriber(
                    cellIdentifier: String(describing: SymbolSearchResultTableViewCell.self),
                    cellType: SymbolSearchResultTableViewCell.self,
                    cellConfig: { cell, _, symbolItem in
                        cell.decorate(with: symbolItem)
                    }
                )
            )
            .store(in: &cancellables)
    }
}
