//
//  SettingsView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

protocol SettingsViewDelegate: AnyObject {

}

final class SettingsView: UIView {
    private enum Constants {
        static let spacingMultiplier: CGFloat = 1
    }

    weak var delegate: SettingsViewDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.cellLayoutMarginsFollowReadableWidth = true
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupSubviews() {
        let subviews = [tableView]
        subviews.forEach { addSubview($0) }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: Constants.spacingMultiplier),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
