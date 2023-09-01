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
    }
    
    static let reuseIdentifier = "FeedCellIdentifier"
    
    // MARK: Subviews
    lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
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
    func configure(with image: UIImage?, title: String, description: String) {
        if let image = image {
            articleImageView.image = image
            loadingIndicator.stopAnimating()
        } else {
            articleImageView.image = nil
            loadingIndicator.startAnimating()
        }
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    // MARK: Private Methods
    private func setupSubviews() {
        let subviews = [articleImageView, titleLabel, descriptionLabel, loadingIndicator]
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
            articleImageView.topAnchor.constraint(equalToSystemSpacingBelow: marginGuide.topAnchor, multiplier: Constants.imageViewAspectRatio),
            articleImageView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: Constants.imageViewAspectRatio),
            // titleLabel constraints
            titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: articleImageView.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            // descriptionLabel constraints
            descriptionLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
        ])
    }
    
}
