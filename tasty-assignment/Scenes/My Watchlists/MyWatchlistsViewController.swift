//
//  MyWatchlistsViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 30/01/2024.
//

import Combine
import UIKit

class MyWatchlistsViewController: TypedViewController<MyWatchlistsView> {
    let viewModel: MyWatchlistsViewModel

    private var cancellables: Set<AnyCancellable> = []

    init(viewModel: MyWatchlistsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Manage watchlists"
        viewModel.reloadData = { [weak self] in
            self?.customView.watchlistsTableView.reloadData()
        }
        customView.watchlistsTableView.dataSource = self
        customView.watchlistsTableView.delegate = self
        navigationController?.navigationBar.tintColor = .red
        let createWatchlistButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createWatchlistButtonTapped))
        createWatchlistButton.tintColor = .red
        navigationItem.rightBarButtonItem = createWatchlistButton
    }

    @available(*, unavailable, message: "Use init(viewModel: MyWatchlistsViewModel) method instead.  ")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyWatchlistsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.watchlists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MyWatchlistsTableViewCell.self)) as? MyWatchlistsTableViewCell else { return UITableViewCell() }
        cell.bind(with: viewModel.watchlists[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let watchlist = viewModel.watchlist(for: indexPath.row)
            viewModel.delete(watchlist: watchlist)
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        viewModel.shouldAllowDelete ? .delete : .none
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let watchlist = viewModel.watchlist(for: indexPath.row)
        viewModel.didSelect(watchlist: watchlist)
    }
    
    @objc func createWatchlistButtonTapped() {
        viewModel.createWatchlist { [weak self] in
            self?.customView.watchlistsTableView.reloadData()
        }
    }
}
