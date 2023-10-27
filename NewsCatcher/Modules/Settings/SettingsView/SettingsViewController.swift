//
//  SettingsViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

protocol SettingsInput: AnyObject {
    func getCurrentDisplayData() -> SettingsView.DisplayData
    func closeView()
    func anyPickerIsOn() -> Bool
}

protocol SettingsOutput: AnyObject {
    func getSettingsDisplayData() -> SettingsView.DisplayData
    func didTapOnCell(at indexPath: IndexPath)
    func didReceiveMemoryWarning()
    func didTapOnSaveButton()
    func didTapOnCancelButton()

    func getNumberOfSections() -> Int
    func getTitleForHeaderIn(section: Int) -> String
    func getTitleForFooterIn(section: Int) -> String
    func getNumberOfRowsIn(section: Int) -> Int
}

final class SettingsViewController: UIViewController {
    typealias SearchParameter = SearchSettingsCell.Parameter
    typealias DisplayData = SettingsView.DisplayData
    typealias SettingsSection = SettingsView.SettingsSection
    typealias ArticleSettingsCellPosition = SettingsView.ArticleSettings.CellPosition
    typealias ArticleSettingsCellType = SettingsView.ArticleSettings.CellType

    private enum Constants {
        static let navigationItemTitle = "Request Settings"
    }

    private var settingsView: SettingsView!
    var displayData: DisplayData!
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
    func anyPickerIsOn() -> Bool {
        return displayData.countryPickerIsOn || displayData.languagePickerIsOn
    }

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
        presenter.getNumberOfSections()
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.getTitleForHeaderIn(section: section)
    }

    func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        presenter.getTitleForFooterIn(section: section)
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.getNumberOfRowsIn(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .articleParameters:
            guard let parameter = ArticleSettingsCellPosition(rawValue: indexPath.row) else { return UITableViewCell() }
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
        case .searchParameters:
            return makeSearchSettingsCell(tableView, cellForRowAt: indexPath)
        }
    }

    private func makeArticleSettingsCell(type: ArticleSettingsCellType, in tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reuse(ArticleSettingsCell.self, indexPath)
        switch type {
        case .country: cell.configureWith(title: displayData.countryCellTitle, currentValue: displayData.currentCountry)
        case .language: cell.configureWith(title: displayData.languageCellTitle, currentValue: displayData.currentLanguage)
        }
        return cell
    }

    private func makePickerCell(type: ArticleSettingsCellType, in tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.reuse(PickerSettingsCell.self, indexPath)

        switch type {
        case .country:
            cell.configureWith(pickerItems: displayData.countryPickerItems, currentValue: displayData.currentCountry)
            cell.pickerValueChangedHandler = { [weak self] newValue in
                guard let self = self else { return }
                displayData.currentCountry = newValue
                let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                tableView.reloadRows(at: [previousIndexPath], with: .automatic)
            }
        case .language:
            cell.configureWith(pickerItems: displayData.languagePickerItems, currentValue: displayData.currentLanguage)
            cell.pickerValueChangedHandler = { [weak self] newValue in
                guard let self = self else { return }
                displayData.currentLanguage = newValue
                let previousIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                tableView.reloadRows(at: [previousIndexPath], with: .automatic)
            }
        }
        return cell
    }

    private func makeSearchSettingsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let searchParameter = SearchParameter(rawValue: indexPath.row) else { return UITableViewCell() }
        let cell = tableView.reuse(SearchSettingsCell.self, indexPath)

        switch searchParameter {
        case .title:
            cell.configureWith(title: displayData.titleCaption, switchIsOn: displayData.searchInTitleIsOn)
            cell.switchValueChangedHandler = { [weak self] isOn in
                guard let self else { return }
                displayData.searchInTitleIsOn = isOn
            }
        case .description:
            cell.configureWith(title: displayData.descriptionCaption, switchIsOn: displayData.searchInDescriptionIsOn)
            cell.switchValueChangedHandler = { [weak self] isOn in
                guard let self else { return }
                displayData.searchInDescriptionIsOn = isOn
            }
        case .content:
            cell.configureWith(title: displayData.contentCaption, switchIsOn: displayData.searchInContentIsOn)
            cell.switchValueChangedHandler = { [weak self] isOn in
                guard let self else { return }
                displayData.searchInContentIsOn = isOn
            }
        }
        return cell
    }
}

// MARK: TableView Delegate

extension SettingsViewController: UITableViewDelegate {
    func tableView(_: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath.section != SettingsSection.searchParameters.rawValue else { return nil }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard SettingsSection.articleParameters.rawValue == indexPath.section else { return }
        showOrHidePickerAfterTap(tableView, at: indexPath)
        settingsView.tableView.deselectRow(at: indexPath, animated: true)
    }

    private func showOrHidePickerAfterTap(_ tableView: UITableView, at indexPath: IndexPath) {
        guard let cellPosition = ArticleSettingsCellPosition(rawValue: indexPath.row) else { return }
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
        let newIndexPath = IndexPath(row: ArticleSettingsCellPosition.second.rawValue,
                                     section: SettingsSection.articleParameters.rawValue)
        tableView.insertRows(at: [newIndexPath], with: .fade)
    }

    private func hideCountryPickerIfNeeded(in tableView: UITableView) {
        guard displayData.countryPickerIsOn else { return }
        displayData.countryPickerIsOn = false
        let pickerIndexPath = IndexPath(row: ArticleSettingsCellPosition.second.rawValue,
                                        section: SettingsSection.articleParameters.rawValue)
        tableView.deleteRows(at: [pickerIndexPath], with: .fade)
    }

    private func showOnlyLanguagePicker(in tableView: UITableView) {
        guard !displayData.languagePickerIsOn else { return }
        hideCountryPickerIfNeeded(in: tableView)
        displayData.languagePickerIsOn = true
        let newIndexPath = IndexPath(row: ArticleSettingsCellPosition.third.rawValue,
                                     section: SettingsSection.articleParameters.rawValue)
        tableView.insertRows(at: [newIndexPath], with: .fade)
    }

    private func hideLanguagePickerIfNeeded(in tableView: UITableView) {
        guard displayData.languagePickerIsOn else { return }
        displayData.languagePickerIsOn = false
        let pickerIndexPath = IndexPath(row: ArticleSettingsCellPosition.third.rawValue,
                                        section: SettingsSection.articleParameters.rawValue)
        tableView.deleteRows(at: [pickerIndexPath], with: .fade)
    }
}
