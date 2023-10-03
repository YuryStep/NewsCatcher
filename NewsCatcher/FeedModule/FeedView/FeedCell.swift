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
        static let imageViewAspectRatio: CGFloat = 0.6
        static let placeholderImageName: String = "noImageIcon"
        static let dateAndSourceLabelText = " Source: "
    }

    static let reuseIdentifier = "FeedCellIdentifier"

    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var dateAndSourceLabel = UILabel(textStyle: .footnote)
    private lazy var titleLabel = UILabel(textStyle: .title1)
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
    }

    func configure(with displayData: DisplayData) {
        clearPreviousConfiguration()
        loadingIndicator.startAnimating()
        titleLabel.text = displayData.title
        descriptionLabel.text = displayData.description
        dateAndSourceLabel.text = displayData.publishedAt + Constants.dateAndSourceLabelText + displayData.sourceName
    }

    private func clearPreviousConfiguration() {
        articleImageView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateAndSourceLabel.text = nil
    }

    func setImage(_ imageData: Data?) {
        loadingIndicator.stopAnimating()
        guard let imageData = imageData, let fetchedImage = UIImage(data: imageData) else {
            articleImageView.image = UIImage(named: Constants.placeholderImageName)
            return
        }
        articleImageView.image = fetchedImage
    }

    private func setupSubviews() {
        let subviews = [loadingIndicator, articleImageView, dateAndSourceLabel, titleLabel, descriptionLabel]
        subviews.forEach { contentView.addSubview($0) }

        NSLayoutConstraint.activate([
            loadingIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            loadingIndicator.topAnchor.constraint(equalToSystemSpacingBelow: contentView.topAnchor, multiplier: Constants.imageViewAspectRatio),
            loadingIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            loadingIndicator.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.75),

            articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: 0.75),

            dateAndSourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateAndSourceLabel.topAnchor.constraint(equalToSystemSpacingBelow: articleImageView.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            dateAndSourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: dateAndSourceLabel.bottomAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
