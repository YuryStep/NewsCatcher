//
//  FeedViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

protocol FeedInput: AnyObject {
    func reloadFeedTableView()
    func showArticle(at index: Int, dataManager: AppDataManager)
    func getSearchFieldText() -> String?
    func hideKeyboard()
}

protocol FeedOutput: AnyObject {
    func viewWillAppear()
    func didReceiveMemoryWarning()
    func searchButtonTapped()
    func settingsButtonTapped()
    func refreshTableViewData()
    func getNumberOfRowsInSection() -> Int
    func getTitle(at indexPath: IndexPath) -> String
    func getDescription(at indexPath: IndexPath) -> String
    func getImageData(at indexPath: IndexPath, completion: @escaping (Data?) -> Void)
    func getSourceName(at indexPath: IndexPath) -> String
    func getPublishingDate(at indexPath: IndexPath) -> String
    func didTapOnCell(at index: Int)
}

import UIKit

final class FeedViewController: UIViewController, FeedViewDelegate, FeedInput {
    enum Constants {
        static let navigationItemTitle = "News Catcher"
    }

    // MARK: Dependencies

    private var feedView: FeedView!
    var presenter: FeedOutput!

    // MARK: Initializers

    init(feedView: FeedView) {
        super.init(nibName: nil, bundle: nil)
        self.feedView = feedView
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    // MARK: Lifecycle methods

    override func loadView() {
        view = feedView
        navigationItem.title = Constants.navigationItemTitle
        feedView.tableView.dataSource = self
        feedView.tableView.delegate = self
        feedView.tableView.register(FeedCell.self, forCellReuseIdentifier: FeedCell.reuseIdentifier)
        feedView.searchTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.didReceiveMemoryWarning()
    }

    // MARK: Output methods

    func searchButtonTapped() {
        presenter.searchButtonTapped()
    }

    func settingsButtonTapped() {
        presenter.settingsButtonTapped()
    }

    func refreshTableViewData() {
        presenter.refreshTableViewData()
    }

    // MARK: Input methods

    func reloadFeedTableView() {
        feedView.tableView.reloadData()
        scrollTableViewBackToTheTop()
    }

    func showArticle(at index: Int, dataManager _: AppDataManager) {
        let articleViewController = ArticleAssembly.makeModule(index: index)
        navigationController?.pushViewController(articleViewController, animated: true)
    }

    func getSearchFieldText() -> String? {
        return feedView.searchTextField.text
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

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return presenter.getNumberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseIdentifier, for: indexPath) as? FeedCell else {
            return UITableViewCell()
        }
        let requestID = UUID()
        cell.id = requestID
        let title = presenter.getTitle(at: indexPath)
        let sourceName = presenter.getSourceName(at: indexPath)
        let date = presenter.getPublishingDate(at: indexPath)
        let description = presenter.getDescription(at: indexPath)
        cell.configure(withTitle: title, sourceName: sourceName, date: date, description: description)
        presenter.getImageData(at: indexPath) { imageData in
            if let imageData = imageData, let image = UIImage(data: imageData), cell.id == requestID {
                cell.setImage(image)
            }
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapOnCell(at: indexPath.row)
        feedView.tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension FeedViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_: UITextField) -> Bool {
        searchButtonTapped()
        return true
    }
}
