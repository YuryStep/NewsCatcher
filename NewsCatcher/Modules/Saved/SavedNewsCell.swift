//
//  SavedNewsCell.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 24.10.2023.
//

import UIKit

final class SavedNewsCell: UICollectionViewCell {
    struct DisplayData {
        let title: String
        let description: String
        let publishedAt: String
        let sourceName: String
        let imageData: Data?
    }

    private enum Constants {
        static let defaultImageRatio: CGFloat = 0.562
        static let placeholderImageName: String = "noImageIcon"
        static let dateAndSourceLabelText = " Source: "
    }

    private var imageRatio: CGFloat {
        guard let image = articleImageView.image else { return Constants.defaultImageRatio }
        return image.size.height / image.size.width
    }

    private lazy var dateAndSourceLabel = UILabel(textStyle: .footnote)
    private lazy var titleLabel = UILabel(textStyle: .title2)
    private lazy var descriptionLabel = UILabel(textStyle: .body)

    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var imageContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
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
        descriptionLabel.text = displayData.description
        dateAndSourceLabel.text = displayData.publishedAt + Constants.dateAndSourceLabelText + displayData.sourceName
        setImage(displayData.imageData)
        setupSubviews()
    }

    private func setImage(_ imageData: Data?) {
        if let imageData = imageData, let image = UIImage(data: imageData) {
            articleImageView.image = image
        } else {
            articleImageView.image = UIImage(named: Constants.placeholderImageName)
        }
    }

    func getImageData() -> Data? {
        if let jpegImage = articleImageView.image?.jpegData(compressionQuality: 1) {
            return jpegImage
        }
        return articleImageView.image?.pngData()
    }

    private func setupSubviews() {
        imageContainer.addSubview(articleImageView)
        contentView.addSubviews([imageContainer, dateAndSourceLabel, titleLabel, descriptionLabel])

        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        NSLayoutConstraint.activate([
            articleImageView.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            articleImageView.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            articleImageView.widthAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 1),
            articleImageView.heightAnchor.constraint(equalTo: imageContainer.heightAnchor, multiplier: 1),

            imageContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: imageRatio),

            dateAndSourceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateAndSourceLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 8),
            dateAndSourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: dateAndSourceLabel.bottomAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
