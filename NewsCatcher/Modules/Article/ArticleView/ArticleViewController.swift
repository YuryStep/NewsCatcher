//
//  ArticleViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

protocol ArticleInput: AnyObject {
    func setupArticleView(with: ArticleView.DisplayData)
    func openWebArticle(sourceURL: URL)
}

protocol ArticleOutput: AnyObject {
    func viewDidLoad()
    func didReceiveMemoryWarning()
    func readInSourceButtonTapped()
    func readLaterButtonTapped()
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.navigationItemTitle
        presenter.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.didReceiveMemoryWarning()
    }
}

extension ArticleViewController: ArticleViewDelegate {
    func readLaterButtonTapped() {
        presenter.readLaterButtonTapped()
    }

    func readInSourceButtonTapped() {
        presenter.readInSourceButtonTapped()
    }
}

extension ArticleViewController: ArticleInput {
    func setupArticleView(with displayData: ArticleView.DisplayData) {
        articleView.configure(with: displayData)
    }

    func openWebArticle(sourceURL url: URL) {
        let webArticleViewController = WebArticleViewController(sourceURL: url)
        navigationController?.pushViewController(webArticleViewController, animated: true)
    }
}
