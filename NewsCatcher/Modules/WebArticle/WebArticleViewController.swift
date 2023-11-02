//
//  WebArticleViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 07.09.2023.
//

import WebKit

final class WebArticleViewController: UIViewController {
    var sourceURL: URL!

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.load(URLRequest(url: sourceURL))
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()

    init(sourceURL: URL) {
        super.init(nibName: nil, bundle: nil)
        self.sourceURL = sourceURL
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        view.backgroundColor = .appBackground
        setupView()
    }

    private func setupView() {
        view.addSubviews([webView, activityIndicator])
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension WebArticleViewController: WKNavigationDelegate {
    func webView(_: WKWebView, didCommit _: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}
