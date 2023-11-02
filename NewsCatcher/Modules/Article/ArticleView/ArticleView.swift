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
        let isSaved: Bool
    }

    private enum Constants {
        static let buttonCornerRadius: CGFloat = 10
        static let readInSourceButtonTitle = "Read in Source"
        static let saveButtonTitleNormal = "Read Later"
        static let saveButtonTitleDestructive = "Delete from Saved"
        static let dateAndSourceLabelText = " Source: "
    }

    weak var delegate: ArticleViewDelegate?

    private lazy var dateAndSourceLabel = UILabel(textStyle: .footnote)
    private lazy var titleLabel = UILabel(textStyle: .headline)
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

    private lazy var readInSourceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.backgroundColor = .appAccent
        button.setTitleColor(.appBackground, for: .normal)
        button.setTitle(Constants.readInSourceButtonTitle, for: .normal)
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.addTarget(self, action: #selector(readInSourceButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.backgroundColor = .appSaveButtonBackground
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
    }

    func configure(with displayData: DisplayData) {
        titleLabel.text = displayData.title
        dateAndSourceLabel.text = displayData.publishedAt + Constants.dateAndSourceLabelText + displayData.sourceName
        contentLabel.text = displayData.content
        setImage(displayData.imageData)
        setSaveButtonAppearance(style: displayData.isSaved)
        setupSubviews()
    }

    @objc func readInSourceButtonTapped() {
        delegate?.readInSourceButtonTapped()
    }

    func setSaveButtonAppearance(style isSaved: Bool) {
        if isSaved {
            saveButton.setTitleColor(.appDestructiveAction, for: .normal)
            saveButton.setTitle(Constants.saveButtonTitleDestructive, for: .normal)
        } else {
            saveButton.setTitleColor(.appAccent, for: .normal)
            saveButton.setTitle(Constants.saveButtonTitleNormal, for: .normal)
        }
    }

    @objc func readLaterButtonTapped() {
        delegate?.readLaterButtonTapped()
    }

    private func setImage(_ imageData: Data?) {
        if let imageData = imageData, let image = UIImage(data: imageData) {
            articleImageView.image = image.resizeToScreenWidth()
        } else {
            articleImageView.image = .noImageIcon.resizeToScreenWidth()
        }
    }

    private func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubviews([dateAndSourceLabel, articleImageView, titleLabel, contentLabel, saveButton, readInSourceButton])
        let marginGuide = layoutMarginsGuide
        let scrollViewFrameGuide = scrollView.frameLayoutGuide
        let scrollViewContentGuide = scrollView.contentLayoutGuide

        NSLayoutConstraint.activate([
            scrollViewFrameGuide.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            scrollViewFrameGuide.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            scrollViewFrameGuide.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            scrollViewFrameGuide.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor),
            scrollViewFrameGuide.widthAnchor.constraint(equalTo: scrollViewContentGuide.widthAnchor),

            articleImageView.topAnchor.constraint(equalTo: scrollViewContentGuide.topAnchor, constant: 8),
            articleImageView.centerXAnchor.constraint(equalTo: scrollViewContentGuide.centerXAnchor),

            dateAndSourceLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            dateAndSourceLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 8),
            dateAndSourceLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: dateAndSourceLabel.bottomAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),

            contentLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            contentLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),

            saveButton.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            saveButton.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            saveButton.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),

            readInSourceButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 8),
            readInSourceButton.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            readInSourceButton.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            readInSourceButton.bottomAnchor.constraint(equalTo: scrollViewContentGuide.bottomAnchor, constant: -8)
        ])
    }
}
