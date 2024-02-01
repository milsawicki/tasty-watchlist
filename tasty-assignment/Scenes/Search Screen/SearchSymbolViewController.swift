//
//  AddWatchlistItemViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import Combine
import UIKit

final class SearchSymbolViewController: TypedViewController<SymbolSearchView> {
    private let viewModel: SearchSymbolViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SearchSymbolViewModel) {
        let customView = SymbolSearchView()
        self.viewModel = viewModel
        super.init(customView: customView)
        customView.dismissView = { [weak self] in
            self?.viewModel.dismiss()
        }
    }

    @available(*, unavailable, message: "You should use init(viewModel:) method.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        customView.resultTableView.delegate = self
        customView.resultTableView.dataSource = self
        setupBindings()
    }
}

private extension SearchSymbolViewController {
    func setupBindings() {
        viewModel.bind(query: customView.searchBar.textPublisher)
        viewModel.$searchResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.customView.resultTableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension SearchSymbolViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SymbolSearchResultTableViewCell.self)) as? SymbolSearchResultTableViewCell,
            let searchResult = viewModel.symbol(for: indexPath.row)
        else { return UITableViewCell() }
        cell.decorate(with: searchResult)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchResult = viewModel.searchResult.value?[indexPath.row].symbol else { return }
        viewModel.addSymbolToWatchlist(searchResult)
    }
}
