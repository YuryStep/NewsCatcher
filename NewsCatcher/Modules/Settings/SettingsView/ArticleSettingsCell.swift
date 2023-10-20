//
//  ArticleSettingsCell.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

final class ArticleSettingsCell: UITableViewCell {
    private lazy var titleLabel = UILabel(textStyle: .body)
    private lazy var currentValueLabel = UILabel(textStyle: .body,
                                                 color: UIColor(resource: .ncAccent))
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

    func configureWith(title: String, currentValue: String) {
        titleLabel.text = title
        currentValueLabel.text = currentValue
    }

    private func setupSubviews() {
        [titleLabel, currentValueLabel].forEach { stack.addArrangedSubview($0) }
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
