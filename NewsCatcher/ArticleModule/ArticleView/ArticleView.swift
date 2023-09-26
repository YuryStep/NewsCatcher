//
//  ArticleView.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 02.09.2023.
//

import UIKit

protocol ArticleViewDelegate: AnyObject {
    func readInSourceButtonTapped()
}

final class ArticleView: UIView {
    private enum Constants {
        static let systemSpacingMultiplier: CGFloat = 1
        static let imageViewAspectRatio: CGFloat = 0.6
        static let goToSourceButtonCornerRadius: CGFloat = 10
        static let timeIntervalForImagePlaceholder = 5.0
        static let placeholderImageName = "noImageIcon"
        static let readInSourceButtonText = "Read in Source"
        static let sourceCaptionText = "Source: "
        static let dateCaptionText = "Published at: "
    }

    weak var delegate: ArticleViewDelegate?
    private var timer: Timer?

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var sourceNameLabel = UILabel(textStyle: .footnote)
    private lazy var dateLabel = UILabel(textStyle: .footnote)
    private lazy var titleLabel = UILabel(textStyle: .headline)
    private lazy var contentLabel = UILabel(textStyle: .body)

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    private lazy var readInSourceButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.readInSourceButtonText, for: .normal)
        button.layer.cornerRadius = Constants.goToSourceButtonCornerRadius
        button.addTarget(self, action: #selector(goToSourceButtonTapped), for: .touchUpInside)
        return button
    }()

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupSubviews()
    }

    func configure(withTitle title: String, sourceName: String, date: String, content: String) {
        timer?.invalidate()
        articleImageView.image = nil
        loadingIndicator.startAnimating()
        timer = Timer.scheduledTimer(withTimeInterval: Constants.timeIntervalForImagePlaceholder, repeats: false) { _ in
            if self.articleImageView.image == nil {
                self.loadingIndicator.stopAnimating()
                self.articleImageView.image = UIImage(named: Constants.placeholderImageName)
            }
        }
        titleLabel.text = title
        sourceNameLabel.text = Constants.sourceCaptionText + sourceName
        dateLabel.text = Constants.dateCaptionText + date
        contentLabel.text = content
    }

    func setImage(_ image: UIImage) {
        articleImageView.image = image
        loadingIndicator.stopAnimating()
    }

    func update() {
        setNeedsDisplay()
    }

    @objc func goToSourceButtonTapped() {
        delegate?.readInSourceButtonTapped()
    }

    private func setupSubviews() {
        addSubview(scrollView)
        let scrollViewSubviews = [loadingIndicator, articleImageView, sourceNameLabel, dateLabel, titleLabel, contentLabel, readInSourceButton]
        scrollViewSubviews.forEach { scrollView.addSubview($0) }
        let marginGuide = layoutMarginsGuide
        let scrollViewFrameGuide = scrollView.frameLayoutGuide
        let scrollViewContentGuide = scrollView.contentLayoutGuide
        contentLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
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
            // sourceNameLabel constraints
            sourceNameLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            sourceNameLabel.topAnchor.constraint(equalToSystemSpacingBelow: articleImageView.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            sourceNameLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            // dateLabel constraints
            dateLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            dateLabel.topAnchor.constraint(equalToSystemSpacingBelow: sourceNameLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            dateLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            // titleLabel constraints
            titleLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: dateLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            titleLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            // descriptionLabel constraints
            contentLabel.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            contentLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            contentLabel.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            // readInSourceButton constraints
            readInSourceButton.topAnchor.constraint(equalToSystemSpacingBelow: contentLabel.bottomAnchor, multiplier: Constants.systemSpacingMultiplier),
            readInSourceButton.leadingAnchor.constraint(equalTo: scrollViewContentGuide.leadingAnchor),
            readInSourceButton.trailingAnchor.constraint(equalTo: scrollViewContentGuide.trailingAnchor),
            readInSourceButton.bottomAnchor.constraint(equalTo: scrollViewContentGuide.bottomAnchor)
        ])
    }
}
