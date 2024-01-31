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
        navigationController?.navigationBar.tintColor = .red
        let addWatchlistButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addWatchlistButton.tintColor = .red
        navigationItem.rightBarButtonItem = addWatchlistButton
    }

    @available(*, unavailable, message: "Use init(viewModel: MyWatchlistsViewModel) method instead.  ")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addButtonTapped() {
    }
}

extension MyWatchlistsViewController: UITableViewDataSource {
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
            viewModel.watchlists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

class MyWatchlistsViewModel {
    @Published var watchlists: [Watchlist] = [Watchlist.mocked, Watchlist.mocked]
}