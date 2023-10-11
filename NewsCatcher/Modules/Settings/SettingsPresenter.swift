//
//  SettingsPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 28.09.2023.
//

import Foundation

final class SettingsPresenter: SettingsOutput {
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

    weak var view: SettingsInput?
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
        let firstArticleSettingsCellDisplayData = ArticleSettingsCell.DisplayData(
            title: Constants.countryCellTitle, currentValue: state.currentCountry
        )

        let secondArticleSettingsCellDisplayData = ArticleSettingsCell.DisplayData(
            title: Constants.languageCellTitle, currentValue: state.currentLanguage
        )

        let articleSettingsCellDisplayData = [firstArticleSettingsCellDisplayData,
                                              secondArticleSettingsCellDisplayData]

        let firstPickerSettingsCellDisplayData = PickerSettingsCell.DisplayData(
            items: state.availableCountries, currentValue: state.currentCountry
        )

        let secondPickerSettingsCellDisplayData = PickerSettingsCell.DisplayData(
            items: state.availableLanguages, currentValue: state.currentLanguage
        )

        let pickerSettingsCellDisplayData = [firstPickerSettingsCellDisplayData,
                                             secondPickerSettingsCellDisplayData]

        let firstSearchSettingsCellDisplayData = SearchSettingsCell.DisplayData(
            title: Constants.titleCaption, switchIsOn: state.searchInTitlesIsOn
        )

        let secondSearchSettingsCellDisplayData = SearchSettingsCell.DisplayData(
            title: Constants.descriptionCaption, switchIsOn: state.searchInDescriptionsIsOn
        )

        let thirdSearchSettingsCellDisplayData = SearchSettingsCell.DisplayData(
            title: Constants.contentCaption, switchIsOn: state.searchInContentsIsOn
        )

        let searchSettingsCellDisplayData = [firstSearchSettingsCellDisplayData,
                                             secondSearchSettingsCellDisplayData,
                                             thirdSearchSettingsCellDisplayData]

        return SettingsViewController.DisplayData(
            articleSettingsDisplayData: articleSettingsCellDisplayData,
            pickerSettingsDisplayData: pickerSettingsCellDisplayData,
            searchSettingsDisplayData: searchSettingsCellDisplayData,
            sectionHeaders: Constants.sectionHeaders,
            sectionFooters: Constants.sectionFooters,
            currentCountry: state.currentCountry,
            currentLanguage: state.currentLanguage
        )
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
                       searchInTitlesIsOn: displayData.searchSettingsDisplayData[0].switchIsOn,
                       searchInDescriptionsIsOn: displayData.searchSettingsDisplayData[1].switchIsOn,
                       searchInContentsIsOn: displayData.searchSettingsDisplayData[2].switchIsOn)
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
