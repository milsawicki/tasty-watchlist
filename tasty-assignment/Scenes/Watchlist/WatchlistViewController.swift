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
        viewModel.fetchQuotes()
    }
}

extension WatchlistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.result.value?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: WatchlistItemTableViewCell.self)) as? WatchlistItemTableViewCell,
              let item = viewModel.result.value?[indexPath.row] else {
            return UITableViewCell()
        }

        cell.decorate(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    }
}

private extension WatchlistViewController {
    @objc func addButtonTapped() {
        navigationController?.present(AddWatchlistItemViewController(viewModel: SearchSymbolViewModel()), animated: true)
    }

    func setupNavigationController() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .red
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.isHidden = false
    }

    func setupBindings() {
        viewModel.$result
            .receive(on: DispatchQueue.main)
            .map { $0.isLoading }
            .sink { [weak self] isLoading in
                isLoading ? self?.customView.loadingIndicator.startAnimating() : self?.customView.loadingIndicator.stopAnimating()
            }
            .store(in: &cancellables)

        viewModel.$result
            .receive(on: DispatchQueue.main)
            .map { $0.isSuccess }
            .assign(to: \.isHidden, on: customView.loadingIndicator)
            .store(in: &cancellables)

        viewModel.$result
            .receive(on: DispatchQueue.main)
            .filter { $0.isSuccess }
            .compactMap { $0.value }
            .sink(receiveValue: { [weak self] _ in
                self?.customView.tableView.reloadData()
            })
            .store(in: &cancellables)
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
