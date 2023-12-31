//
//  ArticleView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

protocol ArticleViewDelegate: AnyObject {
    func readInSourceButtonTapped()
    func readLaterButtonTapped()
}

final class ArticleView: UIView {
    struct DisplayData {
        let title: String
        let content: String
        let publishedAt: String
        let sourceName: String
        let imageData: Data?
        var isSaved: Bool
    }

    private enum Constants {
        static let readInSourceButtonTitle = "Read in Source"
        static let saveButtonTitleNormal = "Read Later"
        static let saveButtonTitleDestructive = "Delete from Saved"
        static let dateAndSourceLabelText = " Source: "
    }

    weak var delegate: ArticleViewDelegate?

    private lazy var dateAndSourceLabel = UILabel(textStyle: .footnote)
    private lazy var titleLabel: UILabel = .init(textStyle: .title2)
    private lazy var contentLabel = UILabel(textStyle: .body)

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var readInSourceButton: ArticleButton = {
        let button = ArticleButton(backgroundColor: .appAccent)
        button.setTitle(Constants.readInSourceButtonTitle, for: .normal)
        button.setTitleColor(.appBackground, for: .normal)
        button.addTarget(self, action: #selector(readInSourceButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var saveButton: ArticleButton = {
        let button = ArticleButton(backgroundColor: .appSaveButtonBackground)
        button.setTitleColor(.appAccent, for: .normal)
        button.addTarget(self, action: #selector(readLaterButtonTapped), for: .touchUpInside)
        return button
    }()

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .appBackground
        setupSubviews()
    }

    func configure(with displayData: DisplayData) {
        titleLabel.text = displayData.title
        dateAndSourceLabel.text = displayData.publishedAt + Constants.dateAndSourceLabelText + displayData.sourceName
        contentLabel.text = displayData.content
        setImageFrom(imageData: displayData.imageData)
        setSaveButtonAppearance(style: displayData.isSaved)
    }

    @objc private func readInSourceButtonTapped() {
        delegate?.readInSourceButtonTapped()
    }

    @objc private func readLaterButtonTapped() {
        delegate?.readLaterButtonTapped()
    }

    private func setSaveButtonAppearance(style isSaved: Bool) {
        if isSaved {
            saveButton.setTitleColor(.appDestructiveAction, for: .normal)
            saveButton.setTitle(Constants.saveButtonTitleDestructive, for: .normal)
        } else {
            saveButton.setTitleColor(.appAccent, for: .normal)
            saveButton.setTitle(Constants.saveButtonTitleNormal, for: .normal)
        }
    }

    private func setImageFrom(imageData: Data?) {
        if let imageData = imageData, let image = UIImage(data: imageData) {
            articleImageView.image = image.resizeToScreenWidth()
        } else {
            articleImageView.image = .noImageIcon.resizeToScreenWidth()
        }
    }

    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubviews([dateAndSourceLabel, articleImageView, titleLabel, contentLabel, saveButton, readInSourceButton])
        let scrollViewFrameGuide = scrollView.frameLayoutGuide
        let scrollViewContentGuide = scrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            scrollViewFrameGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollViewFrameGuide.topAnchor.constraint(equalTo: topAnchor),
            scrollViewFrameGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollViewFrameGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollViewFrameGuide.widthAnchor.constraint(equalTo: scrollViewContentGuide.widthAnchor),

            articleImageView.topAnchor.constraint(equalTo: scrollViewContentGuide.topAnchor),
            articleImageView.centerXAnchor.constraint(equalTo: scrollViewContentGuide.centerXAnchor),

            dateAndSourceLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor, constant: 8),
            dateAndSourceLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 8),
            dateAndSourceLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor, constant: -8),

            titleLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: dateAndSourceLabel.bottomAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor, constant: -8),

            contentLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor, constant: 8),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            contentLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor, constant: -8),

            saveButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            saveButton.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor, constant: 8),
            saveButton.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor, constant: -8),

            readInSourceButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 8),
            readInSourceButton.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor, constant: 8),
            readInSourceButton.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor, constant: -8),
            readInSourceButton.bottomAnchor.constraint(equalTo: scrollViewContentGuide.bottomAnchor, constant: -8)
        ])
    }
}
