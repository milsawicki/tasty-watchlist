//
//  AddWatchlistItem.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 26/01/2024.
//

import UIKit

class SymbolSearchView: UIView {
    var dismissView: (() -> Void)?
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    var searchBar: UITextField = {
        let searchBar = UITextField()
        searchBar.placeholder = "Search for stock symbols"
        searchBar.borderStyle = .roundedRect
        return searchBar
    }()

    var resultTableView: UITableView = UITableView()

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
        addSubview(resultTableView)
        addSubview(cancelButton)
        addSubview(activityIndicator)
        resultTableView.delegate = self
        resultTableView.showsVerticalScrollIndicator = false
        resultTableView.register(SymbolSearchResultTableViewCell.self, forCellReuseIdentifier: String(describing: SymbolSearchResultTableViewCell.self))
        setupConstraints()
    }

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
    private func setupConstraints() {
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
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).offset(-16)
            make.bottom.equalTo(self)
        }
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
        }
    }

    @objc private func cancelButtonTapped() {
        dismissView?()
    }
}
