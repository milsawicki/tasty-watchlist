//
//  EmptyStateView.swift
//  tasty-assignment
//
//  Created by Milan Sawicki on 01/02/2024.
//

import UIKit
class EmptyStateView: UIView {
    var addButtonTapped: (() -> Void)?
    private let messageLabel = UILabel()
    private let actionButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
        setupConstraints()
    }

    private func setupConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.center.equalTo(snp.center)
            make.leading.equalTo(snp.leading).offset(20)
            make.trailing.equalTo(snp.trailing).offset(-20)
        }
        
        actionButton.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(42)
            make.top.equalTo(messageLabel.snp.bottom).offset(20)
        }
    }
    
    private func setUpViews() {
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        actionButton.backgroundColor = .red
        actionButton.layer.cornerRadius = 10
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        actionButton.titleLabel?.font = Typography.bold(size: 14)
        addSubview(messageLabel)
        addSubview(actionButton)
    }

    @objc private func actionButtonTapped() {
        addButtonTapped?()
    }

    func configure(withMessage message: String, buttonText: String) {
        messageLabel.text = message
        actionButton.setTitle(buttonText, for: .normal)
    }
}
