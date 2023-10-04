//
//  ArticleSettingsCell.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

final class ArticleSettingsCell: UITableViewCell {
    struct DisplayData {
        let title: String
        var currentValue: String
    }

    static let reuseIdentifier = "ArticleSettingsCell"

    static func make(for tableView: UITableView, indexPath: IndexPath) -> ArticleSettingsCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as? ArticleSettingsCell else {
            fatalError("Failed to make ArticleSettingsCell")
        }
        return cell
    }

    private lazy var titleLabel = UILabel(textStyle: .body)
    private lazy var currentValueLabel = UILabel(textStyle: .body, color: .systemBlue)
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
        currentValueLabel.text = displayData.currentValue
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
