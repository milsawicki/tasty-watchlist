//
//  WatchlistViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 22/01/2024.
//

import Combine
import UIKit

class WatchlistViewController: TypedViewController<WatchlistView> {
    enum Section {
        case main
    }

    var viewModel: WatchlistViewModel
    private var cancellables: [AnyCancellable] = []
    var dataSource: UITableViewDiffableDataSource<Section, StockQuoteResponse>!
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
    }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currentWatchlist.symbols.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WatchlistItemTableViewCell.self)) as? WatchlistItemTableViewCell else {
            return UITableViewCell()
        }

        let symbol = viewModel.currentWatchlist.symbols[indexPath.row]
        cell.bind(with: viewModel.fetchQuotes(for: symbol))

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let symbol = viewModel.symbols[indexPath.row]
        viewModel.showSymbolDetails(symbol)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let symbol = viewModel.symbols[indexPath.row]

            let alert = UIAlertController(title: "Delete Symbol", message: "Are you sure you want to remove \(symbol) from the watchlist?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
                self?.viewModel.delete(symbol: symbol)
                tableView.deleteRows(at: [indexPath], with: .fade)
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
            self?.customView.tableView.reloadData()
        }
    }

    func setupTableView() {
        customView.tableView.dataSource = self
        customView.tableView.separatorStyle = .none
        customView.tableView.register(
            WatchlistItemTableViewCell.self,
            forCellReuseIdentifier: String(describing: WatchlistItemTableViewCell.self)
        )
    }
}
