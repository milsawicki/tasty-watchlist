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

    private var cancellables: [AnyCancellable] = []

    init(viewModel: MyWatchlistsViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
            let watchlist = viewModel.watchlists[indexPath.row]
            tableView.beginUpdates()
            viewModel.delete(watchlist: watchlist)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        viewModel.watchlists.count <= 1 ? .none : .delete
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let watchlist = viewModel.watchlists[indexPath.row]
        viewModel.didSelect(watchlist: watchlist)
    }
    
    @objc func createWatchlistButtonTapped() {
        viewModel.createWatchlist { [weak self] in
            self?.customView.watchlistsTableView.reloadData()
        }
    }
}
