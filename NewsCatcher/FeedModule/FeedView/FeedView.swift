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
        static let spacingMultiplier: CGFloat = 1
        static let settingsButtonImageSystemName = "gearshape"
        static let searchPlaceholderImageSystemName = "magnifyingglass"
        static let searchTextFieldPlaceholderText = "Search"
        static let cancelButtonTitleText = "Cancel"
    }

    private enum LayoutMode {
        case normal
        case search
    }

    weak var delegate: FeedViewDelegate?

    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false

        textField.backgroundColor = UIColor(red: 219 / 255, green: 219 / 255, blue: 224 / 255, alpha: 1)
        textField.clearButtonMode = .always
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8.0
        textField.clipsToBounds = true

        // TODO: Probably this block needs refactoring
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 20))
        let imageView = UIImageView(image: UIImage(systemName: Constants.searchPlaceholderImageSystemName))
        imageView.tintColor = .systemGray
        let imageSize = imageView.image?.size ?? CGSize(width: 20, height: 20)
        imageView.frame = CGRect(x: 8, y: 0, width: imageSize.width, height: imageSize.height)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .always
        textField.placeholder = Constants.searchTextFieldPlaceholderText

        return textField
    }()

    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.setTitle(Constants.cancelButtonTitleText, for: .normal)
        button.isEnabled = false
        button.isHidden = true
        return button
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.cellLayoutMarginsFollowReadableWidth = true
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.backgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1) // TODO: Adjust

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
        backgroundColor = UIColor(red: 242 / 255, green: 242 / 255, blue: 242 / 255, alpha: 1)
        setupSubviews(forLayoutMode: .normal)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
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

    private lazy var searchStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [searchTextField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()

    private func setupSubviews(forLayoutMode _: LayoutMode) {
        let subviews = [searchStack, tableView, activityIndicator, cancelButton]
        subviews.forEach { addSubview($0) }

        let constantConstraints = [
            searchTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),

            searchStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            searchStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            searchStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),

            tableView.topAnchor.constraint(equalToSystemSpacingBelow: searchStack.bottomAnchor, multiplier: Constants.spacingMultiplier),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]

        NSLayoutConstraint.activate(constantConstraints)
    }
}
