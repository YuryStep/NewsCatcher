//
//  SettingsViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

protocol SettingsInput: AnyObject {
    func getCurrentDisplayData() -> SettingsViewController.DisplayData
    func closeView()
}

protocol SettingsOutput: AnyObject {
    func getSettingsDisplayData() -> SettingsViewController.DisplayData
    func didTapOnCell(at indexPath: IndexPath)
    func didReceiveMemoryWarning()
    func didTapOnSaveButton()
    func didTapOnCancelButton()
}

final class SettingsViewController: UIViewController {
    typealias ArticleSettingsDisplayData = ArticleSettingsCell.DisplayData
    typealias PickerSettingsDisplayData = PickerSettingsCell.DisplayData

    enum Section: Int, CaseIterable {
        case articleSettings
        case searchSettings
    }

    struct ArticleSettings {
        enum CellPosition: Int, CaseIterable {
            case first
            case second
            case third
        }

        enum CellType: Int, CaseIterable {
            case country
            case language
        }
    }

    struct DisplayData {
        var numberOfSections: Int { Section.allCases.count }
        let sectionHeaders: [String]
        let sectionFooters: [String]

        var searchSettingsDisplayData: [SearchSettingsCell.DisplayData]

        let countryCellTitle: String
        let languageCellTitle: String

        let countryPickerItems: [String]
        let languagePickerItems: [String]

        var currentCountry: String
        var currentLanguage: String

        var countryPickerIsOn = false
        var languagePickerIsOn = false

        func getNumberOfRowsInSection(_ section: Int) -> Int? {
            guard let section = Section(rawValue: section) else { return 0 }
            switch section {
            case .articleSettings:
                let articleParametersNumber = ArticleSettings.CellPosition.allCases.count
                guard countryPickerIsOn || languagePickerIsOn else { return articleParametersNumber - 1 }
                return articleParametersNumber
            case .searchSettings:
                return searchSettingsDisplayData.count
            }
        }

        func getTitleForHeaderForSection(_ section: Int) -> String? {
            return sectionHeaders[section]
        }

        func getTitleForFooterForSection(_ section: Int) -> String? {
            return sectionFooters[section]
        }

        func getArticleSettingsDisplayData(type: ArticleSettings.CellType) -> ArticleSettingsCell.DisplayData {
            switch type {
            case .country: return ArticleSettingsDisplayData(title: countryCellTitle, currentValue: currentCountry)
            case .language: return ArticleSettingsDisplayData(title: languageCellTitle, currentValue: currentLanguage)
            }
        }

        func getPickerDisplayData(type: ArticleSettings.CellType) -> PickerSettingsCell.DisplayData {
            switch type {
            case .country: return PickerSettingsDisplayData(items: countryPickerItems, currentValue: currentCountry)
            case .language: return PickerSettingsDisplayData(items: languagePickerItems, currentValue: currentLanguage)
            }
        }

        func getSearchSettingsDisplayData(forCellAt indexPath: IndexPath) -> SearchSettingsCell.DisplayData {
            return searchSettingsDisplayData[indexPath.row]
        }
    }

    private enum Constants {
        static let navigationItemTitle = "Request Settings"
    }

    private var settingsView: SettingsView!
    private var displayData: DisplayData!
    var presenter: SettingsOutput!

    init(presenter: SettingsOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        displayData = presenter.getSettingsDisplayData()
        settingsView = SettingsView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func loadView() {
        view = settingsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        settingsView.tableView.dataSource = self
        settingsView.tableView.delegate = self
        settingsView.tableView.register(ArticleSettingsCell.self)
        settingsView.tableView.register(PickerSettingsCell.self)
        settingsView.tableView.register(SearchSettingsCell.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.didReceiveMemoryWarning()
    }

    @objc func cancelButtonTapped() {
        presenter.didTapOnCancelButton()
    }

    @objc func saveButtonTapped() {
        presenter.didTapOnSaveButton()
    }

    private func setNavigationBar() {
        navigationItem.title = Constants.navigationItemTitle
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
}

// MARK: SettingsInput
extension SettingsViewController: SettingsInput {
    func getCurrentDisplayData() -> DisplayData {
        return displayData
    }

    func closeView() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: TableView DataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        displayData.numberOfSections
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let header = displayData.getTitleForHeaderForSection(section) else { return nil }
        return header
    }

    func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let footerTitle = displayData.getTitleForFooterForSection(section) else { return nil }
        return footerTitle
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = displayData.getNumberOfRowsInSection(section) else { return 0 }
        return numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .articleSettings:
            guard let parameter = ArticleSettings.CellPosition(rawValue: indexPath.row) else { return UITableViewCell() }
            switch parameter {
            case .first:
                return makeArticleSettingsCell(type: .country, in: tableView, cellForRowAt: indexPath)
            case .second:
                if displayData.countryPickerIsOn {
                    return makePickerCell(type: .country, in: tableView, cellForRowAt: indexPath)
                } else {
                    return makeArticleSettingsCell(type: .language, in: tableView, cellForRowAt: indexPath)
                }
            case .third:
                guard displayData.languagePickerIsOn else { return UITableViewCell() }
                return makePickerCell(type: .language, in: tableView, cellForRowAt: indexPath)
            }
        case .searchSettings:
            return makeSearchSettingsCell(tableView, cellForRowAt: indexPath)
        }
    }

