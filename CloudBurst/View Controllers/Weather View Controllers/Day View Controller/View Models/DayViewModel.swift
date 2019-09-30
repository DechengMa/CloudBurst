//
//  DayViewModel.swift
//  CloudBurst
//
//  Created by Decheng Ma on 22/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import UIKit

struct DayViewModel {
    
    // Mark: - Properties
    
    let weatherData: CurrentWeatherConditions
    
    private let dateFormatter = DateFormatter()
    
    var date: String {
        dateFormatter.dateFormat = "EEE, dd MMMM YYYY"
        
        return dateFormatter.string(from: weatherData.time)
    }
    
    var time: String {
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: weatherData.time)
    }
    
    var summary: String {
        return weatherData.summary
    }
    
    var temperature: String {
        return String(format: "%.1f F", weatherData.temperature)
    }
    
    var windSpeed: String {
        return String(format: "%.f MPH", weatherData.windSpeed)
    }
    
    var image: UIImage? {
        return UIImage.imageForIcon(with: weatherData.icon)
    }
    
}
