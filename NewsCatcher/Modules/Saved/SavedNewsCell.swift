//
//  SavedNewsCell.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 24.10.2023.
//

import UIKit

final class SavedNewsCell: UICollectionViewCell {
    var article: Article?

    struct DisplayData {
        let title: String
        let description: String
        let publishedAt: String
        let sourceName: String
        let imageData: Data?
    }

    private enum Constants {
        static let systemSpacingMultiplier: CGFloat = 1
        static let maxDataAndSourceHeight: CGFloat = 32
        static let maxTitleHeight: CGFloat = 200
        static let maxDescriptionHeight: CGFloat = 200
        static let placeholderImageName: String = "noImageIcon"
        static let dateAndSourceLabelText = " Source: "
        static let imageHeightRatio: CGFloat = 0.562
    }

    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var dateAndSourceLabel = UILabel(textStyle: .footnote)
    private lazy var titleLabel = UILabel(textStyle: .title2)
    private lazy var descriptionLabel = UILabel(textStyle: .body)
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        backgroundColor = UIColor(resource: .ncBackground)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        clearPreviousConfiguration()
    }

    func configure(with displayData: DisplayData) {
        loadingIndicator.startAnimating()
        titleLabel.text = displayData.title
        descriptionLabel.text = displayData.description
        dateAndSourceLabel.text = displayData.publishedAt + Constants.dateAndSourceLabelText + displayData.sourceName
        setImage(displayData.imageData)
    }

    private func setImage(_ imageData: Data?) {
        loadingIndicator.stopAnimating()
        guard let imageData = imageData, let image = UIImage(data: imageData) else {
            articleImageView.image = UIImage(named: Constants.placeholderImageName)
            return
        }
        articleImageView.image = image
    }

    private lazy var imageContainer: UIView = {
        let container = UIImageView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()

    private func clearPreviousConfiguration() {
        articleImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateAndSourceLabel.text = nil
    }

    private func setupSubviews() {
        imageContainer.addSubviews([loadingIndicator, articleImageView])
        contentView.addSubviews([imageContainer, dateAndSourceLabel, titleLabel, descriptionLabel])

        let imageContainerConstraints = [
            articleImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            articleImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            articleImageView.widthAnchor.constraint(lessThanOrEqualTo: imageContainer.widthAnchor, multiplier: 1),
            articleImageView.heightAnchor.constraint(lessThanOrEqualTo: imageContainer.heightAnchor, multiplier: 1),

            loadingIndicator.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor)
        ]

        dateAndSourceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultHigh - 1, for: .vertical)

        let generalConstraints = [
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            imageContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: Constants.imageHeightRatio),

            dateAndSourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateAndSourceLabel.topAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: 8),
            dateAndSourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: dateAndSourceLabel.bottomAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ]

        NSLayoutConstraint.activate(imageContainerConstraints)
        NSLayoutConstraint.activate(generalConstraints)
    }
}
