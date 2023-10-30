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
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.backgroundColor = UIColor(resource: .ncBackground)
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = Constants.navigationItemTitle
        view.backgroundColor = UIColor(resource: .ncBackground)
        setupCollectionView()
        setupDataSource()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSnapshot()
    }

    private func setupCollectionView() {
        savedNewsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: savedNewsLayout)
        savedNewsCollectionView.delegate = self
        savedNewsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(savedNewsCollectionView)

        NSLayoutConstraint.activate([
            savedNewsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            savedNewsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            savedNewsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            savedNewsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SavedNewsCell, Article> { cell, _, article in
            let cellDisplayData = CellDisplayData(title: article.title,
                                                  description: article.description,
                                                  publishedAt: article.publishedAt,
                                                  sourceName: article.source.name,
                                                  imageData: article.imageData)
            cell.configure(with: cellDisplayData)
        }
        dataSource = DataSource(collectionView: savedNewsCollectionView) { collectionView, indexPath, article in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: article)
        }
        updateSnapshot()
    }

    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(DataManager.shared.getSavedArticles()?.reversed() ?? [])
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SavedNewsViewController: UICollectionViewDelegate {}
