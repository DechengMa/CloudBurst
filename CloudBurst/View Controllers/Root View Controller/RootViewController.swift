//
//  RootViewController.swift
//  CloudBurst
//
//  Created by Decheng Ma on 17/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import UIKit

final class RootViewController: UIViewController {
    
    private enum AlertType {
        case noWeatherDataAvailable
    }
    
    // Mark: - Propeties
    
    var viewModel: RootViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            setupViewModel(with: viewModel)
        }
        
        
    }
    
    private let dayViewController: DayViewController = {
        guard let dayViewController = UIStoryboard.main.instantiateViewController(withIdentifier: DayViewController.storyboardIdentifier) as? DayViewController else {
            fatalError("Unable to Instantiate Day View Controller")
        }
        
        // Configure Day View Controller
        dayViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return dayViewController
    }()
    
    private let weekViewController: WeekViewController = {
        guard let weekViewController = UIStoryboard.main.instantiateViewController(withIdentifier: WeekViewController.storyboardIdentifier) as? WeekViewController else {
            fatalError("Unable to Instantiate Week View Controller")
        }
        
        // Configure Week View Controller
        weekViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return weekViewController
    }()
    
    // Mark: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Child View Controllers
        setupChildViewControllers()
    }

    // Mark: - Helper Methods
    
    private func setupChildViewControllers() {        
        // Add Child View Controllers
        addChild(dayViewController)
        addChild(weekViewController)
        
        // Add Child View as Subview
        view.addSubview(dayViewController.view)
        view.addSubview(weekViewController.view)
        
        // Configure Day View
        dayViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dayViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dayViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        // Configure Week View
        weekViewController.view.topAnchor.constraint(equalTo: dayViewController.view.bottomAnchor).isActive = true
        weekViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        weekViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        weekViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        // Notify Child View Controller
        dayViewController.didMove(toParent: self)
        weekViewController.didMove(toParent: self)
    }
    
    private func setupViewModel(with viewModel: RootViewModel) {
        viewModel.didFetchWeatherData = { [weak self] (weatherData, error) in
            if let _ = error {
               self?.presentAlert(of: .noWeatherDataAvailable)
            } else if let weatherData = weatherData {
                let dayViewModel = DayViewModel(weatherData: weatherData.current)
                self?.dayViewController.viewModel = dayViewModel
                
                let weekViewModel = WeekViewModel(weatherData: weatherData.forecast)
                
                self?.weekViewController.viewModel = weekViewModel
            } else {
                self?.presentAlert(of: .noWeatherDataAvailable)
            }
        }
    }
    
    private func presentAlert(of alertType: AlertType) {
        let title: String
        let message: String
        
        switch alertType {
        case .noWeatherDataAvailable:
            title = "Unable to Fetch Weather Data"
            message = "The app is unable to fetch weather data"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true)
        }
    }
}

