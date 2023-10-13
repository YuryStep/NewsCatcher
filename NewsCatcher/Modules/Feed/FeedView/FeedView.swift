//
//  FeedView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

import UIKit

protocol FeedViewDelegate: AnyObject {
    func settingsButtonTapped()
    func didPullToRefreshTableViewData()
}

final class FeedView: UIView {
    weak var delegate: FeedViewDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 600
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.backgroundColor = UIColor(resource: .ncBackground)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefreshTableViewData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        return tableView
    }()

    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(resource: .ncBackground)
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupSubviews() {
        addSubviews([tableView, activityIndicator])
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @objc private func settingsButtonTapped() {
        delegate?.settingsButtonTapped()
    }

    @objc private func didPullToRefreshTableViewData() {
        delegate?.didPullToRefreshTableViewData()
    }
}
