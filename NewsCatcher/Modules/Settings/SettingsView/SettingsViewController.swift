//
//  SettingsViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

protocol SettingsInput: AnyObject {
    func getCurrentDisplayData() -> SettingsView.DisplayData
    func closeView()
}

protocol SettingsOutput: AnyObject {
    func getSettingsDisplayData() -> SettingsView.DisplayData
    func didTapOnCell(at indexPath: IndexPath)
    func didReceiveMemoryWarning()
    func didTapOnSaveButton()
    func didTapOnCancelButton()
}

final class SettingsViewController: UIViewController {
    private enum Constants {
        static let navigationItemTitle = "Request Settings"
    }

    private var settingsView: SettingsView!
    private var displayData: SettingsView.DisplayData!
    var presenter: SettingsOutput!

    init(presenter: SettingsOutput) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        displayData = presenter.getSettingsDisplayData()
        settingsView = SettingsView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func loadView() {
        view = settingsView
        setNavigationBar()
        settingsView.tableView.dataSource = self
        settingsView.tableView.delegate = self
        settingsView.tableView.register(ArticleSettingsCell.self, forCellReuseIdentifier: ArticleSettingsCell.reuseIdentifier)
        settingsView.tableView.register(SearchSettingsCell.self, forCellReuseIdentifier: SearchSettingsCell.reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.didReceiveMemoryWarning()
    }

    @objc func cancelButtonTapped() {
        presenter.didTapOnCancelButton()
    }

    @objc func saveButtonTapped() {
        presenter.didTapOnSaveButton()
    }

    private func setNavigationBar() {
        navigationItem.title = Constants.navigationItemTitle
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
}

extension SettingsViewController: SettingsInput {
    func getCurrentDisplayData() -> SettingsView.DisplayData {
        return displayData
    }

    func closeView() {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource {
    private enum Section: Int {
        case articleSettings
        case searchSettings
    }

    func numberOfSections(in _: UITableView) -> Int {
        presenter.getSettingsDisplayData().numberOfSections
    }

    func tableView(_: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let header = presenter.getSettingsDisplayData().getTitleForHeaderForSection(section) else { return nil }
        return header
    }

    func tableView(_: UITableView, titleForFooterInSection section: Int) -> String? {
        guard let footerTitle = presenter.getSettingsDisplayData().getTitleForFooterForSection(section) else { return nil }
        return footerTitle
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = presenter.getSettingsDisplayData().getNumberOfRowsInSection(section) else { return 0 }
        return numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }

        switch section {
        case .articleSettings:
            let cell = ArticleSettingsCell.make(for: tableView, indexPath: indexPath)
            cell.configure(with: displayData.getArticleSettingsCellDisplayData(forCellAt: indexPath))
            return cell
        case .searchSettings:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchSettingsCell.reuseIdentifier,
                for: indexPath
            ) as? SearchSettingsCell else { return UITableViewCell() }

            cell.configure(with: displayData.getSearchSettingsCellDisplayData(forCellAt: indexPath))
            cell.switchValueChangedHandler = { [weak self] isOn in
                guard let self else { return }
                displayData.searchSettingsCellDisplayData[indexPath.row].switchIsOn = isOn
            }
            return cell
        }
    }

    func dequeueReusableCell<T: UITableViewCell>(for tableView: UITableView, indexPath: IndexPath, reuseIdentifier: String) -> T {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? T else {
            fatalError("Failed to dequeue cell with identifier: \(reuseIdentifier)")
        }
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath.section != 1 else { return nil }
        return indexPath
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapOnCell(at: indexPath)
        settingsView.tableView.deselectRow(at: indexPath, animated: true)
    }
}
