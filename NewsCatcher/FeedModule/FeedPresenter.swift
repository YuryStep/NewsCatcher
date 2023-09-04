//
//  FeedPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.08.2023.
//

import Foundation

class FeedPresenter: FeedOutput {
    
    // MARK: Dependencies
    unowned private var view: FeedInput
    private let dataManager: AppDataManager
    
    // MARK: Initializer
    init(view: FeedInput, dataManager: DataManager) {
        self.view = view
        self.dataManager = dataManager
        dataManager.onDataUpdate = { self.updateFeed() }
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
        print("searchButtonTapped")
    }
    
    func settingsButtonTapped() {
        print("settingsButtonTapped")
    }
    
    func handleMemoryWarning() {
        dataManager.clearCache()
    }
    
    // MARK: Private methods
    
    private func updateFeed() {
        DispatchQueue.main.async {
            self.view.reloadFeedTableView()
        }
    }
}
