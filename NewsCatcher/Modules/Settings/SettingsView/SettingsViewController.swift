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

    struct ArticleSettingsParameters {
        enum CellPosition: Int, CaseIterable {
            case first
            case second
            case third
        }

        enum CellType: Int, CaseIterable {
            case country
            case language
            case picker
        }

        enum PickerType {
            case country
            case language
        }
    }

    struct DisplayData {
        var articleSettingsDisplayData: [ArticleSettingsCell.DisplayData]
        var pickerSettingsDisplayData: [PickerSettingsCell.DisplayData]
        var searchSettingsDisplayData: [SearchSettingsCell.DisplayData]
        var numberOfSections: Int { Section.allCases.count }
        let sectionHeaders: [String]
        let sectionFooters: [String]

        var countryPickerIsOn = false
        var languagePickerIsOn = false

        var currentCountry: String {
            didSet {
                articleSettingsDisplayData[0].currentValue = currentCountry
                pickerSettingsDisplayData[0].currentValue = currentCountry
            }
        }
        var currentLanguage: String {
            didSet {
                articleSettingsDisplayData[1].currentValue = currentLanguage
                pickerSettingsDisplayData[1].currentValue = currentLanguage
            }
        }

        func getNumberOfRowsInSection(_ section: Int) -> Int? {
            guard let section = Section(rawValue: section) else { return 0 }
            switch section {
            case .articleParameters:
                let articleParametersNumber = ArticleSettingsParameters.CellPosition.allCases.count
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

        func getArticleSettingsDisplayData(forCellAt indexPath: IndexPath) -> ArticleSettingsCell.DisplayData {
            return articleSettingsDisplayData[indexPath.row]
        }

        func getPickerDisplayData(forCellAt indexPath: IndexPath) -> PickerSettingsCell.DisplayData {
            return pickerSettingsDisplayData[indexPath.row - 1]
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
            guard let parameter = ArticleSettingsParameters.CellPosition(rawValue: indexPath.row) else { return UITableViewCell() }
            switch parameter {
            case .first:
                return makeArticleParametersCell(tableView, cellForRowAt: indexPath)
            case .second:
                if displayData.countryPickerIsOn {
                    return makePickerCell(type: .country, in: tableView, cellForRowAt: indexPath)
                } else {
                    return makeArticleParametersCell(tableView, cellForRowAt: indexPath)
                }
            case .third:
                guard displayData.languagePickerIsOn else { return UITableViewCell() }
                return makePickerCell(type: .language, in: tableView, cellForRowAt: indexPath)
            }
        case .searchPlacesParameters:
            return makeSearchSettingsCell(tableView, cellForRowAt: indexPath)
        }
    }

    private func makeArticleParametersCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let articleSettingsCell: ArticleSettingsCell = dequeueReusableCell(for: tableView, indexPath: indexPath, reuseIdentifier: ArticleSettingsCell.reuseIdentifier)
        articleSettingsCell.configure(with: displayData.getArticleSettingsDisplayData(forCellAt: indexPath))
        return articleSettingsCell
    }

    private func makePickerCell(type: ArticleSettingsParameters.PickerType, in tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pickerCell: PickerSettingsCell = dequeueReusableCell(for: tableView, indexPath: indexPath, reuseIdentifier: PickerSettingsCell.reuseIdentifier)
        pickerCell.configure(with: displayData.getPickerDisplayData(forCellAt: indexPath))
        pickerCell.pickerValueChangedHandler = { [weak self] newValue in
            guard let self else { return }
            switch type {
            case .country:
                displayData.currentCountry = newValue
            case .language:
                displayData.currentLanguage = newValue
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
        guard let parameter = ArticleSettingsParameters.CellPosition(rawValue: indexPath.row) else { return }
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
        let newIndexPath = IndexPath(row: ArticleSettingsParameters.CellPosition.second.rawValue,
                                 section: Section.articleParameters.rawValue)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }

    private func hideCountryPickerIfNeeded(in tableView: UITableView) {
        guard displayData.countryPickerIsOn else { return }
        displayData.countryPickerIsOn = false
        let pickerIndexPath = IndexPath(row: ArticleSettingsParameters.CellPosition.second.rawValue,
                                 section: Section.articleParameters.rawValue)
        tableView.deleteRows(at: [pickerIndexPath], with: .automatic)
    }

    private func showLanguagePicker(in tableView: UITableView) {
        hideCountryPickerIfNeeded(in: tableView)
        guard !displayData.languagePickerIsOn else { return }
        displayData.languagePickerIsOn = true
        let newIndexPath = IndexPath(row: ArticleSettingsParameters.CellPosition.third.rawValue,
                                 section: Section.articleParameters.rawValue)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }

    private func hideLanguagePickerIfNeeded(in tableView: UITableView) {
        guard displayData.languagePickerIsOn else { return }
        displayData.languagePickerIsOn = false
        let pickerIndexPath = IndexPath(row: ArticleSettingsParameters.CellPosition.third.rawValue,
                                 section: Section.articleParameters.rawValue)
        tableView.deleteRows(at: [pickerIndexPath], with: .automatic)
    }
}
