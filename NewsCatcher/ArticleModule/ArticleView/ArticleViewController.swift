//
//  ArticleViewControler.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

protocol ArticleInput: AnyObject {
    func updateView()
}

protocol ArticleOutput: AnyObject {
    func handleMemoryWarning()
    func getTitle(forArticleIndex: Int) -> String
    func getContent(forArticleIndex: Int) -> String
    func getImageData(forArticleIndex: Int, completion: @escaping (Data?)->())
    func goToWebSourceButtonTapped()
}

class ArticleViewController: UIViewController, ArticleViewDelegate, ArticleInput {
    struct Constants {
        static let navigationItemTitle = "News Catcher New Title"
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
    
    override func didReceiveMemoryWarning() {
        presenter.handleMemoryWarning()
    }
    
    // MARK: Input methods
    func updateView() {
        articleView.setNeedsDisplay()
    }
    
    func goToWebSourceButtonTapped() {
        presenter.goToWebSourceButtonTapped()
    }
    
    //     MARK: Private Methods
    private func setupView() {
        guard let index = articleView.index else { return }
        let title = presenter.getTitle(forArticleIndex: index)
        let content = presenter.getContent(forArticleIndex: index)

        articleView.configure(with: nil, title: title, content: content)

        presenter.getImageData(forArticleIndex: index) { imageData in
            if let imageData = imageData, let image = UIImage(data: imageData) {
                self.articleView.configure(with: image, title: title, content: content)
            }
        }
    }
    
    
}
