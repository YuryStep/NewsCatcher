//
//  SettingsViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 27.09.2023.
//

import UIKit

protocol SettingsViewInput: AnyObject {

}

protocol SettingsViewOutput: AnyObject {
    func didReceiveMemoryWarning()
    func getNumberOfRowsInSection() -> Int
    func didTapOnCell(at indexPath: IndexPath)
}

final class SettingsViewController: UIViewController {
    enum Constants {
        static let navigationItemTitle = "Request Settings"
    }

    private var settingsView: SettingsView!
    var presenter: SettingsViewOutput!

    init() {
        super.init(nibName: nil, bundle: nil)
        self.settingsView = SettingsView()
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
        settingsView.tableView.register(SettingsCell.self, forCellReuseIdentifier: "cellIdentifier")
        settingsView.tableView.register(SettingsCell.self, forCellReuseIdentifier: "cellIdentifier2")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.didReceiveMemoryWarning()
    }

    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }

    @objc func saveButtonTapped() {
        // TODO: completion(presenter.requestSettingsHaveBeenChanged(to: RequestSettings))
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
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Articles parameters"
        case 1: return "Where to search" // "Search Parameters"
        default: return ""
        }
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0: return "These parameters allow you to specify the language of news articles and the country in which they were published."
        case 1: return "These parameters allow you to specify which sections of articles to search for a keyword phrase."
        default: return ""
        }
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2
        case 1: return 3
        default: return 0
        }
    }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
                var content = cell.defaultContentConfiguration()
                content.text = "Country"
                content.secondaryText = "Language"
                content.image = UIImage(systemName: "arrow.right")
                cell.contentConfiguration = content
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier2", for: indexPath)
                var content = cell.defaultContentConfiguration()
                content.text = "Title"
                content.secondaryText = "Description"
                content.image = UIImage(systemName: "arrow.right")
                cell.contentConfiguration = content
                return cell
            default:
                return UITableViewCell()
            }
        }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didTapOnCell(at: indexPath)
        settingsView.tableView.deselectRow(at: indexPath, animated: true)
    }
}
