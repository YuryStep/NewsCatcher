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
    func showAlertWithTitle(_ title: String, text: String)
    func stopFeedDataRefreshing()
}

protocol FeedOutput: AnyObject {
    func didReceiveMemoryWarning()
    func didTapOnSearchButton()
    func didTapOnSettingsButton()
    func didTapOnCell(at indexPath: IndexPath)
    func didPullToRefreshTableViewData()
    func getNumberOfRowsInSection() -> Int
    func getImageData(at indexPath: IndexPath, completion: @escaping (Data?) -> Void)
    func getFeedDisplayData(at indexPath: IndexPath) -> FeedCell.DisplayData
}

import UIKit

final class FeedViewController: UIViewController, FeedViewDelegate {
    enum Constants {
        static let navigationItemTitle = "News Catcher"
        static let defaultAlertButtonText = "OK"
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

    func didPullToRefreshTableViewData() {
        presenter.didPullToRefreshTableViewData()
    }
}

extension FeedViewController: FeedInput {
    func reloadFeedTableView() {
        feedView.tableView.reloadData()
        scrollTableViewBackToTheTop()
    }

    private func scrollTableViewBackToTheTop() {
        guard feedView.tableView.numberOfSections > 0,
              feedView.tableView.numberOfRows(inSection: 0) > 0 else { return }
        feedView.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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

    func showAlertWithTitle(_ title: String, text: String) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.defaultAlertButtonText, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    func stopFeedDataRefreshing() {
        feedView.tableView.refreshControl?.endRefreshing()
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
        cell.configure(with: presenter.getFeedDisplayData(at: indexPath))
        presenter.getImageData(at: indexPath) { imageData in
                cell.setImage(imageData)
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
