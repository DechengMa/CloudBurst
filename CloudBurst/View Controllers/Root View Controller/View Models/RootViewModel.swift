//
//  RootViewModel.swift
//  CloudBurst
//
//  Created by Decheng Ma on 21/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import Foundation
import UIKit

class RootViewModel: NSObject {
    
    enum WeatherDataError: Error {
        case notAuthorizedToRequestLocation
        case failedToRequestLocation
        case noWeatherDataAvailable
    }
    
    enum WeatherDataResult {
        case success(WeatherData)
        case failure(WeatherDataError)
    }
    
    typealias FetchWeatherDataCompletion = ((WeatherDataResult) -> Void)
    
    var didFetchWeatherData: FetchWeatherDataCompletion?
    
    private let networkService: NetworkService
    private let locationService: LocationService
    
    init(networkService: NetworkService, locationService: LocationService) {
        
        self.networkService = networkService
        self.locationService = locationService
        
        super.init()
        
        setupNotificationHandling()
    }
    
    // Mark: - Helper
    
    private func fetchLocation() {
        locationService.fetchLocation { [weak self] (result) in
            switch result {
            case .success(let location):
                // Invoke Completion Handler
                self?.fetchWeatherData(for: location)
            case .failure(let error):
                print("Unable to Fetch Location \(error)")
                
                let result: WeatherDataResult = .failure(.notAuthorizedToRequestLocation)
                
                // Invoke Completion Handler
                self?.didFetchWeatherData?(result)
            }
        }
    }
    
    private func fetchWeatherData(for location: Location) {
        let weatherRequest = WeatherRequest(baseUrl: WeatherService.authenticatedBaseUrl, location: location)
        
        networkService.fetchData(with: weatherRequest.url) { [weak self] (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Unable to fetch weather data \(error)")
                    
                    let result: WeatherDataResult = .failure(.noWeatherDataAvailable)
                    
                    self?.didFetchWeatherData?(result)
                } else if let data = data {
                    let decoder = JSONDecoder()
                    
                    decoder.dateDecodingStrategy = .secondsSince1970
                    
                    do {
                        let darkSkyResponse = try decoder.decode(DarkSkyResponse.self, from: data)
                        
                        let result: WeatherDataResult = .success(darkSkyResponse)
                        
                        UserDefaults.didFetchWeatherData = Date()
                        
                        self?.didFetchWeatherData?(result)
                    } catch {
                        print("Unable to Decode JSON Response \(error)")
                        
                        let result: WeatherDataResult = .failure(.noWeatherDataAvailable)
                        
                        self?.didFetchWeatherData?(result)
                    }
                } else {
                    let result: WeatherDataResult = .failure(.noWeatherDataAvailable)
                    
                    self?.didFetchWeatherData?(result)
                }
            }
            }
    }
    
    private func setupNotificationHandling() {
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                               object: nil,
                                               queue: .main) { [weak self] (_) in
                                                guard let didFetchWeatherData = UserDefaults.didFetchWeatherData else {
                                                    self?.refresh()
                                                    return
                                                }
                                                
                                                if Date().timeIntervalSince(didFetchWeatherData) > Configuration.refreshThreshold {
                                                    self?.refresh()
                                                }
        }
    }
    
    func refresh() {
        fetchLocation()
    }
}

extension UserDefaults {
    private enum Keys {
        static let didFetchWeatherData = "didFetchWeatherData"
    }
    
    fileprivate class var didFetchWeatherData: Date? {
        get {
            return UserDefaults.standard.object(forKey: Keys.didFetchWeatherData) as? Date
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.didFetchWeatherData)
        }
    }
}