    private func makeArticleSettingsCell(type: ArticleSettings.CellType, in tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reuse(ArticleSettingsCell.self, indexPath)
        switch type {
        case .country: cell.configure(with: displayData.getArticleSettingsDisplayData(type: .country))
        case .language: cell.configure(with: displayData.getArticleSettingsDisplayData(type: .language))
        }
        return cell
    }

    private func makePickerCell(type: ArticleSettings.CellType, in tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.reuse(PickerSettingsCell.self, indexPath)
        let pickerDisplayData = displayData.getPickerDisplayData(type: type)
        cell.configure(with: pickerDisplayData)

        cell.pickerValueChangedHandler = { [weak self] newValue in
            guard let self = self else { return }
            switch type {
            case .country: self.displayData.currentCountry = newValue
            case .language: self.displayData.currentLanguage = newValue
            }

            let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            tableView.reloadRows(at: [previousIndexPath], with: .automatic)
        }
        return cell
    }

    private func makeSearchSettingsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reuse(SearchSettingsCell.self, indexPath)
        cell.configure(with: displayData.getSearchSettingsDisplayData(forCellAt: indexPath))
        cell.switchValueChangedHandler = { [weak self] isOn in
            guard let self else { return }
            displayData.searchSettingsDisplayData[indexPath.row].switchIsOn = isOn
        }
        return cell
    }
}

// MARK: TableView Delegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath.section != Section.searchSettings.rawValue else { return nil }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard Section.articleSettings.rawValue == indexPath.section else { return }
        showOrHidePickerAfterTap(tableView, at: indexPath)
        settingsView.tableView.deselectRow(at: indexPath, animated: true)
    }

    private func showOrHidePickerAfterTap(_ tableView: UITableView, at indexPath: IndexPath) {
        guard let cellPosition = ArticleSettings.CellPosition(rawValue: indexPath.row) else { return }
        switch cellPosition {
        case .first:
            if displayData.countryPickerIsOn {
                hideCountryPickerIfNeeded(in: tableView)
            } else {
                showOnlyCountryPicker(in: tableView)
            }
        case .second:
            guard !displayData.countryPickerIsOn else { return }
            if displayData.languagePickerIsOn {
                hideLanguagePickerIfNeeded(in: tableView)
            } else {
                showOnlyLanguagePicker(in: tableView)
            }
        case .third:
            guard !displayData.languagePickerIsOn else { return }
            showOnlyLanguagePicker(in: tableView)
        }
    }

    private func showOnlyCountryPicker(in tableView: UITableView) {
        guard !displayData.countryPickerIsOn else { return }
        hideLanguagePickerIfNeeded(in: tableView)
        displayData.countryPickerIsOn = true
        let newIndexPath = IndexPath(row: ArticleSettings.CellPosition.second.rawValue,
                                     section: Section.articleSettings.rawValue)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }

    private func hideCountryPickerIfNeeded(in tableView: UITableView) {
        guard displayData.countryPickerIsOn else { return }
        displayData.countryPickerIsOn = false
        let pickerIndexPath = IndexPath(row: ArticleSettings.CellPosition.second.rawValue,
                                        section: Section.articleSettings.rawValue)
        tableView.deleteRows(at: [pickerIndexPath], with: .automatic)
    }

    private func showOnlyLanguagePicker(in tableView: UITableView) {
        guard !displayData.languagePickerIsOn else { return }
        hideCountryPickerIfNeeded(in: tableView)
        displayData.languagePickerIsOn = true
        let newIndexPath = IndexPath(row: ArticleSettings.CellPosition.third.rawValue,
                                     section: Section.articleSettings.rawValue)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }

    private func hideLanguagePickerIfNeeded(in tableView: UITableView) {
        guard displayData.languagePickerIsOn else { return }
        displayData.languagePickerIsOn = false
        let pickerIndexPath = IndexPath(row: ArticleSettings.CellPosition.third.rawValue,
                                        section: Section.articleSettings.rawValue)
        tableView.deleteRows(at: [pickerIndexPath], with: .automatic)
    }
}
