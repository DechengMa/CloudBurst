//
//  WeekDayViewModelTests.swift
//  CloudBurstTests
//
//  Created by Decheng Ma on 2/10/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import XCTest
import UIKit
@testable import CloudBurst

class WeekDayViewModelTests: XCTestCase {
    
    var viewModel: WeekDayViewModel!

    override func setUp() {
        super.setUp()
        
        let data = loadStub(name: "darksky", extension: "json")
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let darkSkyResponse = try! decoder.decode(DarkSkyResponse.self, from: data)
        
        viewModel = WeekDayViewModel(weatherData: darkSkyResponse.forecast[5])
    }

    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Tests for Day
    
    func testDay() {
        XCTAssertEqual(viewModel.day, "Saturday")
    }
    
    // MARK: - Tests for Date
    
    func testDate() {
        XCTAssertEqual(viewModel.date, "October 5")
    }
    
    // MARK: - Tests for Temperature
    
    func testTemperature() {
        XCTAssertEqual(viewModel.temperature, "50.8 °F - 76.5 °F")
    }
    
    // MARK: - Tests for Wind Speed
    
    func testWindSpeed() {
        XCTAssertEqual(viewModel.windSpeed, "8 MPH")
    }
    
    // MARK: - Tests for Image
    
    func testImage() {
        let viewModelImage = viewModel.image
        let imageDataViewModel = viewModelImage!.pngData()!
        let imageDataReference = UIImage(named: "cloudy")!.pngData()!
        
        XCTAssertNotNil(viewModelImage)
        XCTAssertEqual(viewModelImage!.size.width, 45.0)
        XCTAssertEqual(viewModelImage!.size.height, 33.0)
        XCTAssertEqual(imageDataViewModel, imageDataReference)
    }

}
