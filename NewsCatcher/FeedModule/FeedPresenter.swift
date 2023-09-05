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
        self.dataManager.onDataUpdate = { self.updateFeed() }
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
    
    func searchButtonTapped() {
        guard let searchPhrase = view.getSearchFieldText(), !searchPhrase.isEmpty else { return }
        dataManager.downloadNews(about: searchPhrase, searchCriteria: nil)
    }
    
    func settingsButtonTapped() {
        print("settingsButtonTapped")
    }
    
    func handleMemoryWarning() {
        dataManager.clearCache()
    }
    
    func handleTapOnCellAt(indexPath: IndexPath) {
        view.showArticle(withIndex: indexPath.row, dataManager: dataManager)
    }
    
    // MARK: Private methods
    private func updateFeed() {
        DispatchQueue.main.async {
            self.view.reloadFeedTableView()
        }
    }
}
