//
//  WeekViewModel.swift
//  CloudBurst
//
//  Created by Decheng Ma on 22/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import Foundation


struct WeekViewModel {
    
    let weatherData: [ForecastWeatherConditions]
    
    var numberOfDays: Int {
        return weatherData.count
    }
    
    func viewModel(for index: Int) -> WeekDayViewModel {
        return WeekDayViewModel(weatherData: weatherData[index])
    }
    
}
