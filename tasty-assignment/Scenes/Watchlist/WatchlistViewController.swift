//
//  WatchlistViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 22/01/2024.
//

import Combine
import UIKit

class WatchlistViewController: TypedViewController<UITableView> {
    var viewModel: WatchlistViewModel

    init(viewModel: WatchlistViewModel) {
        self.viewModel = viewModel
        super.init(customView: UITableView())
        customView.separatorStyle = .none
        customView.dataSource = self
        customView.delegate = self
        customView.register(
            WatchlistItemTableViewCell.self,
            forCellReuseIdentifier: String(describing: WatchlistItemTableViewCell.self)
        )
    }

    @available(*, unavailable, message: "You should use init(viewModel:) method.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var cancellables: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.currentWatchlistName
        navigationController?.navigationBar.isHidden = false

        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.customView.reloadData()
            })
            .store(in: &cancellables)
        viewModel.fetchQuotes()
    }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = customView.dequeueReusableCell(withIdentifier: String(describing: WatchlistItemTableViewCell.self)) as? WatchlistItemTableViewCell else {
            return UITableViewCell()
        }
        cell.decorate(with: viewModel.items[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
}
