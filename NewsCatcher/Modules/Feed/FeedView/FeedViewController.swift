//
//  FeedViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

import UIKit

protocol FeedInput: AnyObject {
    func reloadFeedTableView()
    func showArticle(_ article: Article)
    func showSettings()
    func getSearchFieldText() -> String?
    func cleanSearchTextField()
    func deactivateSearchField()
    func showAlertWithTitle(_ title: String, text: String)
    func stopFeedDataRefreshing()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showCancelButton()
    func hideCancelButton()
    func showNavigationBar()
    func hideNavigationBar()
}

protocol FeedOutput: AnyObject {
    func didReceiveMemoryWarning()
    func didTapOnCancelButton()
    func didTapOnSettingsButton()
    func didTapOnCell(at indexPath: IndexPath)
    func didPullToRefreshTableViewData()
    func getNumberOfRowsInSection() -> Int
    func getImageData(at indexPath: IndexPath, completion: @escaping (Data?) -> Void)
    func getFeedDisplayData(at indexPath: IndexPath) -> FeedCell.DisplayData
    func textFieldDidBeginEditing()
    func textFieldShouldReturn()
}

final class FeedViewController: UIViewController, FeedViewDelegate {
    private enum Constants {
        static let navigationItemTitle = "News Catcher"
        static let defaultAlertButtonText = "OK"
        static let settingsButtonTitle = "Settings"
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
        setNavigationBar()
        assignDelegationAndDataSource()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.didReceiveMemoryWarning()
    }

    func cancelButtonTapped() {
        presenter.didTapOnCancelButton()
    }

    @objc func settingsButtonTapped() {
        presenter.didTapOnSettingsButton()
    }

    func didPullToRefreshTableViewData() {
        presenter.didPullToRefreshTableViewData()
    }

    private func setNavigationBar() {
        navigationItem.title = Constants.navigationItemTitle
        navigationController?.navigationBar.isTranslucent = false
        let settingsButton = UIBarButtonItem(title: Constants.settingsButtonTitle,
                                             style: .plain, target: self,
                                             action: #selector(settingsButtonTapped))
        navigationItem.leftBarButtonItem = settingsButton
    }

    private func assignDelegationAndDataSource() {
        feedView.tableView.dataSource = self
        feedView.tableView.delegate = self
        feedView.tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseIdentifier)
        feedView.searchField.delegate = self
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

    func showSettings() {
        present(SettingsAssembly.makeModule(), animated: true, completion: nil)
    }

    func getSearchFieldText() -> String? {
        return feedView.searchField.text
    }

    func cleanSearchTextField() {
        feedView.searchField.text = nil
    }

    func deactivateSearchField() {
        feedView.searchField.resignFirstResponder()
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

    func showLoadingIndicator() {
        feedView.tableView.isHidden = true
        feedView.activityIndicator.isHidden = false
        feedView.activityIndicator.startAnimating()
    }

    func hideLoadingIndicator() {
        feedView.activityIndicator.stopAnimating()
        feedView.activityIndicator.isHidden = true
        feedView.tableView.isHidden = false
    }

    func hideCancelButton() {
        feedView.hideCancelButton()
    }

    func showCancelButton() {
        feedView.showCancelButton()
    }

    func showNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func hideNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
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
        presenter.textFieldShouldReturn()
        return true
    }

    func textFieldDidBeginEditing(_: UITextField) {
        presenter.textFieldDidBeginEditing()
    }
}
