//
//  RootViewModel.swift
//  CloudBurst
//
//  Created by Decheng Ma on 21/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import Foundation

class RootViewModel {
    
    enum WeatherDataError: Error {
        case noWeatherDataAvailable
    }
    
    typealias DidFetchWeatherDataCompletion = ((WeatherData?, WeatherDataError?) -> Void)
    
    var didFetchWeatherData: DidFetchWeatherDataCompletion?
    
    init() {
        fetchWeatherData()
    }
    
    private func fetchWeatherData() {
        let weatherRequest = WeatherRequest(baseUrl: WeatherService.authenticatedBaseUrl, location: Default.location)
        
        URLSession.shared.dataTask(with: weatherRequest.url) { [weak self] (data, response, error) in
            if let response = response as? HTTPURLResponse {
                print("Status Code: \(response.statusCode)")
            }
            
            DispatchQueue.main.async {
                if let error = error {
                    print("Unable to fetch weather data \(error)")
                    
                    self?.didFetchWeatherData?(nil, .noWeatherDataAvailable)
                } else if let data = data {
                    let decoder = JSONDecoder()
                    
                    decoder.dateDecodingStrategy = .secondsSince1970
                    
                    do {
                        let darkSkyResponse = try decoder.decode(DarkSkyResponse.self, from: data)
                        
                        self?.didFetchWeatherData?(darkSkyResponse, nil)
                    } catch {
                        print("Unable to Decode JSON Response \(error)")
                        
                        self?.didFetchWeatherData?(nil, .noWeatherDataAvailable)
                    }
                } else {
                    self?.didFetchWeatherData?(nil, nil)
                }
            }
        }.resume()
    }
    
}
