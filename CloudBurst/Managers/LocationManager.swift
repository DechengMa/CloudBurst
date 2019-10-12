//
//  LocationManager.swift
//  CloudBurst
//
//  Created by Decheng Ma on 2/10/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, LocationService {
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        
        locationManager.delegate = self
        
        return locationManager
    }()
    
    private var didFetchLocation: FetchLocationCompletion?
    
    func fetchLocation(completion: @escaping LocationService.FetchLocationCompletion) {
        didFetchLocation = completion
        
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        } else {
            
            let result: LocationServiceResult = .failure(.notAuthorizedToRequestLocation)
            
            didFetchLocation?(result)
            
            didFetchLocation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let result: LocationServiceResult = .success(Location(location: location))
        didFetchLocation?(result )
        
        didFetchLocation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Unable to Fetch Location: (\(error))")
    }
    
}

fileprivate extension Location {
    
    init(location: CLLocation) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
}
