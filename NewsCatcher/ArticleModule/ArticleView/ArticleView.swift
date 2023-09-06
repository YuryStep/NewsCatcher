//
//  ArticleView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

protocol ArticleViewDelegate {
    func goToWebSourceButtonTapped()
}

class ArticleView: UIView {
    private struct Constants {
        static let systemSpacingMultiplier: CGFloat = 1
        static let imageViewAspectRatio: CGFloat = 0.6
        static let goToSourceButtonCornerRadius: CGFloat = 10
        static let timeIntervalforImagePlaceholder: Double = 5
        static let placeholderImageName: String = "noImageIcon"
        static let goToSourceButtonText: String = "Read in Source"
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
    
    private lazy var goToSourceButton2: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.goToSourceButtonText, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Constants.goToSourceButtonCornerRadius
        button.addTarget(self, action: #selector(goToSourceButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToSourceButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle(Constants.goToSourceButtonText, for: .normal)
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
        contentTextView.text = content
    }
    
    func update() {
        setNeedsDisplay()
    }
    
    // MARK: Output methods
    @objc func goToSourceButtonTapped() {
        delegate?.goToWebSourceButtonTapped()
    }
    
    // MARK: Private Methods
    private func setupSubviews() {
        addSubview(scrollView)
        let scrollViewSubviews = [articleImageView, titleLabel, contentTextView, loadingIndicator, goToSourceButton]
        scrollViewSubviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        scrollViewSubviews.forEach { scrollView.addSubview($0) }
        
        let marginGuide = layoutMarginsGuide
        
        loadingIndicator.setContentHuggingPriority(.defaultHigh, for: .vertical)
        articleImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
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
            // goToSourceButton constraints
            goToSourceButton.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            goToSourceButton.topAnchor.constraint(equalToSystemSpacingBelow: contentTextView.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            goToSourceButton.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            goToSourceButton.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
        ])
    }
    
}
