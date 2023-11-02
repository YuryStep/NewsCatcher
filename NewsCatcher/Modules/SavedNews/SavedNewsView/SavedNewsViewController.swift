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
    func getCellDisplayData(for: Article) -> SavedNewsCell.DisplayData
    func getSnapshotItems() -> [Article]
    func delete(_: Article)
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
        static let deleteTitle = "Delete"
        static let noArticlesLabelText = "No articles found"
        static let noArticlesLabelFontSize: CGFloat = 18
    }

    private enum Section {
        case main
    }

    var presenter: SavedNewsOutput!

    private var savedNewsCollectionView: UICollectionView!
    private var dataSource: DataSource!

    private lazy var savedNewsLayout: UICollectionViewCompositionalLayout = {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        listConfiguration.backgroundColor = .appBackground
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        return layout
    }()

    private lazy var noArticlesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.noArticlesLabelText
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: Constants.noArticlesLabelFontSize)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .appBackground
        setupNavigationBar()
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

    private func setupNavigationBar() {
        navigationItem.title = Constants.navigationItemTitle
    }

    private func setupCollectionView() {
        savedNewsCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: savedNewsLayout)
        savedNewsCollectionView.delegate = self
        savedNewsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubviews([savedNewsCollectionView, noArticlesLabel])

        NSLayoutConstraint.activate([
            noArticlesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noArticlesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            savedNewsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            savedNewsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            savedNewsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            savedNewsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SavedNewsCell, Article> { cell, _, article in
            let displayData = self.presenter.getCellDisplayData(for: article)
            cell.configure(with: displayData)
        }
        dataSource = DataSource(collectionView: savedNewsCollectionView) { collectionView, indexPath, article in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: article)
        }
        updateSnapshot()
    }

    private func updateSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([Section.main])

        let snapshotItems = presenter.getSnapshotItems()
        if snapshotItems.isEmpty {
            noArticlesLabel.isHidden = false
        } else {
            noArticlesLabel.isHidden = true
            snapshot.appendItems(snapshotItems)
        }

        dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let article = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }
        let deleteAction = UIContextualAction(style: .destructive, title: Constants.deleteTitle) { [weak self] _, _, completion in
            self?.presenter.delete(_: article)
            self?.updateSnapshot()
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
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
