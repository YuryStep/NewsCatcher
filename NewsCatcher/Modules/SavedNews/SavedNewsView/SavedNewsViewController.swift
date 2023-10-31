//
//  SavedNewsViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 24.10.2023.
//

protocol SavedNewsInput: AnyObject {
    func showArticle(_: Article)
}

protocol SavedNewsOutput: AnyObject {
    func getSnapshotItems() -> [Article]
    func didTapOnCell(with: Article)
    func didReceiveMemoryWarning()
}

import UIKit

final class SavedNewsViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Article>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Article>
    private typealias CellDisplayData = SavedNewsCell.DisplayData

    private enum Constants {
        static let navigationItemTitle = "Saved Articles"
    }

    private enum Section {
        case main
    }

    var presenter: SavedNewsOutput!

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

    override func didReceiveMemoryWarning() {
        presenter.didReceiveMemoryWarning()
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
        snapshot.appendItems(presenter.getSnapshotItems())
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SavedNewsViewController: UICollectionViewDelegate {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedArticle = dataSource.itemIdentifier(for: indexPath) else { return }
        presenter.didTapOnCell(with: selectedArticle)
    }
}

extension SavedNewsViewController: SavedNewsInput {
    func showArticle(_ article: Article) {
        let articleViewController = ArticleAssembly.makeModule(for: article)
        navigationController?.pushViewController(articleViewController, animated: true)
    }
}
