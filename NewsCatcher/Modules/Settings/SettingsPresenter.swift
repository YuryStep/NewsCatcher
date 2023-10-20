//
//  SettingsPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 28.09.2023.
//

import Foundation

final class SettingsPresenter: SettingsOutput {
    typealias SettingsSection = SettingsView.SettingsSection
    typealias CellPosition = SettingsView.ArticleSettings.CellPosition
    typealias SearchPlaceParameter = SearchSettingsCell.Parameter

    func getNumberOfSections() -> Int {
        return SettingsSection.allCases.count
    }

    func getTitleForHeaderIn(section: Int) -> String {
        guard let section = SettingsSection(rawValue: section) else { return "" }
        return Constants.sectionHeaders[section.rawValue]
    }

    func getTitleForFooterIn(section: Int) -> String {
        guard let section = SettingsSection(rawValue: section) else { return "" }
        return Constants.sectionFooters[section.rawValue]
    }

    func getNumberOfRowsIn(section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        let anyPickerIsOn = view.anyPickerIsOn()
        let maxNumberOfArticleCells = CellPosition.allCases.count
        switch section {
        case .articleParameters: return anyPickerIsOn ? maxNumberOfArticleCells : maxNumberOfArticleCells - 1
        case .searchParameters: return SearchPlaceParameter.allCases.count
        }
    }

    private enum Constants {
        static let sectionHeaders = ["Article Parameters", "Where To Search"]
        static let sectionFooters = [
            "These parameters allow you to specify the language of news articles and the country in which they were published.",
            "These parameters allow you to specify which sections of articles to search for a keyword phrase."
        ]
        static let countryCellTitle = "Country"
        static let languageCellTitle = "Language"
        static let titleCaption = "Title"
        static let descriptionCaption = "Description"
        static let contentCaption = "Content"
    }

    private struct State {
        let availableCountries: [String]
        let availableLanguages: [String]
        let currentCountry: String
        let currentLanguage: String
        let searchInTitlesIsOn: Bool
        let searchInDescriptionsIsOn: Bool
        let searchInContentsIsOn: Bool
    }

    weak var view: SettingsInput!
    private var dataManager: AppDataManager
    private var state: State!

    init(dataManager: AppDataManager) {
        self.dataManager = dataManager
        updateCurrentState()
    }

    func didTapOnSaveButton() {
        guard let view = view else { return }
        let newSearchSettings = getSearchSettingsFrom(view.getCurrentDisplayData())
        dataManager.searchSettings = newSearchSettings
        view.closeView()
    }

    func didTapOnCancelButton() {
        guard let view = view else { return }
        view.closeView()
    }

    func getSettingsDisplayData() -> SettingsViewController.DisplayData {
        return SettingsViewController.DisplayData(
            countryCellTitle: Constants.countryCellTitle,
            languageCellTitle: Constants.languageCellTitle,
            countryPickerItems: state.availableCountries,
            languagePickerItems: state.availableLanguages,
            titleCaption: Constants.titleCaption,
            descriptionCaption: Constants.descriptionCaption,
            contentCaption: Constants.contentCaption,
            currentCountry: state.currentCountry,
            currentLanguage: state.currentLanguage,
            searchInTitleIsOn: state.searchInTitlesIsOn,
            searchInDescriptionIsOn: state.searchInDescriptionsIsOn,
            searchInContentIsOn: state.searchInContentsIsOn)
    }

    func didTapOnCell(at _: IndexPath) {
        // TODO: Finish with article settings logic
    }

    func didReceiveMemoryWarning() {
        dataManager.clearCache()
    }

    private func getSearchSettingsFrom(_ displayData: SettingsViewController.DisplayData) -> SearchSettings {
        let newLanguageSettings = SearchSettings.Language.fromName(displayData.currentLanguage)
        let newCountrySettings = SearchSettings.Country.fromName(displayData.currentCountry)

        return SearchSettings(articleLanguage: newLanguageSettings,
                              publicationCountry: newCountrySettings,
                              searchInTitlesIsOn: displayData.searchInTitleIsOn,
                              searchInDescriptionsIsOn: displayData.searchInDescriptionIsOn,
                              searchInContentsIsOn: displayData.searchInContentIsOn)
    }

    private func updateCurrentState() {
        let searchSettings = dataManager.searchSettings
        let listOfCountries = searchSettings.availableCountries.map { $0.name }
        let listOfLanguages = searchSettings.availableLanguages.map { $0.name }
        let updatedState = State(availableCountries: listOfCountries,
                                 availableLanguages: listOfLanguages,
                                 currentCountry: searchSettings.publicationCountry.name,
                                 currentLanguage: searchSettings.articleLanguage.name,
                                 searchInTitlesIsOn: searchSettings.searchInTitlesIsOn,
                                 searchInDescriptionsIsOn: searchSettings.searchInDescriptionsIsOn,
                                 searchInContentsIsOn: searchSettings.searchInContentsIsOn)
        state = updatedState
    }
}
