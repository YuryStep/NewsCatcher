//
//  ViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

import UIKit

class FeedViewController: UIViewController {
    struct Constants {
        static let navigationItemTitle = "News Catcher"
    }
    
    // MARK: Dependencies
    var feedView: FeedView!
    var presenter: FeedPresenter!
    
    override func loadView() {
        view = feedView
        navigationItem.title = Constants.navigationItemTitle
        feedView.tableViewSetup(dataSource: self,
                                delegate: self,
                                cell: FeedCell.self,
                                identifier: FeedCell.reuseIdentifier)
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
