//
//  PickerSettingsCell.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 09.10.2023.
//

import UIKit

final class PickerSettingsCell: UITableViewCell {
    struct DisplayData {
        let items: [String]
        var currentValue: String
    }

    static let reuseIdentifier = "PickerSettingsCell"
    var displayData: DisplayData!
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

    override func prepareForReuse() {
        super.prepareForReuse()
        picker.reloadAllComponents()
    }

    func configure(with displayData: DisplayData) {
        self.displayData = displayData
        if let currentIndex = displayData.items.firstIndex(of: displayData.currentValue) {
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
        return displayData.items.count
    }

    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        guard row < displayData.items.count else { return "Row No.\(row)"} // TODO: Remove after Bug Fix
        return displayData.items[row]
    }

    func pickerView(_: UIPickerView, didSelectRow selectedRow: Int, inComponent _: Int) {
        let selectedValue = displayData.items[selectedRow]
        displayData.currentValue = selectedValue
        pickerValueChangedHandler?(selectedValue)
    }
}

extension PickerSettingsCell: UIPickerViewDelegate {}
