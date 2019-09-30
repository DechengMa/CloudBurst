//
//  WeatherRequest.swift
//  CloudBurst
//
//  Created by Decheng Ma on 18/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherRequest {
    
    let baseUrl: URL
    
    let location: CLLocation
    
    private var latitude: Double {
        return location.coordinate.latitude
    }
    
    private var longitude: Double {
        return location.coordinate.longitude
    }
    
    var url: URL {
        return baseUrl.appendingPathComponent("\(latitude),\(longitude)")
    }
    
}
