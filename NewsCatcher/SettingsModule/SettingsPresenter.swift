//
//  SettingsPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 28.09.2023.
//

import Foundation

final class SettingsPresenter: SettingsOutput {
    private enum Constants {
        static let numberOfSettingsSections = 2
        static let numbersOfRowsInSettingsSections = [2, 3]
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
        private let availableCountries = [String]()
        private let availableLanguages = [String]()
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
        let userSettings = getSearchSettingsFrom(view.getCurrentDisplayData())
        let newSettings = SearchSettings(searchInTitlesIsOn: userSettings.searchInTitlesIsOn,
                                         searchInDescriptionsIsOn: userSettings.searchInDescriptionsIsOn,
                                         searchInContentsIsOn: userSettings.searchInContentsIsOn)
        dataManager.setSearchSettings(newSettings)
        view.closeView()
    }

    func didTapOnCancelButton() {
        guard let view = view else { return }
        view.closeView()
    }

    func getSettingsDisplayData() -> SettingsView.DisplayData {
        let firstArticleSettingsCellDisplayData = ArticleSettingsCell.DisplayData(
            title: Constants.countryCellTitle, currentValue: state.currentCountry
        )

        let secondArticleSettingsCellDisplayData = ArticleSettingsCell.DisplayData(
            title: Constants.languageCellTitle, currentValue: state.currentLanguage
        )

        let articleSettingsCellDisplayData = [firstArticleSettingsCellDisplayData,
                                              secondArticleSettingsCellDisplayData]

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

        return SettingsView.DisplayData(
            articleSettingsCellDisplayData: articleSettingsCellDisplayData,
            searchSettingsCellDisplayData: searchSettingsCellDisplayData,
            numberOfSections: Constants.numberOfSettingsSections,
            sectionHeaders: Constants.sectionHeaders,
            sectionFooters: Constants.sectionFooters,
            numbersOfRowsInSections: Constants.numbersOfRowsInSettingsSections
        )
    }

    func didTapOnCell(at _: IndexPath) {
        debugPrint("Tap") // TODO: Finish with article settings logic
    }

    func didReceiveMemoryWarning() {
        dataManager.clearCache()
    }

    private func getSearchSettingsFrom(_ displayData: SettingsView.DisplayData) -> SearchSettings {
        SearchSettings(searchInTitlesIsOn: displayData.searchSettingsCellDisplayData[0].switchIsOn,
                       searchInDescriptionsIsOn: displayData.searchSettingsCellDisplayData[1].switchIsOn,
                       searchInContentsIsOn: displayData.searchSettingsCellDisplayData[2].switchIsOn)
    }

    private func updateCurrentState() {
        let searchSettings = dataManager.getCurrentSearchSettings()
        let updatedState = State(currentCountry: searchSettings.publicationCountry,
                                 currentLanguage: searchSettings.articleLanguage,
                                 searchInTitlesIsOn: searchSettings.searchInTitlesIsOn,
                                 searchInDescriptionsIsOn: searchSettings.searchInDescriptionsIsOn,
                                 searchInContentsIsOn: searchSettings.searchInContentsIsOn)
        state = updatedState
    }
}
