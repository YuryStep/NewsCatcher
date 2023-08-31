//
//  FeedView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

import UIKit

class FeedView: UIView {
    private struct Constants {
        static let systemSpacingMultiplier: CGFloat = 1
        static let settingsButtonImageSystemName = "gearshape"
        static let searchButtonImageSystemName = "magnifyingglass"
        static let searchTextFieldPlaceholder = "WWDC 2023"
    }

    // MARK: Subviews
    private lazy var settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.settingsButtonImageSystemName), for: .normal)
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.searchTextFieldPlaceholder
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.searchButtonImageSystemName), for: .normal)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    // MARK: Public API
    func getSearchFieldText() -> String? { return searchTextField.text }
    func reloadTableViewData() { tableView.reloadData() }
    
    func tableViewSetup(dataSource: UITableViewDataSource, delegate: UITableViewDelegate, cell: UITableViewCell.Type, identifier: String) {
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        tableView.register(cell, forCellReuseIdentifier: identifier)
    }
    
    // MARK: Private Methods
    @objc private func settingsButtonTapped() {
        
    }

    @objc private func searchButtonTapped() {
        
    }
    
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
            
            settingsButton.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: Constants.systemSpacingMultiplier),
            settingsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            searchTextField.leadingAnchor.constraint(equalToSystemSpacingAfter: settingsButton.trailingAnchor, multiplier: Constants.systemSpacingMultiplier),
            searchTextField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            
            searchButton.leadingAnchor.constraint(equalToSystemSpacingAfter: searchTextField.trailingAnchor, multiplier: Constants.systemSpacingMultiplier),
            searchButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            trailingAnchor.constraint(equalToSystemSpacingAfter: searchButton.trailingAnchor, multiplier: Constants.systemSpacingMultiplier),

            tableView.topAnchor.constraint(equalToSystemSpacingBelow: searchTextField.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}
