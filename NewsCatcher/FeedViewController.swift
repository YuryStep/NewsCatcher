//
//  ViewController.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 30.08.2023.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: Dependencies:
    var feedView: FeedView!
    
    
    override func loadView() {
        view = feedView
        navigationItem.title = "News Title"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

