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
        case notAuthorizedToRequestLocation
        case failedToRequestLocation
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
    
    private lazy var weekViewController: WeekViewController = {
        guard let weekViewController = UIStoryboard.main.instantiateViewController(withIdentifier: WeekViewController.storyboardIdentifier) as? WeekViewController else {
            fatalError("Unable to Instantiate Week View Controller")
        }
        
        // Configure Week View Controller
        weekViewController.delegate = self
        weekViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return weekViewController
    }()
    
    // Mark: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup Child View Controllers
        setupChildViewControllers()
        
        viewModel?.refresh()
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
        viewModel.didFetchWeatherData = { [weak self] result in
            switch result {
            case .success(let weatherData):
                let dayViewModel = DayViewModel(weatherData: weatherData.current)
                self?.dayViewController.viewModel = dayViewModel
                
                let weekViewModel = WeekViewModel(weatherData: weatherData.forecast)
                
                self?.weekViewController.viewModel = weekViewModel
            case .failure(let error):
                let alertType: AlertType
                
                switch error {
                case .notAuthorizedToRequestLocation:
                    alertType = .notAuthorizedToRequestLocation
                case .failedToRequestLocation:
                    alertType = .failedToRequestLocation
                case .noWeatherDataAvailable:
                    alertType = .noWeatherDataAvailable
                }
                
                self?.presentAlert(of: .noWeatherDataAvailable)
                
                self?.dayViewController.viewModel = nil
                self?.weekViewController.viewModel = nil
            }
        }
    }
    
    private func presentAlert(of alertType: AlertType) {
        let title: String
        let message: String
        
        switch alertType {
        case .notAuthorizedToRequestLocation:
            title = "Unable to Fetch Weather Data"
            message = "Not authorized to accees your location"
        case .failedToRequestLocation:
            title = "Unable to Fetch Weather Data for Your Location"
            message = "Error"
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

extension RootViewController: WeekViewControllerDelegate {
    
    func controllerDidRefresh(_ controller: WeekViewController) {
        viewModel?.refresh()
    }
    
}
