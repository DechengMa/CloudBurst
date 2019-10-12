//
//  WeatherRequest.swift
//  CloudBurst
//
//  Created by Decheng Ma on 18/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import Foundation

struct WeatherRequest {
    
    let baseUrl: URL
    
    let location: Location
    
    private var latitude: Double {
        return location.latitude
    }
    
    private var longitude: Double {
        return location.longitude
    }
    
    var url: URL {
        return baseUrl.appendingPathComponent("\(latitude),\(longitude)")
    }
    
}
