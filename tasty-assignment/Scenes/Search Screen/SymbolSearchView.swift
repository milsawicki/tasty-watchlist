//
//  AddWatchlistItem.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import UIKit

class SymbolSearchView: UIView {
    var dismissView: (() -> Void)?

    var activityIndicator = UIActivityIndicatorView(frame: .zero)

    var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.placeholder = "Search for stock symbols"
        return searchBar
    }()

    lazy var emptyView: UIStackView = {
        let label = UILabel()
        label.font = Typography.bold(size: 16)
        label.text = "No symbols found for given query."
        label.textAlignment = .center
        let stackView = UIStackView(arrangedSubviews: [emptyImageView, label])
        stackView.axis = .vertical
        stackView.spacing = 8

        return stackView
    }()

    var resultTableView: UITableView = UITableView()

    private lazy var emptyImageView = {
        let image = UIImage(systemName: "doc.text.magnifyingglass")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .red
        return imageView
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()

    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        addSubview(searchBar)
        addSubview(emptyView)
        addSubview(resultTableView)
        addSubview(cancelButton)
        addSubview(activityIndicator)
        setupTableView()
        setupConstraints()
    }

    @available(*, unavailable, message: "Use init() method instead.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SymbolSearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismissView?()
    }
}

extension SymbolSearchView {
    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.left.equalTo(self).offset(16)
            make.height.equalTo(40)
        }
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
            make.left.equalTo(searchBar.snp.right).offset(8)
            make.right.equalTo(self).offset(-8)
            make.height.equalTo(40)
        }
        resultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.bottom.equalTo(self)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.width.height.equalTo(32)
        }
        emptyView.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)

            make.leading.trailing.equalTo(self)
        }
        emptyImageView.snp.makeConstraints { make in
            make.height.equalTo(self).dividedBy(4)
        }
    }

    func setupTableView() {
        resultTableView.delegate = self
        resultTableView.showsVerticalScrollIndicator = false
        resultTableView.register(SymbolSearchResultTableViewCell.self, forCellReuseIdentifier: String(describing: SymbolSearchResultTableViewCell.self))
    }

    @objc private func cancelButtonTapped() {
        dismissView?()
    }
}
