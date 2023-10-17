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
    enum Section: Int, CaseIterable {
        case articleParameters
        case searchPlacesParameters
    }

    enum ArticleParameters {
        enum CellPosition: Int, CaseIterable {
            case first
            case second
            case third
        }

        enum ParameterType: Int, CaseIterable {
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
            case .articleParameters:
                let articleParametersNumber = ArticleParameters.CellPosition.allCases.count
                guard countryPickerIsOn || languagePickerIsOn else { return articleParametersNumber - 1 }
                return articleParametersNumber
            case .searchPlacesParameters:
                return searchSettingsDisplayData.count
            }
        }

        func getTitleForHeaderForSection(_ section: Int) -> String? {
            return sectionHeaders[section]
        }

        func getTitleForFooterForSection(_ section: Int) -> String? {
            return sectionFooters[section]
        }

        func getArticleSettingsDisplayData(type: ArticleParameters.ParameterType) -> ArticleSettingsCell.DisplayData {
            switch type {
            case .country:
                return ArticleSettingsCell.DisplayData(title: countryCellTitle, currentValue: currentCountry)
            case .language:
                return ArticleSettingsCell.DisplayData(title: languageCellTitle, currentValue: currentLanguage)
            }
        }

        func getPickerDisplayData(type: ArticleParameters.ParameterType) -> PickerSettingsCell.DisplayData {
            switch type {
            case .country:
                return PickerSettingsCell.DisplayData(items: countryPickerItems, currentValue: currentCountry)
            case .language:
                return PickerSettingsCell.DisplayData(items: languagePickerItems, currentValue: currentLanguage)
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
        settingsView.tableView.register(ArticleSettingsCell.self, forCellReuseIdentifier: ArticleSettingsCell.reuseIdentifier)
        settingsView.tableView.register(PickerSettingsCell.self, forCellReuseIdentifier: PickerSettingsCell.reuseIdentifier)
        settingsView.tableView.register(SearchSettingsCell.self, forCellReuseIdentifier: SearchSettingsCell.reuseIdentifier)
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

extension SettingsViewController: SettingsInput {
    func getCurrentDisplayData() -> DisplayData {
        return displayData
    }

    func closeView() {
        dismiss(animated: true, completion: nil)
    }
}

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
        case .articleParameters:
            guard let parameter = ArticleParameters.CellPosition(rawValue: indexPath.row) else { return UITableViewCell() }
            switch parameter {
            case .first:
                return makeArticleParametersCell(type: .country, in: tableView, cellForRowAt: indexPath)
            case .second:
                if displayData.countryPickerIsOn {
                    return makePickerCell(type: .country, in: tableView, cellForRowAt: indexPath)
                } else {
                    return makeArticleParametersCell(type: .language, in: tableView, cellForRowAt: indexPath)
                }
            case .third:
                guard displayData.languagePickerIsOn else { return UITableViewCell() }
                return makePickerCell(type: .language, in: tableView, cellForRowAt: indexPath)
            }
        case .searchPlacesParameters:
            return makeSearchSettingsCell(tableView, cellForRowAt: indexPath)
        }
    }

    private func makeArticleParametersCell(type: ArticleParameters.ParameterType, in tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleSettingsCell: ArticleSettingsCell = dequeueReusableCell(for: tableView, indexPath: indexPath, reuseIdentifier: ArticleSettingsCell.reuseIdentifier)
        switch type {
        case .country: articleSettingsCell.configure(with: displayData.getArticleSettingsDisplayData(type: .country))
        case .language: articleSettingsCell.configure(with: displayData.getArticleSettingsDisplayData(type: .language))
        }
        return articleSettingsCell
    }

    private func makePickerCell(type: ArticleParameters.ParameterType, in tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pickerCell: PickerSettingsCell = dequeueReusableCell(for: tableView, indexPath: indexPath, reuseIdentifier: PickerSettingsCell.reuseIdentifier)

        switch type {
        case .country: pickerCell.configure(with: displayData.getPickerDisplayData(type: .country))
        case .language: pickerCell.configure(with: displayData.getPickerDisplayData(type: .language))
        }

        pickerCell.pickerValueChangedHandler = { [weak self] newValue in
            guard let self else { return }
            switch type {
            case .country: displayData.currentCountry = newValue
            case .language: displayData.currentLanguage = newValue
            }
            tableView.reloadRows(at: [IndexPath(row: indexPath.row - 1, section: indexPath.section)], with: .automatic)
        }
        return pickerCell
    }

    private func makeSearchSettingsCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SearchSettingsCell = dequeueReusableCell(for: tableView, indexPath: indexPath, reuseIdentifier: SearchSettingsCell.reuseIdentifier)
        cell.configure(with: displayData.getSearchSettingsDisplayData(forCellAt: indexPath))
        cell.switchValueChangedHandler = { [weak self] isOn in
            guard let self else { return }
            displayData.searchSettingsDisplayData[indexPath.row].switchIsOn = isOn
        }
        return cell
    }

    private func dequeueReusableCell<T: UITableViewCell>(for tableView: UITableView, indexPath: IndexPath, reuseIdentifier: String) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue cell with identifier: \(reuseIdentifier)")
        }
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath.section != Section.searchPlacesParameters.rawValue else { return nil }
        return indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard Section.articleParameters.rawValue == indexPath.section else { return }
        showOrHidePickerAfterTap(tableView, at: indexPath)
        settingsView.tableView.deselectRow(at: indexPath, animated: true)
    }

    private func showOrHidePickerAfterTap(_ tableView: UITableView, at indexPath: IndexPath) {
        guard let parameter = ArticleParameters.CellPosition(rawValue: indexPath.row) else { return }
        switch parameter {
        case .first:
            if displayData.countryPickerIsOn {
                hideCountryPickerIfNeeded(in: tableView)
            } else {
                showCountryPicker(in: tableView)
            }
        case .second:
            guard !displayData.countryPickerIsOn else { return }
            if displayData.languagePickerIsOn {
                hideLanguagePickerIfNeeded(in: tableView)
            } else {
                showLanguagePicker(in: tableView)
            }
        case .third:
            guard !displayData.languagePickerIsOn else { return }
            showLanguagePicker(in: tableView)
        }
    }

    private func showCountryPicker(in tableView: UITableView) {
        guard !displayData.countryPickerIsOn else { return }
        hideLanguagePickerIfNeeded(in: tableView)
        displayData.countryPickerIsOn = true
        let newIndexPath = IndexPath(row: ArticleParameters.CellPosition.second.rawValue,
                                     section: Section.articleParameters.rawValue)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }

    private func hideCountryPickerIfNeeded(in tableView: UITableView) {
        guard displayData.countryPickerIsOn else { return }
        displayData.countryPickerIsOn = false
        let pickerIndexPath = IndexPath(row: ArticleParameters.CellPosition.second.rawValue,
                                        section: Section.articleParameters.rawValue)
        tableView.deleteRows(at: [pickerIndexPath], with: .automatic)
    }

    private func showLanguagePicker(in tableView: UITableView) {
        hideCountryPickerIfNeeded(in: tableView)
        guard !displayData.languagePickerIsOn else { return }
        displayData.languagePickerIsOn = true
        let newIndexPath = IndexPath(row: ArticleParameters.CellPosition.third.rawValue,
                                     section: Section.articleParameters.rawValue)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }

    private func hideLanguagePickerIfNeeded(in tableView: UITableView) {
        guard displayData.languagePickerIsOn else { return }
        displayData.languagePickerIsOn = false
        let pickerIndexPath = IndexPath(row: ArticleParameters.CellPosition.third.rawValue,
                                        section: Section.articleParameters.rawValue)
        tableView.deleteRows(at: [pickerIndexPath], with: .automatic)
    }
}
