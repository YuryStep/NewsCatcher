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
    }

    private enum Constants {
        static let buttonCornerRadius: CGFloat = 10
        static let defaultImageRatio: CGFloat = 0.562
        static let placeholderImageName = "noImageIcon"
        static let readInSourceButtonTitle = "Read in Source"
        static let readLaterButtonTitle = "Read Later"
        static let dateAndSourceLabelText = " Source: "
    }

    weak var delegate: ArticleViewDelegate?

    private var imageRatio: CGFloat {
        guard let image = articleImageView.image else { return Constants.defaultImageRatio }
        return image.size.height / image.size.width
    }

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
        button.backgroundColor = UIColor(resource: .ncAccent)
        button.setTitleColor(UIColor(resource: .ncBackground), for: .normal)
        button.setTitle(Constants.readInSourceButtonTitle, for: .normal)
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.addTarget(self, action: #selector(readInSourceButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.buttonCornerRadius
        button.backgroundColor = UIColor(resource: .ncSaveButtonBackground)
        button.setTitleColor(UIColor(resource: .ncAccent), for: .normal)
        button.setTitle(Constants.readLaterButtonTitle, for: .normal)
        button.addTarget(self, action: #selector(readLaterButtonTapped), for: .touchUpInside)
        return button
    }()

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(resource: .ncBackground)
    }

    func configure(with displayData: DisplayData) {
        titleLabel.text = displayData.title
        dateAndSourceLabel.text = displayData.publishedAt + Constants.dateAndSourceLabelText + displayData.sourceName
        contentLabel.text = displayData.content
        setImage(displayData.imageData)
        setupSubviews()
    }

    @objc func readInSourceButtonTapped() {
        delegate?.readInSourceButtonTapped()
    }

    @objc func readLaterButtonTapped() {
        delegate?.readLaterButtonTapped()
    }

    private func setImage(_ imageData: Data?) {
        if let imageData = imageData, let image = UIImage(data: imageData) {
            articleImageView.image = image
        } else {
            articleImageView.image = UIImage(named: Constants.placeholderImageName)
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

            articleImageView.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            articleImageView.topAnchor.constraint(equalTo: scrollViewContentGuide.topAnchor, constant: 8),
            articleImageView.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: imageRatio),

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
