//
//  FeedPresenter.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.08.2023.
//

import Foundation

struct TempArticle {
    let title = "Article Title"
    let description = "Very long text with description of the article which is probably never ends..."
    var imageData: Data?
}

class FeedPresenter {
    
    // MARK: Dependencies
    weak var view: FeedViewController!
    var articles = [TempArticle()]
    
    // MARK: Initializer
    init(view: FeedViewController) {
        self.view = view
    }
        
    // MARK: Public API
    func getNumberOfRowsInSection() -> Int {
        return articles.count
    }
    
    func getTitle(forIndexPath indexPath: IndexPath) -> String {
        return articles[indexPath.row].title
    }
    
    func getDescription(forIndexPath indexPath: IndexPath) -> String {
        return articles[indexPath.row].description
    }

    func getImageData(forIndexPath: IndexPath, completion: @escaping (Data?)->()) {
            completion(nil)
        }
    
}
