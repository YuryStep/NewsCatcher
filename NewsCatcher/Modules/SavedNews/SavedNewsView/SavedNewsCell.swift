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
        static let dateAndSourceLabelText = " Source: "
    }

    private lazy var dateAndSourceLabel = UILabel(textStyle: .footnote)
    private lazy var titleLabel = UILabel(textStyle: .title2)
    private lazy var descriptionLabel = UILabel(textStyle: .body)

    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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

    func getImageData() -> Data? {
        if let jpegImage = articleImageView.image?.jpegData(compressionQuality: 1) {
            return jpegImage
        }
        return articleImageView.image?.pngData()
    }

    private func setImage(_ imageData: Data?) {
        if let imageData = imageData, let image = UIImage(data: imageData) {
            let resizedImage = image.resizeToScreenWidth()
            articleImageView.image = resizedImage
        } else {
            let placeholderImage = UIImage(resource: .noImageIcon).resizeToScreenWidth()
            articleImageView.image = placeholderImage
        }
    }

    private func setupSubviews() {
        contentView.addSubviews([articleImageView, dateAndSourceLabel, titleLabel, descriptionLabel])
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            articleImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

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
