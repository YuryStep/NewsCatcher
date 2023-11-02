//
//  FeedViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

import UIKit

protocol FeedInput: AnyObject {
    func reloadFeedTableView()
    func stopRefreshControlAnimation()
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func getImageData(for: IndexPath) -> Data?
    func showArticle(_ article: Article)
    func showSettings()
    func showAlertWithTitle(_ title: String, text: String)
}

protocol FeedOutput: AnyObject {
    func didReceiveMemoryWarning()
    func didTapOnSettingsButton()
    func didTapOnCell(at indexPath: IndexPath)
    func didPullToRefreshTableViewData()
    func getNumberOfRowsInSection() -> Int
    func getImageData(at indexPath: IndexPath, completion: @escaping (Data?) -> Void)
    func getFeedDisplayData(at indexPath: IndexPath) -> FeedCell.DisplayData
    func didTapOnSearchButton(withKeyword: String)
}

final class FeedViewController: UIViewController {
    private enum Constants {
        static let navigationItemTitle = "News Catcher"
        static let defaultAlertButtonText = "OK"
        static let settingsButtonTitle = "Settings"
        static let searchControllerPlaceholder = "Search"
    }

    var presenter: FeedOutput!
    private var feedView: FeedView!
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.searchControllerPlaceholder
        searchController.searchBar.delegate = self
        return searchController
    }()

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        assignDelegationAndDataSource()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.didReceiveMemoryWarning()
    }

    @objc func settingsButtonTapped() {
        presenter.didTapOnSettingsButton()
    }

    private func setNavigationBar() {
        navigationItem.title = Constants.navigationItemTitle
        let settingsButton = UIBarButtonItem(title: Constants.settingsButtonTitle,
                                             style: .plain, target: self,
                                             action: #selector(settingsButtonTapped))
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    private func assignDelegationAndDataSource() {
        feedView.tableView.dataSource = self
        feedView.tableView.delegate = self
        feedView.tableView.register(FeedCell.self)
    }
}

extension FeedViewController: FeedViewDelegate {
    func didPullToRefreshTableViewData() {
        presenter.didPullToRefreshTableViewData()
    }
}

extension FeedViewController: FeedInput {
    func reloadFeedTableView() {
        feedView.tableView.reloadData()
        scrollTableViewBackToTheTop()
    }

    func getImageData(for indexPath: IndexPath) -> Data? {
        guard let cell = feedView.tableView.cellForRow(at: indexPath) as? FeedCell else { return nil }
        return cell.getImageData()
    }

    func showArticle(_ article: Article) {
        let articleViewController = ArticleAssembly.makeModule(for: article)
        navigationController?.pushViewController(articleViewController, animated: true)
    }

    func showSettings() {
        present(SettingsAssembly.makeModule(), animated: true, completion: nil)
    }

    func showAlertWithTitle(_ title: String, text: String) {
        let alertController = UIAlertController(title: title, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.defaultAlertButtonText, style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }

    func stopRefreshControlAnimation() {
        if let refreshControl = feedView.tableView.refreshControl, refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
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
        let cell = tableView.reuse(FeedCell.self, indexPath)
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

extension FeedViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            presenter.didTapOnSearchButton(withKeyword: searchText)
        }
    }
}
