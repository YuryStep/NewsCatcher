//
//  ArticleViewControler.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

protocol ArticleInput: AnyObject {
    func updateView()
    func getArticleIndex() -> Int?
    func setupArticleView(withTitle title: String, content: String, sourceName: String, publishingDate date: String)
    func goToWebArticle(sourceURL: URL)
}

protocol ArticleOutput: AnyObject {
    // lifeCycle
    func viewDidLoad()
    func viewWillAppear()
    func handleMemoryWarning()
    // Output
    func readInSourceButtonTapped()
    func getImageData(forArticleIndex: Int, completion: @escaping (Data?)->())
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
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
    
    func getArticleIndex() -> Int? {
        articleView.index
    }
    
    func setupArticleView(withTitle title: String, content: String, sourceName: String, publishingDate date: String) {
        guard let index = articleView.index else { return }
        articleView.configure(with: nil, title: title, sourceName: sourceName, date: date, content: content)
        presenter.getImageData(forArticleIndex: index) { imageData in
            if let imageData = imageData, let image = UIImage(data: imageData) {
                self.articleView.configure(with: image, title: title, sourceName: sourceName, date: date, content: content)
            }
        }
    }
    
    func goToWebArticle(sourceURL url: URL) {
        let webArticleViewController = WebArticleViewController(sourceURL: url)
        navigationController?.pushViewController(webArticleViewController, animated: true)
    }
    
    // MARK: Output methods
    func readInSourceButtonTapped() {
        presenter.readInSourceButtonTapped()
    }
}
