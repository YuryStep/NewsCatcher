//
//  SearchSettingsCell.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 28.09.2023.
//

import UIKit

final class SearchSettingsCell: UITableViewCell {
    struct DisplayData {
        let title: String
        var switchIsOn: Bool
    }

    static let reuseIdentifier = "SearchSettingsCell"

    var switchValueChangedHandler: ((Bool) -> Void)?

    private lazy var titleLabel = UILabel(textStyle: .body)
    private lazy var switchIndicator: UISwitch = {
        let switchIndicator = UISwitch()
        switchIndicator.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        return switchIndicator
    }()

    @objc private func switchValueChanged() {
        switchValueChangedHandler?(switchIndicator.isOn)
    }

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier _: String?) {
        super.init(style: style, reuseIdentifier: FeedCell.reuseIdentifier)
        setupSubviews()
    }

    func configure(with displayData: DisplayData) {
        titleLabel.text = displayData.title
        switchIndicator.isOn = displayData.switchIsOn
    }

    private func setupSubviews() {
        [titleLabel, switchIndicator].forEach { stack.addArrangedSubview($0) }
        contentView.addSubview(stack)
        let marginGuide = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            stack.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            stack.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
        ])
    }
}
