//
//  FeedCell.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 31.08.2023.
//

import UIKit

class FeedCell: UITableViewCell {
    private struct Constants {
        static let systemSpacingMultiplier: CGFloat = 1
        static let imageViewAspectRatio: CGFloat = 0.6
        static let placeholderImageName: String = "noImageIcon"
        static let timeIntervalforImagePlaceholder: Double = 5
        static let sourceCaptionText = "Source: "
        static let dateCaptionText = "Published at: "
    }
    
    static let reuseIdentifier = "FeedCellIdentifier"
    private var timer: Timer?
    
    // MARK: Subviews
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var sourceNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: Initializers:
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: FeedCell.reuseIdentifier)
        setupSubviews()
    }
    
    // MARK: Public API
    func configure(with image: UIImage?, title: String, sourceName: String, date: String, description: String) {
        timer?.invalidate()
        if let image = image {
            articleImageView.image = image
            loadingIndicator.stopAnimating()
        } else {
            articleImageView.image = nil
            loadingIndicator.startAnimating()
            timer = Timer.scheduledTimer(withTimeInterval: Constants.timeIntervalforImagePlaceholder, repeats: false) {_ in
                self.loadingIndicator.stopAnimating()
                self.articleImageView.image = UIImage(named: Constants.placeholderImageName)
            }
        }
        titleLabel.text = title
        descriptionLabel.text = description
        sourceNameLabel.text = Constants.sourceCaptionText + sourceName
        dateLabel.text = Constants.dateCaptionText + date
    }
    
    // MARK: Private Methods
    private func setupSubviews() {
        let subviews = [loadingIndicator, articleImageView, sourceNameLabel, dateLabel, titleLabel, descriptionLabel]
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        subviews.forEach { contentView.addSubview($0) }
        
        let marginGuide = contentView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            // loadingIndicator constraints
            loadingIndicator.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            loadingIndicator.topAnchor.constraint(equalToSystemSpacingBelow: marginGuide.topAnchor, multiplier: Constants.imageViewAspectRatio),
            loadingIndicator.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            loadingIndicator.heightAnchor.constraint(equalTo: marginGuide.widthAnchor, multiplier: Constants.imageViewAspectRatio),
            // articleImageView constraints
            articleImageView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            articleImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: Constants.imageViewAspectRatio),
            // sourceNameLabel constraints
            sourceNameLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            sourceNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: articleImageView.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            sourceNameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            // dateLabel constraints
            dateLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            dateLabel.topAnchor.constraint(equalToSystemSpacingBelow: sourceNameLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            dateLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            // titleLabel constraints
            titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: dateLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            // descriptionLabel constraints
            descriptionLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
        ])
    }
    
}
