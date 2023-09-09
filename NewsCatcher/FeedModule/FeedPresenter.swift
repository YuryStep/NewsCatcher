//
//  FeedPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.08.2023.
//

import Foundation

class FeedPresenter: FeedOutput {
    
    // MARK: Dependencies
    unowned private let view: FeedInput
    private var dataManager: AppDataManager
    
    // MARK: Initializer
    init(view: FeedInput, dataManager: AppDataManager) {
        self.view = view
        self.dataManager = dataManager
    }
    
    // MARK: Public API
    func getNumberOfRowsInSection() -> Int {
        return dataManager.getNumberOfArticles()
    }
    
    func getTitle(forIndexPath indexPath: IndexPath) -> String {
         return dataManager.getTitleForArticle(atIndex: indexPath.row)
    }
    
    func getDescription(forIndexPath indexPath: IndexPath) -> String {
        return dataManager.getDescriptionForArticle(atIndex: indexPath.row)
    }
    
    func getImageData(forIndexPath indexPath: IndexPath, completion: @escaping (Data?)->()) {
        dataManager.getImageDataforArticle(atIndex: indexPath.row) { data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                completion(data)
            }
        }
    }
    
    func getSourceNameForArticle(forIndexPath indexPath: IndexPath) -> String {
        return dataManager.getSourceNameForArticle(atIndex: indexPath.row)
    }
    
    func getPublishingDataForArticle(forIndexPath indexPath: IndexPath) -> String {
        return dataManager.getPublishingDateForArticle(atIndex: indexPath.row)
    }
    
    
    func searchButtonTapped() {
        guard let searchPhrase = view.getSearchFieldText() else { return }
        if searchPhrase.isEmpty {
            view.hideKeyboard()
        } else {
            dataManager.downloadNews(about: searchPhrase, searchCriteria: nil)
            view.hideKeyboard()
        }
    }
    
    func settingsButtonTapped() {
        print("settingsButtonTapped")
    }
    
    func viewWillAppear() {
        self.dataManager.onDataUpdate = { [weak self] in
            self?.updateFeed()
        }
    }
    
    func handleMemoryWarning() {
        dataManager.clearCache()
    }
    
    func handleTapOnCellAt(indexPath: IndexPath) {
        view.showArticle(withIndex: indexPath.row, dataManager: dataManager)
    }
    
    func refreshTableViewData() {
        dataManager.downloadNews(about: nil, searchCriteria: nil)
        /* searchCriteria (and probably keyword) must be sended in
         fiture implementation to save current request proprties.
         */
    }
    
    // MARK: Private methods
    private func updateFeed() {
        DispatchQueue.main.async {
            self.view.reloadFeedTableView()
        }
    }
}
