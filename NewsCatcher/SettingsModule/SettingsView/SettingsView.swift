//
//  SettingsView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

protocol SettingsViewDelegate: AnyObject {}

final class SettingsView: UIView {
    struct DisplayData {
        let articleSettingsCellDisplayData: [ArticleSettingsCell.DisplayData]
        let searchSettingsCellDisplayData: [SearchSettingsCell.DisplayData]
        let numberOfSections: Int
        let sectionHeaders: [String]
        let sectionFooters: [String]
        let numbersOfRowsInSections: [Int]

        func getNumberOfSections() -> Int {
            return numberOfSections
        }

        func getNumberOfRowsInSection(_ section: Int) -> Int? {
            guard section >= 0, section < numbersOfRowsInSections.count else { return nil }
            return numbersOfRowsInSections[section]
        }

        func getTitleForHeaderForSection(_ section: Int) -> String? {
            guard section >= 0, section < sectionHeaders.count else { return nil }
            return sectionHeaders[section]
        }

        func getTitleForFooterForSection(_ section: Int) -> String? {
            guard section >= 0, section < sectionFooters.count else { return nil }
            return sectionFooters[section]
        }

        func getArticleSettingsCellDisplayData(forCellAt indexPath: IndexPath) -> ArticleSettingsCell.DisplayData {
            return articleSettingsCellDisplayData[indexPath.row]
        }

        func getSearchSettingsCellDisplayData(forCellAt indexPath: IndexPath) -> SearchSettingsCell.DisplayData {
            return searchSettingsCellDisplayData[indexPath.row]
        }
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
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
