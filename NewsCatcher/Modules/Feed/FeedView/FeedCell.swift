//
//  FeedCell.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.08.2023.
//

import UIKit

final class FeedCell: UITableViewCell {
    struct DisplayData {
        let title: String
        let description: String
        let publishedAt: String
        let sourceName: String
        let imageStringURL: String
    }

    private enum Constants {
        static let systemSpacingMultiplier: CGFloat = 1
        static let maxDataAndSourceHeight: CGFloat = 32
        static let maxTitleHeight: CGFloat = 200
        static let maxDescriptionHeight: CGFloat = 200
        static let placeholderImageName: String = "noImageIcon"
        static let dateAndSourceLabelText = " Source: "
    }

    var imageAspectRatio: CGFloat = 0.562 {
        didSet {
            // TODO: Try to trigger resizing
        }
    }

    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier _: String?) {
        super.init(style: style, reuseIdentifier: FeedCell.reuseIdentifier)
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
    }

    func setImage(_ imageData: Data?) {
        loadingIndicator.stopAnimating()
        guard let imageData = imageData, let fetchedImage = UIImage(data: imageData) else {
            articleImageView.image = UIImage(named: Constants.placeholderImageName)
            return
        }
        imageAspectRatio = fetchedImage.size.height / fetchedImage.size.width
        articleImageView.image = fetchedImage
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
            articleImageView.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 1),
            articleImageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 1, constant: 0),

            loadingIndicator.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor)
        ]

        dateAndSourceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultHigh - 1, for: .vertical)

        let generalConstraints = [
            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: imageAspectRatio),

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
