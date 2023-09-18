//
//  WebArticleViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 07.09.2023.
//

import WebKit

final class WebArticleViewController: UIViewController {
    var webView: WKWebView!
    var sourceURL: URL!

    // MARK: Initializers

    init(webView: WKWebView = WKWebView(), sourceURL: URL) {
        super.init(nibName: nil, bundle: nil)
        self.webView = webView
        self.sourceURL = sourceURL
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        webView.navigationDelegate = self
        view = UIView()
        view.backgroundColor = .white
        setupView()
    }

    private func setupView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: sourceURL))
        webView.allowsBackForwardNavigationGestures = true
    }
}

// MARK: - WKNavigationDelegate

extension WebArticleViewController: WKNavigationDelegate {}
