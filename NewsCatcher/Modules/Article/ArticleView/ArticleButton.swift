//
//  ArticleButton.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.11.2023.
//

import UIKit

final class ArticleButton: UIButton {
    private enum Constants {
        static let buttonCornerRadius: CGFloat = 10
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.15, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState]) {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.94, y: 0.94) : .identity
            }
        }
    }

    init(backgroundColor: UIColor) {
        super.init(frame: .zero)
        configureButton(withBackgroundColor: backgroundColor)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    private func configureButton(withBackgroundColor color: UIColor) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = color
        layer.cornerRadius = Constants.buttonCornerRadius
    }
}
