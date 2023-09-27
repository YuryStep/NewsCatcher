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
        static let sourceCaptionText = "Source: "
        static let dateCaptionText = "Published at: "
    }

    static let reuseIdentifier = "FeedCellIdentifier"

    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var sourceNameLabel = UILabel(textStyle: .footnote)
    private lazy var dateLabel = UILabel(textStyle: .footnote)
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
        loadingIndicator.startAnimating()

        titleLabel.text = displayData.title
        descriptionLabel.text = displayData.description
        sourceNameLabel.text = Constants.sourceCaptionText + displayData.sourceName
        dateLabel.text = Constants.dateCaptionText + displayData.publishedAt
    }

    func setImage(_ imageData: Data?) {
        if let imageData = imageData, let fetchedImage = UIImage(data: imageData) {
            articleImageView.image = fetchedImage
        } else {
            articleImageView.image = UIImage(named: Constants.placeholderImageName)
        }
        loadingIndicator.stopAnimating()
    }

    private func setupSubviews() {
        let subviews = [loadingIndicator, articleImageView, sourceNameLabel, dateLabel, titleLabel, descriptionLabel]
        subviews.forEach { contentView.addSubview($0) }
        let marginGuide = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            loadingIndicator.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            loadingIndicator.topAnchor.constraint(equalToSystemSpacingBelow: marginGuide.topAnchor, multiplier: Constants.imageViewAspectRatio),
            loadingIndicator.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            loadingIndicator.heightAnchor.constraint(equalTo: marginGuide.widthAnchor, multiplier: Constants.imageViewAspectRatio),

            articleImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            articleImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: Constants.imageViewAspectRatio),

            sourceNameLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            sourceNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: articleImageView.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            sourceNameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),

            dateLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            dateLabel.topAnchor.constraint(equalToSystemSpacingBelow: sourceNameLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            dateLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: dateLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),

            descriptionLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
        ])
    }
}
