//
//  PickerSettingsCell.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 09.10.2023.
//

import UIKit

final class PickerSettingsCell: UITableViewCell {
    typealias CellType = SettingsView.ArticleSettings.CellType

    var pickerItems: [String]?
    var pickerCurrentValue: String?
    var pickerValueChangedHandler: ((String) -> Void)?

    private lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier _: String?) {
        super.init(style: style, reuseIdentifier: PickerSettingsCell.reuseIdentifier)
        picker.dataSource = self
        picker.delegate = self
        setupSubviews()
    }

    func configureWith(pickerItems items: [String], currentValue: String) {
        pickerItems = items
        picker.reloadAllComponents()
        pickerCurrentValue = currentValue
        movePickerToCurrentValueRow()
    }

    private func movePickerToCurrentValueRow() {
        guard let pickerCurrentValue = pickerCurrentValue else { return }
        if let currentIndex = pickerItems?.firstIndex(of: pickerCurrentValue) {
            picker.selectRow(currentIndex, inComponent: 0, animated: false)
        }
    }

    private func setupSubviews() {
        contentView.addSubview(picker)
        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            picker.topAnchor.constraint(equalTo: contentView.topAnchor),
            picker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension PickerSettingsCell: UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        return pickerItems?.count ?? 0
    }
}

extension PickerSettingsCell: UIPickerViewDelegate {
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return pickerItems?[row]
    }

    // TODO: Check this method's logic:
    func pickerView(_: UIPickerView, didSelectRow selectedRow: Int, inComponent _: Int) {
        let selectedItem = pickerItems?[selectedRow]
        pickerCurrentValue = selectedItem
        pickerValueChangedHandler?(selectedItem!) // TODO: FIX force
    }
}
