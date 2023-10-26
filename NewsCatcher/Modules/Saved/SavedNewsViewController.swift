//
//  SavedNewsViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 24.10.2023.
//

import Foundation
import UIKit

final class SavedNewsViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Article>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Article>
    typealias CellDisplayData = SavedNewsCell.DisplayData

    private enum Constants {
        static let navigationItemTitle = "Saved Articles"
    }

    enum Section {
        case main
    }

    private var savedNewsCollectionView: UICollectionView!
    private var dataSource: DataSource!

    private lazy var savedNewsLayout: UICollectionViewCompositionalLayout = {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped) // TODO: Check other appearances
        listConfiguration.backgroundColor = .white
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.navigationItemTitle
        setupCollectionView()
        setupDataSource()
    }

    private func setupCollectionView() {
        savedNewsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: savedNewsLayout)
        savedNewsCollectionView.delegate = self
        view.addSubview(savedNewsCollectionView)
        savedNewsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            savedNewsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            savedNewsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            savedNewsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            savedNewsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SavedNewsCell, Article> { cell, _, article in
            let cellDisplayData = CellDisplayData(title: article.title,
                                                  description: article.description,
                                                  publishedAt: article.publishedAt,
                                                  sourceName: article.source.name,
                                                  imageStringURL: article.imageStringURL,
                                                  imageData: nil)
            cell.configure(with: cellDisplayData)
        }

        dataSource = DataSource(collectionView: savedNewsCollectionView) { collectionView, indexPath, article in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: article)
        }

        var snapshot = Snapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(SavedNewsViewController.sampleData)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SavedNewsViewController: UICollectionViewDelegate {}

#if DEBUG
    // swiftlint:disable line_length
    extension SavedNewsViewController {
        static var sampleData = [
            Article(title: "Buy an iPhone 15 or 15 Pro on Verizon and get a free Apple TV 4K and Apple One subscription",
                    description: "Buying a new iPhone 15 or iPhone 15 Pro from Verizon will get you a free Apple TV 4K and six months of Apple One if you\'re quick.",
                    content: "The iPhone 15 and iPhone 15 Pro families of devices have been on sale for a few weeks now but the deals are starting to flow already. Like this one from Verizon which might just be the answer to all your streaming needs.\nRight now you can order yours... [1439 chars]",
                    urlString: "https://www.imore.com/iphone/iphone-15/buy-an-iphone-15-or-15-pro-on-verizon-and-get-a-free-apple-tv-4k-and-apple-one-subscription",
                    imageStringURL: "https://cdn.mos.cms.futurecdn.net/BjFUtZ7BDZFj49NrDuxxdd-1200-80.jpg",
                    publishedAt: "2023-10-24T12:15:35Z",
                    source: Source(name: "iMore",
                                   url: "https://www.imore.com")),
            Article(title: "OLED iPad and MacBook Rumored to Feature Specialized Display Materials",
                    description: "Future iPad Pro and MacBook models with OLED panels will adopt new, specialized display materials, The Elec reports. Apple has apparently...",
                    content: "Future iPad Pro and MacBook models with OLED panels will adopt new, specialized display materials, The Elec reports.\nApple has apparently collaborated with LG Display to integrate new OLED material sets in some of its future devices, including forthc... [1067 chars]",
                    urlString: "https://www.macrumors.com/2023/10/24/oled-ipad-and-macbook-specialized-materials/",
                    imageStringURL: "https://images.macrumors.com/t/hIXj0LHsCAepM-B_dJ5z96rVSgM=/2500x/article-new/2021/11/Oled-iPads-and-MackBook-Pro-Notch.jpg",
                    publishedAt: "2023-10-24T12:06:35Z",
                    source: Source(name: "MacRumors",
                                   url: "https://www.macrumors.com")),
            Article(title: "Google Pixel 8 Pro vs. iPhone 15 Pro Max: Which should you buy?",
                    description: "Trying to decide between the latest flagships from Google and Apple? Choosing the \"right\" phone has never been more difficult.",
                    content: "Google Pixel 8 Pro View at Amazon View at Verizon Wireless View at Best Buy All-in on AI The Pixel 8 Pro isn\'t just the best phone that Google has ever released. It\'s also Google taking the next step by improving your smartphone experience with the h... [11051 chars]",
                    urlString: "https://www.androidcentral.com/phones/google-pixel-8-pro-vs-iphone-15-pro-max",
                    imageStringURL: "https://cdn.mos.cms.futurecdn.net/boVf4p3mcjQvLY347xzgna-1200-80.jpg",
                    publishedAt: "2023-10-24T12:01:41Z",
                    source: Source(name: "Android Central",
                                   url: "https://www.androidcentral.com"))
        ]
    }
    // swiftlint:enable line_length
#endif
