//
//  ArticleViewControler.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

protocol ArticleInput: AnyObject {
    func updateView()
    func getArticleIndex() -> Int
}

protocol ArticleOutput: AnyObject {
    func viewWillAppear()
    func handleMemoryWarning()
    func getTitleforArticle(atIndex: Int) -> String
    func getContentForArticle(atIndex: Int) -> String
    func getImageData(forArticleIndex: Int, completion: @escaping (Data?)->())
    func getSourceNameForArticle(atIndex index: Int) -> String
    func getPublishingDataForArticle(atIndex index: Int) -> String
    func readInSourceButtonTapped()
}

class ArticleViewController: UIViewController, ArticleViewDelegate, ArticleInput {
    struct Constants {
        static let navigationItemTitle = "News Catcher"
    }
    
    // MARK: Dependencies
    var articleView: ArticleView!
    var presenter: ArticleOutput!
    
    // MARK: Initializers
    init(articleView: ArticleView) {
        super.init(nibName: nil, bundle: nil)
        self.articleView = articleView
        self.articleView.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    // MARK: Lifecycle methods
    override func loadView() {
        view = articleView
        navigationItem.title = Constants.navigationItemTitle
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.viewWillAppear()
    }
    
    override func didReceiveMemoryWarning() {
        presenter.handleMemoryWarning()
    }
    
    // MARK: Input methods
    func updateView() {
        articleView.setNeedsDisplay()
    }
    
    func readInSourceButtonTapped() {
        presenter.readInSourceButtonTapped()
    }
    
    func showWebArticle(sourceURL url: URL) {
        let webArticleViewController = WebArticleViewController(sourceURL: url)
        navigationController?.pushViewController(webArticleViewController, animated: true)
    }
    
    // MARK: Output methods
    func getArticleIndex() -> Int {
        articleView.index! // FIX ForceUnwrapping
    }
    
    //     MARK: Private Methods
    private func setupView() {
        guard let index = articleView.index else { return }
        let title = presenter.getTitleforArticle(atIndex: index)
        let content = presenter.getContentForArticle(atIndex: index)
        let sourceName = presenter.getSourceNameForArticle(atIndex: index)
        let date = presenter.getPublishingDataForArticle(atIndex: index)
        
        articleView.configure(with: nil, title: title, sourceName: sourceName, date: date, content: content)
        
        presenter.getImageData(forArticleIndex: index) { imageData in
            if let imageData = imageData, let image = UIImage(data: imageData) {
                self.articleView.configure(with: image, title: title, sourceName: sourceName, date: date, content: content)
            }
        }
    }
}