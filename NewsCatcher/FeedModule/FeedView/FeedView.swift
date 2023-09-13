//
//  FeedView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

import UIKit

protocol FeedViewDelegate: AnyObject {
    func searchButtonTapped()
    func settingsButtonTapped()
    func refreshTableViewData()
}

final class FeedView: UIView {
    private enum Constants {
        static let spacingMultiplier: CGFloat = 1
        static let settingsButtonImageSystemName = "gearshape"
        static let searchButtonImageSystemName = "magnifyingglass"
        static let searchTextFieldPlaceholder = "WWDC 2023"
    }

    weak var delegate: FeedViewDelegate?

    // MARK: Subviews

    lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.settingsButtonImageSystemName), for: .normal)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.searchTextFieldPlaceholder
        textField.clearButtonMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()

    lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.searchButtonImageSystemName), for: .normal)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        return tableView
    }()

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    // MARK: Delegate Methods

    @objc private func settingsButtonTapped() {
        delegate?.settingsButtonTapped()
    }

    @objc private func searchButtonTapped() {
        delegate?.searchButtonTapped()
    }

    @objc private func refreshTableViewData(_ sender: UIRefreshControl) {
        delegate?.refreshTableViewData()
        sender.endRefreshing()
    }

    // MARK: Initial setup methods

    private func setupSubviews() {
        let subviews = [settingsButton, searchTextField, searchButton, tableView]
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        subviews.forEach { addSubview($0) }

        settingsButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        searchTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        searchButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        NSLayoutConstraint.activate([
            settingsButton.heightAnchor.constraint(equalTo: searchTextField.heightAnchor),
            searchButton.heightAnchor.constraint(equalTo: searchTextField.heightAnchor),
            settingsButton.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: Constants.spacingMultiplier),
            settingsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: settingsButton.trailingAnchor, multiplier: Constants.spacingMultiplier),
            searchTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            searchButton.leadingAnchor.constraint(equalToSystemSpacingAfter: searchTextField.trailingAnchor, multiplier: Constants.spacingMultiplier),
            searchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: searchButton.trailingAnchor, multiplier: Constants.spacingMultiplier),
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: searchTextField.bottomAnchor, multiplier: Constants.spacingMultiplier),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
