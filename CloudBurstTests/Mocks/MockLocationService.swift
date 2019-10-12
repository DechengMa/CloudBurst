//
//  MockLocationService.swift
//  CloudBurstTests
//
//  Created by Decheng Ma on 12/10/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import Foundation

@testable import CloudBurst

class MockLocationService: LocationService {
    
    var location: Location? = Location(latitude: 0.0, longitude: 0.0)
    var delay: TimeInterval = 0.0
    
    func fetchLocation(completion: @escaping MockLocationService.FetchLocationCompletion) {
        let result: LocationServiceResult
        
        if let location = location {
            result = .success(location)
        } else {
            result = .failure(.notAuthorizedToRequestLocation)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            completion(result)
        }
    }
    
}
