//
//  SettingsView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

protocol SettingsViewDelegate: AnyObject {}

final class SettingsView: UIView {
    enum SettingsSection: Int, CaseIterable {
        case articleParameters
        case searchParameters
    }

    enum ArticleSettings {
        enum CellPosition: Int, CaseIterable {
            case first
            case second
            case third
        }

        enum CellType: CaseIterable {
            case country
            case language
        }
    }

    struct DisplayData {
        let countryCellTitle: String
        let languageCellTitle: String
        let countryPickerItems: [String]
        let languagePickerItems: [String]
        let titleCaption: String
        let descriptionCaption: String
        let contentCaption: String

        var currentCountry: String
        var currentLanguage: String
        var countryPickerIsOn = false
        var languagePickerIsOn = false
        var searchInTitleIsOn: Bool
        var searchInDescriptionIsOn: Bool
        var searchInContentIsOn: Bool
    }

    weak var delegate: SettingsViewDelegate?

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = 800
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(resource: .ncBackground)
        tableView.backgroundColor = UIColor(resource: .ncBackground)
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
