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
    
    private lazy var feedTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseIdentifier)
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
    func reloadTableViewData() { feedTableView.reloadData() }
    
    // MARK: Private Methods
    @objc private func settingsButtonTapped() {
        
    }

    @objc private func searchButtonTapped() {
        
    }
    
    private func setupSubviews() {
        let subviews = [settingsButton, searchTextField, searchButton, feedTableView]
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

            feedTableView.topAnchor.constraint(equalToSystemSpacingBelow: searchTextField.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            feedTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

}

extension FeedView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseIdentifier, for: indexPath) as? FeedCell
        else { return UITableViewCell() }
        cell.configure(with: nil,
                       title: "Title No \(indexPath.row + 1)",
                       description: "Very long text with description of the article with number \(indexPath.row), which will probably never ends...")
        
        return cell
    }
}
