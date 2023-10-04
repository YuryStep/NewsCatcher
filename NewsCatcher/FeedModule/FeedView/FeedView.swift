//
//  FeedView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

import UIKit

protocol FeedViewDelegate: AnyObject {
    func cancelButtonTapped()
    func settingsButtonTapped()
    func didPullToRefreshTableViewData()
}

final class FeedView: UIView {
    private enum Constants {
        static let backgroundColor = UIColor(named: "ncBackground")
        static let spacingMultiplier: CGFloat = 1
        static let cancelButtonTitleText = "Cancel"
        static let searchFieldImageSystemName = "magnifyingglass"
        static let searchFieldPlaceholderText = "Search"
        static let searchFieldImageTintColor = UIColor(named: "ncSearchPlaceholderAccent")
        static let searchFieldBackgroundColor = UIColor(named: "ncSearchFieldBackground")
        static let searchFieldCornerRadius: CGFloat = 8.0
        static let searchFieldLeftViewContainerWidth: CGFloat = 32
        static let searchFieldLeftViewContainerHeight: CGFloat = 20
        static let searchFieldImageXPosition: CGFloat = 8
        static let searchFieldImageYPosition: CGFloat = 0
        static let defaultSearchFieldImageSize = CGSize(width: 20, height: 20)
    }

    weak var delegate: FeedViewDelegate?

    lazy var searchField: UITextField = {
        let textField = makeSearchField()
        let containerView = makeLeftViewSearchFieldContainer()
        textField.leftView = containerView
        textField.leftViewMode = .always
        textField.placeholder = Constants.searchFieldPlaceholderText
        return textField
    }()

    private lazy var searchStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [searchField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.setTitle(Constants.cancelButtonTitleText, for: .normal)
        return button
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.backgroundColor = Constants.backgroundColor
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
        backgroundColor = Constants.backgroundColor
        cancelButton.isEnabled = false
        cancelButton.isHidden = true
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    func showCancelButton() {
        UIView.animate(withDuration: 0.25) {
            self.searchStack.addArrangedSubview(self.cancelButton)
            self.cancelButton.isHidden = false
        } completion: { _ in
            self.cancelButton.isEnabled = true
        }
    }

    func hideCancelButton() {
        searchStack.removeArrangedSubview(cancelButton)
        cancelButton.isHidden = true
        cancelButton.isEnabled = false
    }

    private func setupSubviews() {
        addSubviews([searchStack, tableView, activityIndicator, cancelButton])
        NSLayoutConstraint.activate([
            searchField.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),

            searchStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            searchStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            tableView.topAnchor.constraint(equalToSystemSpacingBelow: searchStack.bottomAnchor, multiplier: Constants.spacingMultiplier),
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

    @objc private func cancelButtonTapped() {
        delegate?.cancelButtonTapped()
    }

    @objc private func didPullToRefreshTableViewData() {
        delegate?.didPullToRefreshTableViewData()
    }

    private func makeSearchField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = Constants.searchFieldBackgroundColor
        textField.clearButtonMode = .always
        textField.borderStyle = .none
        textField.layer.cornerRadius = Constants.searchFieldCornerRadius
        textField.clipsToBounds = true
        return textField
    }

    private func makeLeftViewSearchFieldContainer() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.searchFieldLeftViewContainerWidth, height: Constants.searchFieldLeftViewContainerHeight))
        let imageView = makeSearchPlaceholderImageView()
        containerView.addSubview(imageView)
        return containerView
    }

    private func makeSearchPlaceholderImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: Constants.searchFieldImageSystemName))
        imageView.tintColor = Constants.searchFieldImageTintColor
        let imageSize = imageView.image?.size ?? Constants.defaultSearchFieldImageSize
        imageView.frame = CGRect(x: Constants.searchFieldImageXPosition,
                                 y: Constants.searchFieldImageYPosition,
                                 width: imageSize.width,
                                 height: imageSize.height)
        return imageView
    }
}
