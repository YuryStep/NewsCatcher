//
//  NoArticlesFoundLabel.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 07.11.2023.
//

import UIKit

final class NoArticlesFoundLabel: UILabel {
    private enum Constants {
        static let labelFontSize: CGFloat = 18
    }

    enum Style: String {
        case plain = "No articles found"
        case invalidRequest = "No articles found.\nTry to change your request."
    }

    init(style: Style) {
        super.init(frame: .zero)
        configureLabel(style: style)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func configureLabel(style: Style) {
        translatesAutoresizingMaskIntoConstraints = false
        text = style.rawValue
        textAlignment = .center
        numberOfLines = 0
        textColor = .gray
        font = UIFont.systemFont(ofSize: Constants.labelFontSize)
        isHidden = true
    }
}
