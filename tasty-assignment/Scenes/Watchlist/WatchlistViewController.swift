//
//  WatchlistViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 22/01/2024.
//

import Combine
import UIKit

class WatchlistViewController: TypedViewController<WatchlistTableView> {
    var viewModel: WatchlistViewModel

    init(viewModel: WatchlistViewModel) {
        self.viewModel = viewModel
        super.init(customView: WatchlistTableView())
        customView.dataSource = self
        customView.delegate = self
        customView.register(WatchlistItemTableViewCell.self, forCellReuseIdentifier: String(describing: WatchlistItemTableViewCell.self))
    }

    @available(*, unavailable, message: "You should use init(viewModel:) method.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        navigationController?.navigationBar.isHidden = false
    }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = customView.dequeueReusableCell(withIdentifier: String(describing: WatchlistItemTableViewCell.self)) as? WatchlistItemTableViewCell else {
            return UITableViewCell()
        }
        cell.decorate(with: WatchlistItem(symbol: "GOOG"))
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
