//
//  Configuration.swift
//  CloudBurst
//
//  Created by Decheng Ma on 18/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import Foundation

enum Default {
    
    static let location = Location(latitude: -37.8922746, longitude: 145.0428544)
    
}

enum Configuration {
    static var refreshThreshold: TimeInterval {
        #if DEBUG
        return 60.0
        #else
        return 10.0 * 60.0
        #endif
    }
}

enum WeatherService {
    
    private static let apiKey = "a9deb4c0751d6b0804166270bce4cbe4"
    private static let baseUrl = URL(string: "https://api.darksky.net/forecast/")!
    
    static var authenticatedBaseUrl: URL {
        return baseUrl.appendingPathComponent(apiKey)
    }
    
}
