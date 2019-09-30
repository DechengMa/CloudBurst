//
//  WeekViewController.swift
//  CloudBurst
//
//  Created by Decheng Ma on 17/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import UIKit

final class WeekViewController: UIViewController {
    
    var viewModel: WeekViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            setupViewModel(with: viewModel)
        }
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup View
        setupView()
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        // Configure View
        view.backgroundColor = .red
    }
    
    private func setupViewModel(with viewModel: WeekViewModel) {
        print(viewModel)
    }
}

