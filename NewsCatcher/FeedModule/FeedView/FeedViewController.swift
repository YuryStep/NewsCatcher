//
//  ViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

protocol FeedInput: AnyObject {
    func reloadFeedTableView()
}

protocol FeedOutput: AnyObject {
    // Output
    func searchButtonTapped()
    func settingsButtonTapped()
    func handleMemoryWarning()
    // TableView Data Source
    func getNumberOfRowsInSection() -> Int
    func getTitle(forIndexPath: IndexPath) -> String
    func getDescription(forIndexPath: IndexPath) -> String
    func getImageData(forIndexPath: IndexPath, completion: @escaping (Data?)->())
}

import UIKit

class FeedViewController: UIViewController, FeedViewDelegate, FeedInput {
    struct Constants {
        static let navigationItemTitle = "News Catcher"
    }
    
    // MARK: Dependencies
    var feedView: FeedView!
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
    
    // MARK: Input methods
    func reloadFeedTableView() {
        feedView.reloadTableViewData()
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
        let description = presenter.getDescription(forIndexPath: indexPath)
        
        cell.configure(with: nil, title: title, description: description)
        
        presenter.getImageData(forIndexPath: indexPath) { imageData in
            if let imageData = imageData, let image = UIImage(data: imageData) {
                cell.configure(with: image, title: title, description: description)
            }
        }
        return cell
    }
}
