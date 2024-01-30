//
//  WatchlistViewController.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 22/01/2024.
//

import Combine
import CombineDataSources
import UIKit

class WatchlistViewController: TypedViewController<UITableView> {
    var viewModel: WatchlistViewModel

    init(viewModel: WatchlistViewModel) {
        self.viewModel = viewModel
        super.init(customView: UITableView())
        customView.separatorStyle = .none
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
        setupNavigationController()
        setupBindings()
        viewModel.fetchQuotes()
    }
}

extension WatchlistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = try? viewModel.result.get()[indexPath.row] else { return }
    }
}

private extension WatchlistViewController {
    @objc func addButtonTapped() {
        navigationController?.present(AddWatchlistItemViewController(viewModel: SearchSymbolViewModel()), animated: true)
    }

    @objc func watchlistsButtonTapped() {
        navigationController?.pushViewController(MyWatchlistsViewController(viewModel: MyWatchlistsViewModel()), animated: true)
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
        viewModel
            .$result
            .compactMap { try? $0.get() }
            .receive(on: DispatchQueue.main)
            .bind(
                subscriber: customView.rowsSubscriber(
                    cellIdentifier: String(describing: WatchlistItemTableViewCell.self),
                    cellType: WatchlistItemTableViewCell.self) { cell, _, item in
                        cell.bind(with: item)
                    }
            )
            .store(in: &cancellables)
    }
}
