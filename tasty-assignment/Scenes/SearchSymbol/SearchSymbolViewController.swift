//
//  AddWatchlistItemViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import Combine
import UIKit

class SearchSymbolViewController: TypedViewController<SymbolSearchView> {
    private let viewModel: SearchSymbolViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: SearchSymbolViewModel) {
        let customView = SymbolSearchView()
        self.viewModel = viewModel
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

private extension SearchSymbolViewController {
    func setupBindings() {
        customView.resultTableView.delegate = self
        customView.resultTableView.dataSource = self
        viewModel.bind(query: customView.searchBar.textPublisher)

        let loadingPublisher = viewModel.$searchResult
            .receive(on: DispatchQueue.main)
            .asResult()
            .map { $0.isLoading }

        loadingPublisher
            .sink { [weak self] isLoading in
                isLoading ? self?.customView.activityIndicator.startAnimating() : self?.customView.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)

        viewModel.$searchResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.customView.resultTableView.reloadData()
            }
            .store(in: &cancellables)
//        loadingPublisher
//            .map { !$0 }
//            .assign(to: \.isHidden, on: customView.activityIndicator)
//            .store(in: &cancellables)
    }
}

extension SearchSymbolViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchResult.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SymbolSearchResultTableViewCell.self)) as? SymbolSearchResultTableViewCell,
            let searchResult = viewModel.searchResult.value?[indexPath.row]
        else { return UITableViewCell() }
        cell.decorate(with: searchResult)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchResult = viewModel.searchResult.value?[indexPath.row].symbol else { return }
        viewModel.addSymbolToWatchlist(searchResult)
    }
}
