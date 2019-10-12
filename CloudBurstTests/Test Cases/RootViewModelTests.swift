//
//  RootViewModelTests.swift
//  CloudBurstTests
//
//  Created by Decheng Ma on 12/10/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import XCTest
@testable import CloudBurst

class RootViewModelTests: XCTestCase {
    
    var viewModel: RootViewModel!
    
    var networkService: MockNetworkService!
    var locationService: MockLocationService!

    override func setUp() {
        super.setUp()
        
        networkService = MockNetworkService()
        
        networkService.data = loadStub(name: "darksky", extension: "json")
        
        locationService = MockLocationService()
        
        viewModel = RootViewModel(networkService: networkService, locationService: locationService)
    }

    override func tearDown() {
        super.tearDown()
        
        UserDefaults.standard.removeObject(forKey: "didFetchWeatherData")
    }
    
    func testRefresh_Success() {
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = { (result) in
            if case .success(let weatherData) = result {
                XCTAssertEqual(weatherData.latitude, -37.8922746)
                XCTAssertEqual(weatherData.longitude, 145.0428544)
                
                expectation.fulfill()
            }
        }
        
        viewModel.refresh()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRefresh_FailedToFetchLocation() {
        locationService.location = nil
        
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = { (result) in
            if case .failure(let error) = result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.notAuthorizedToRequestLocation)
                
                expectation.fulfill()
            }
        }
        
        viewModel.refresh()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRefresh_FailedToFetchWeatherData_RequestFailed() {
        networkService.error = NSError(domain: "com.cocoacasts.com.network.service", code: 1, userInfo: nil)
        
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = { (result) in
            if case .failure(let error) = result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.noWeatherDataAvailable)
                
                expectation.fulfill()
            }
        }
        
        viewModel.refresh()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testRefresh_FailedToFetchWeatherData_InvalidResponse() {
        networkService.data = "data".data(using: .utf8)
        
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = { (result) in
            if case .failure(let error) = result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.noWeatherDataAvailable)
                
                expectation.fulfill()
            }
        }
        
        viewModel.refresh()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    
    func testRefresh_FailedToFetchWeatherData_NoErrorNoResponse() {
        networkService.data = nil
        
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = { (result) in
            if case .failure(let error) = result {
                XCTAssertEqual(error, RootViewModel.WeatherDataError.noWeatherDataAvailable)
                
                expectation.fulfill()
            }
        }
        
        viewModel.refresh()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testApplicationWillEnterForeground_NoTimestamp() {
        UserDefaults.standard.removeObject(forKey: "didFetchWeatherData")
        
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = { (result) in
            expectation.fulfill()
        }
        
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testApplicationWillEnterForeground_ShouldRefresh() {
        UserDefaults.standard.set(Date().addingTimeInterval(-3600.0), forKey: "didFetchWeatherData")
        
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        viewModel.didFetchWeatherData = { (result) in
            expectation.fulfill()
        }
        
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testApplicationWillEnterForeground_ShouldNotRefresh() {
        UserDefaults.standard.set(Date(), forKey: "didFetchWeatherData")
        
        let expectation = XCTestExpectation(description: "Fetch Weather Data")
        
        expectation.isInverted = true
        
        viewModel.didFetchWeatherData = { (result) in
            expectation.fulfill()
        }
        
        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)
        
        wait(for: [expectation], timeout: 2.0)
    }

}
