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
        var articleSettingsCellDisplayData: [ArticleSettingsCell.DisplayData]
        var searchSettingsCellDisplayData: [SearchSettingsCell.DisplayData]
        let numberOfSections: Int
        let sectionHeaders: [String]
        let sectionFooters: [String]
        let numbersOfRowsInSections: [Int]

        func getNumberOfRowsInSection(_ section: Int) -> Int? {
            return numbersOfRowsInSections[section]
        }

        func getTitleForHeaderForSection(_ section: Int) -> String? {
            return sectionHeaders[section]
        }

        func getTitleForFooterForSection(_ section: Int) -> String? {
            return sectionFooters[section]
        }

        func getArticleSettingsCellDisplayData(forCellAt indexPath: IndexPath) -> ArticleSettingsCell.DisplayData {
            return articleSettingsCellDisplayData[indexPath.row]
        }

        func getSearchSettingsCellDisplayData(forCellAt indexPath: IndexPath) -> SearchSettingsCell.DisplayData {
            return searchSettingsCellDisplayData[indexPath.row]
        }
    }

    private enum Constants {
        static let backgroundColor = UIColor(named: "NCBackground")
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
        backgroundColor = Constants.backgroundColor
        tableView.backgroundColor = Constants.backgroundColor
        setupSubviews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func setupSubviews() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
