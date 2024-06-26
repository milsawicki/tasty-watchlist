//
//  WatchlistViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 22/01/2024.
//

import Combine
import UIKit

final class WatchlistViewController: TypedViewController<WatchlistView> {
    private var viewModel: WatchlistViewModel
    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: WatchlistViewModel) {
        self.viewModel = viewModel
        super.init(customView: WatchlistView())
    }

    @available(*, unavailable, message: "You should use init(viewModel:) method.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.currentWatchlistName
        setupNavigationController()
        setupTableView()
        setupBindings()
        viewModel.viewDidLoad()
    }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WatchlistItemTableViewCell.self)) as? WatchlistItemTableViewCell else {
            return UITableViewCell()
        }

        let symbol = viewModel.symbol(for: indexPath.row)
        cell.bind(symbol, with: viewModel.fetchQuotes(for: symbol))
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let symbol = viewModel.symbol(for: indexPath.row)
        viewModel.showSymbolDetails(symbol)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let symbol = viewModel.symbols[indexPath.row]
            let alert = UIAlertController(title: "Delete Symbol", message: "Are you sure you want to remove \(symbol) from the watchlist?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.viewModel.delete(symbol: symbol)
            }))
            present(alert, animated: true)
        }
    }
}

private extension WatchlistViewController {
    @objc func addButtonTapped() {
        viewModel.showAddSymbol()
    }

    @objc func watchlistsButtonTapped() {
        viewModel.manageWatchlists()
    }

    func setupNavigationController() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .red
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.isHidden = false

        let watchlistsButton = UIBarButtonItem(image: UIImage(systemName: "eyeglasses"), style: .plain, target: self, action: #selector(watchlistsButtonTapped))
        watchlistsButton.tintColor = .red
        navigationItem.leftBarButtonItem = watchlistsButton
    }

    func setupBindings() {
        viewModel.reloadData = { [weak self] in
            guard let self = self else { return }
            customView.emptyView.isHidden = !viewModel.shouldShowEmpty
            self.customView.tableView.reloadData()
        }
    }

    func setupTableView() {
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
        customView.tableView.separatorStyle = .none
        customView.tableView.register(
            WatchlistItemTableViewCell.self,
            forCellReuseIdentifier: String(describing: WatchlistItemTableViewCell.self)
        )
        customView.addButtonTapped = { [weak self] in
            self?.viewModel.showAddSymbol()
        }
    }
}
