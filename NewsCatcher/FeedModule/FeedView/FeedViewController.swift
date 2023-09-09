//
//  FeedViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

protocol FeedInput: AnyObject {
    func reloadFeedTableView()
    func showArticle(withIndex index: Int, dataManager: AppDataManager)
    func getSearchFieldText() -> String?
    func hideKeyboard() 
}

protocol FeedOutput: AnyObject {
    // Output
    func searchButtonTapped()
    func settingsButtonTapped()
    func viewWillAppear()
    func handleMemoryWarning()
    func refreshTableViewData()
    // TableView Data Source
    func getNumberOfRowsInSection() -> Int
    func getTitle(forIndexPath: IndexPath) -> String
    func getDescription(forIndexPath: IndexPath) -> String
    func getImageData(forIndexPath: IndexPath, completion: @escaping (Data?)->())
    func getSourceNameForArticle(forIndexPath indexPath: IndexPath) -> String
    func getPublishingDataForArticle(forIndexPath indexPath: IndexPath) -> String
    // TableView Delegate
    func handleTapOnCellAt(indexPath: IndexPath)
}

import UIKit

class FeedViewController: UIViewController, FeedViewDelegate, FeedInput {
    struct Constants {
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
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    // MARK: Lifecycle methods
    override func loadView() {
        view = feedView
        navigationItem.title = Constants.navigationItemTitle
        feedView.tableViewSetup(dataSource: self,delegate: self,cell: FeedCell.self, identifier: FeedCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    override func didReceiveMemoryWarning() {
        presenter.handleMemoryWarning()
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
        feedView.reloadTableViewData()
    }
    
    func showArticle(withIndex index: Int, dataManager: AppDataManager) {
        let articleViewController = ArticleAssembly.configureModule(withIndex: index, dataManager: dataManager)
        navigationController?.pushViewController(articleViewController, animated: true)
    }
    
    func getSearchFieldText() -> String? {
        return feedView.searchTextField.text
    }
    
    func hideKeyboard() {
        feedView.searchTextField.endEditing(true)
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getNumberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.reuseIdentifier, for: indexPath) as? FeedCell else {
            return UITableViewCell()
        }
        
        let title = presenter.getTitle(forIndexPath: indexPath)
        let sourceName = presenter.getSourceNameForArticle(forIndexPath: indexPath)
        let date = presenter.getPublishingDataForArticle(forIndexPath: indexPath)
        let description = presenter.getDescription(forIndexPath: indexPath)
        cell.configure(withTitle: title, sourceName: sourceName, date: date, description: description)
        
        presenter.getImageData(forIndexPath: indexPath) { imageData in
            if let imageData = imageData, let image = UIImage(data: imageData) {
                cell.setImage(image)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.handleTapOnCellAt(indexPath: indexPath)
    }
    
}
