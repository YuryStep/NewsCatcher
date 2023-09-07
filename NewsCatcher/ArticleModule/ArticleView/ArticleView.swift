//
//  ArticleView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

protocol ArticleViewDelegate {
    func readInSourceButtonTapped()
}

class ArticleView: UIView {
    private struct Constants {
        static let systemSpacingMultiplier: CGFloat = 1
        static let imageViewAspectRatio: CGFloat = 0.6
        static let goToSourceButtonCornerRadius: CGFloat = 10
        static let timeIntervalforImagePlaceholder: Double = 5
        static let placeholderImageName: String = "noImageIcon"
        static let readInSourceButtonText: String = "Read in Source"
    }
    
    var delegate: ArticleViewDelegate?
    var index: Int?
    private var timer: Timer?
    
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
    
    private lazy var contentTextLabel: UILabel = {
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
    
    private lazy var readInSourceButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle(Constants.readInSourceButtonText, for: .normal)
        button.layer.cornerRadius = Constants.goToSourceButtonCornerRadius
        button.addTarget(self, action: #selector(goToSourceButtonTapped), for: .touchUpInside)
        return button
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
        contentTextLabel.text = content
    }
    
    func update() {
        setNeedsDisplay()
    }
    
    // MARK: Output methods
    @objc func goToSourceButtonTapped() {
        delegate?.readInSourceButtonTapped()
    }
    
    private func setupSubviews() {
        addSubview(scrollView)
        let scrollViewSubviews = [articleImageView, titleLabel, contentTextLabel, loadingIndicator, readInSourceButton]
        scrollViewSubviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        scrollViewSubviews.forEach { scrollView.addSubview($0) }
        
        let marginGuide = layoutMarginsGuide
        let scrollViewFrameGuide = scrollView.frameLayoutGuide
        let scrollViewContentGuide = scrollView.contentLayoutGuide
        
        contentTextLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        readInSourceButton.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        NSLayoutConstraint.activate([
            // scrollView constraints
            scrollViewFrameGuide.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            scrollViewFrameGuide.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            scrollViewFrameGuide.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            scrollViewFrameGuide.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor),
            scrollViewFrameGuide.widthAnchor.constraint(equalTo: scrollViewContentGuide.widthAnchor),
            // loadingIndicator constraints
            loadingIndicator.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            loadingIndicator.topAnchor.constraint(equalToSystemSpacingBelow: scrollViewContentGuide.topAnchor, multiplier: Constants.imageViewAspectRatio),
            loadingIndicator.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            loadingIndicator.heightAnchor.constraint(equalTo: scrollViewContentGuide.widthAnchor, multiplier: Constants.imageViewAspectRatio),
            // articleImageView constraints
            articleImageView.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            articleImageView.topAnchor.constraint(equalToSystemSpacingBelow: scrollViewContentGuide.topAnchor, multiplier: Constants.imageViewAspectRatio),
            articleImageView.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: Constants.imageViewAspectRatio),
            // titleLabel constraints
            titleLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: articleImageView.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            titleLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            // descriptionLabel constraints
            contentTextLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            contentTextLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            contentTextLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            // readInSourceButton constraints
            readInSourceButton.topAnchor.constraint(equalToSystemSpacingBelow: contentTextLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            readInSourceButton.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            readInSourceButton.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            readInSourceButton.bottomAnchor.constraint(equalTo: scrollViewContentGuide.bottomAnchor)
        ])
    }
    
}
