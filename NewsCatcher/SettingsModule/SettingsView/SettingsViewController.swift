//
//  SettingsViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

protocol SettingsViewInput: AnyObject {}

protocol SettingsViewOutput: AnyObject {
    func getSettingsDisplayData() -> SettingsView.DisplayData
    func didTapOnCell(at indexPath: IndexPath)
    func didReceiveMemoryWarning()
    func didTapOnSaveButton(withCurrentDisplayData: SettingsView.DisplayData) // TODO: Make separate funcs
}

final class SettingsViewController: UIViewController {
    private enum Constants {
        static let navigationItemTitle = "Request Settings"
    }

    private var settingsView: SettingsView!
    private var displayData: SettingsView.DisplayData!
    var presenter: SettingsViewOutput!

    init(presenter: SettingsViewOutput) {
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
        dismiss(animated: true, completion: nil)
    }

    @objc func saveButtonTapped() {
        // TODO: Remove to separate calls
        presenter.didTapOnSaveButton(withCurrentDisplayData: displayData)
        dismiss(animated: true, completion: nil)
    }

    private func setNavigationBar() {
        navigationItem.title = Constants.navigationItemTitle
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
}

extension SettingsViewController: SettingsViewInput {
    func reloadFeedTableView() {
        settingsView.tableView.reloadData()
        scrollTableViewBackToTheTop()
    }

    private func scrollTableViewBackToTheTop() {
        guard settingsView.tableView.numberOfSections > 0,
              settingsView.tableView.numberOfRows(inSection: 0) > 0 else { return }
        settingsView.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource {
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
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ArticleSettingsCell.reuseIdentifier,
                for: indexPath
            ) as? ArticleSettingsCell else { return UITableViewCell() }

            cell.configure(with: displayData.getArticleSettingsCellDisplayData(forCellAt: indexPath))
            return cell
        case 1:
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
        default:
            return UITableViewCell()
        }
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
