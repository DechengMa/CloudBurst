//
//  DayViewModelTests.swift
//  CloudBurstTests
//
//  Created by Decheng Ma on 30/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import XCTest
import UIKit
@testable import CloudBurst

class DayViewModelTests: XCTestCase {
    
    var viewModel: DayViewModel!
    
    override func setUp() {
        super.setUp()
        
        let data = loadStub(name: "darksky", extension: "json")
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let darkSkyResponse = try! decoder.decode(DarkSkyResponse.self, from: data)
        
        viewModel = DayViewModel(weatherData: darkSkyResponse.current)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDate() {
        XCTAssertEqual(viewModel.date, "Mon, 30 September 2019")
    }
    
    func testTime() {
        XCTAssertEqual(viewModel.time, "10:36 PM")
    }
    
    func testSummary() {
        XCTAssertEqual(viewModel.summary, "Partly Cloudy")
    }
    
    func testTemperature() {
        XCTAssertEqual(viewModel.temperature, "47.9 F")
    }
    
    func testWindSpeed() {
        XCTAssertEqual(viewModel.windSpeed, "8 MPH")
    }
    
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
