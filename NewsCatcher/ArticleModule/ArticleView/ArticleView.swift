//
//  ArticleView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

class ArticleView: UIView {
    private struct Constants {
        static let systemSpacingMultiplier: CGFloat = 1
        static let imageViewAspectRatio: CGFloat = 0.6
    }
    
    var index: Int?
    
    // MARK: Subviews
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var contentTextView: UITextView = {
        let label = UITextView()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
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
    
    init(frame: CGRect, index: Int) {
        super.init(frame: frame)
        self.index = index
        backgroundColor = .white
        setupSubviews()
    }
    
    // MARK: Input methods
    func configure(with image: UIImage?, title: String, content: String) {
        if let image = image {
            articleImageView.image = image
            loadingIndicator.stopAnimating()
        } else {
            articleImageView.image = nil
            loadingIndicator.startAnimating()
        }
        titleLabel.text = title
        contentTextView.text = content
    }
    
    func update() {
        setNeedsDisplay()
    }
    
    // MARK: Private Methods
    private func setupSubviews() {
        addSubview(scrollView)
        let scrollViewSubviews = [articleImageView, titleLabel, contentTextView, loadingIndicator]
        scrollViewSubviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        scrollViewSubviews.forEach { scrollView.addSubview($0) }
        
        let marginGuide = layoutMarginsGuide
        
        loadingIndicator.setContentHuggingPriority(.defaultHigh, for: .vertical)
        articleImageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        contentTextView.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        NSLayoutConstraint.activate([
            // scrollView constraints
            scrollView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: articleImageView.widthAnchor),
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
            // contentTextView constraints
            contentTextView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            contentTextView.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            contentTextView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            contentTextView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
        ])
    }
    
}
