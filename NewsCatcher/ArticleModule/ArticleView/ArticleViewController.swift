//
//  ArticleViewController.swift
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
    func viewDidLoad()
    func viewWillAppear()
    func handleMemoryWarning()
    func readInSourceButtonTapped()
    func getImageData(atIndex: Int, completion: @escaping (Data?) -> Void)
}

final class ArticleViewController: UIViewController {
    private enum Constants {
        static let navigationItemTitle = "News Catcher"
    }

    var articleView: ArticleView!
    var presenter: ArticleOutput!

    init(articleView: ArticleView) {
        super.init(nibName: nil, bundle: nil)
        self.articleView = articleView
        self.articleView.delegate = self
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func loadView() {
        view = articleView
        navigationItem.title = Constants.navigationItemTitle
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.handleMemoryWarning()
    }
}

extension ArticleViewController: ArticleInput {
    func updateView() {
        articleView.setNeedsDisplay()
    }

    func getArticleIndex() -> Int? {
        articleView.index
    }

    func setupArticleView(withTitle title: String, content: String, sourceName: String, publishingDate date: String) {
        guard let index = articleView.index else { return }
        articleView.configure(with: nil, title: title, sourceName: sourceName, date: date, content: content)
        presenter.getImageData(atIndex: index) { imageData in
            if let imageData = imageData, let image = UIImage(data: imageData) {
                self.articleView.configure(with: image, title: title, sourceName: sourceName, date: date, content: content)
            }
        }
    }

    func goToWebArticle(sourceURL url: URL) {
        let webArticleViewController = WebArticleViewController(sourceURL: url)
        navigationController?.pushViewController(webArticleViewController, animated: true)
    }
}

extension ArticleViewController: ArticleViewDelegate {
    func readInSourceButtonTapped() {
        presenter.readInSourceButtonTapped()
    }
}
