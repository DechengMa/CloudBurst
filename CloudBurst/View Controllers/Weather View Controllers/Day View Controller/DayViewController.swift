//
//  DayViewController.swift
//  CloudBurst
//
//  Created by Decheng Ma on 17/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import UIKit

final class DayViewController: UIViewController {
    
    var viewModel: DayViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            
            setupViewModel(with: viewModel)
        }
    }
    
    // Mark: - Description
    
    @IBOutlet var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = .baseTextColor
            dateLabel.font = .heavyLarge
        }
    }
    
    @IBOutlet var timeLabel: UILabel! 
    
    @IBOutlet var iconImageView: UIImageView! {
        didSet {
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.tintColor = .baseTintColor
        }
    }
    
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView! {
        didSet {
            activityIndicatorView.startAnimating()
            activityIndicatorView.hidesWhenStopped = true
        }
    }
    
    @IBOutlet var temperatureLabel: UILabel!
    
    @IBOutlet var windSpeedLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var regularLabels: [UILabel]! {
        didSet {
            for label in regularLabels {
                label.textColor = .black
                label.font = .lightRegular
            }
        }
    }
    
    @IBOutlet var smallLabels: [UILabel]! {
        didSet {
            for label in smallLabels {
                label.textColor = .black
                label.font = .lightSmall
            }
        }
    }
    
    @IBOutlet var weatherDataViews: [UIView]! {
        didSet {
            for view in weatherDataViews {
                view.isHidden = true
            }
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
        view.backgroundColor = .lightBackgroundColor
    }
    
    private func setupViewModel(with viewModel: DayViewModel) {
        activityIndicatorView.stopAnimating()
        
        dateLabel.text = viewModel.date
        timeLabel.text = viewModel.time
        windSpeedLabel.text = viewModel.windSpeed
        temperatureLabel.text = viewModel.temperature
        descriptionLabel.text = viewModel.summary
        
        iconImageView.image = viewModel.image
        
        for view in weatherDataViews {
            view.isHidden = false
        }
    }
    
}
