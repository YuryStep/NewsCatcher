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
        static let animationDuration: CGFloat = 0.2
        static let normalAlphaComponent: CGFloat = 1
        static let touchedAlphaComponent: CGFloat = 0.7
    }

    init(backgroundColor: UIColor) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        configureButton()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: Constants.animationDuration) {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(Constants.touchedAlphaComponent)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: Constants.animationDuration) {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(Constants.normalAlphaComponent)
        }
    }

    private func configureButton() {
        layer.cornerRadius = Constants.buttonCornerRadius
    }
}
