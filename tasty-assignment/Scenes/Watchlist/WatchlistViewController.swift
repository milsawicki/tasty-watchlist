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
        setupNavigationController()
        setupBindings()
        viewModel.fetchQuotes()
    }

    @objc func addButtonTapped() {
        navigationController?.present(AddWatchlistItemViewController(viewModel: SearchSymbolViewModel())    , animated: true)
    }
    
    private func setupNavigationController() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .red
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupBindings() {
        viewModel.$items
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.customView.reloadData()
            })
            .store(in: &cancellables)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
