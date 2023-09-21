//
//  FeedViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

protocol FeedInput: AnyObject {
    func reloadFeedTableView()
    func showArticle(_ article: Article)
    func getSearchFieldText() -> String?
    func cleanSearchTextField()
    func hideKeyboard()
}

protocol FeedOutput: AnyObject {
    func didReceiveMemoryWarning()
    func didTapOnSearchButton()
    func didTapOnSettingsButton()
    func refreshTableViewData()
    func getNumberOfRowsInSection() -> Int
    func getTitle(at indexPath: IndexPath) -> String
    func getDescription(at indexPath: IndexPath) -> String
    func getImageData(at indexPath: IndexPath, completion: @escaping (Data?) -> Void)
    func getSourceName(at indexPath: IndexPath) -> String
    func getPublishingDate(at indexPath: IndexPath) -> String
    func didTapOnCell(at indexPath: IndexPath)
}

import UIKit

final class FeedViewController: UIViewController, FeedViewDelegate, FeedInput {
    enum Constants {
        static let navigationItemTitle = "News Catcher"
    }

    private var feedView: FeedView!
    var presenter: FeedOutput!

    init(feedView: FeedView) {
        super.init(nibName: nil, bundle: nil)
        self.feedView = feedView
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func loadView() {
        view = feedView
        navigationItem.title = Constants.navigationItemTitle
        feedView.tableView.dataSource = self
        feedView.tableView.delegate = self
        feedView.tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseIdentifier)
        feedView.searchTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.didReceiveMemoryWarning()
    }

    func searchButtonTapped() {
        presenter.didTapOnSearchButton()
    }

    func settingsButtonTapped() {
        presenter.didTapOnSettingsButton()
    }

    func refreshTableViewData() {
        presenter.refreshTableViewData()
    }

    func reloadFeedTableView() {
        feedView.tableView.reloadData()
        scrollTableViewBackToTheTop()
    }

    func showArticle(_ article: Article) {
        let articleViewController = ArticleAssembly.makeModule(for: article)
        navigationController?.pushViewController(articleViewController, animated: true)
    }

    func getSearchFieldText() -> String? {
        return feedView.searchTextField.text
    }

    func cleanSearchTextField() {
        feedView.searchTextField.text = nil
    }

    func hideKeyboard() {
        feedView.searchTextField.endEditing(true)
    }
}

extension FeedViewController {
    private func scrollTableViewBackToTheTop() {
        guard feedView.tableView.numberOfSections > 0,
              feedView.tableView.numberOfRows(inSection: 0) > 0 else { return }
        feedView.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return presenter.getNumberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseIdentifier, for: indexPath) as? FeedCell else {
            return UITableViewCell()
        }
        let title = presenter.getTitle(at: indexPath)
        let sourceName = presenter.getSourceName(at: indexPath)
        let date = presenter.getPublishingDate(at: indexPath)
        let description = presenter.getDescription(at: indexPath)
        cell.configure(withTitle: title, sourceName: sourceName, date: date, description: description)
        presenter.getImageData(at: indexPath) { imageData in
            if let imageData = imageData, let image = UIImage(data: imageData) {
                cell.setImage(image)
            }
        }
        return cell
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapOnCell(at: indexPath)
        feedView.tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FeedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_: UITextField) -> Bool {
        searchButtonTapped()
        return true
    }
}
