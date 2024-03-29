//
//  WeekViewModelTests.swift
//  CloudBurstTests
//
//  Created by Decheng Ma on 2/10/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import XCTest
@testable import CloudBurst

class WeekViewModelTests: XCTestCase {
    
    var viewModel: WeekViewModel!

    override func setUp() {
        super.setUp()
        
        let data = loadStub(name: "darksky", extension: "json")
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let darkSkyResponse = try! decoder.decode(DarkSkyResponse.self, from: data)
        
        viewModel = WeekViewModel(weatherData: darkSkyResponse.forecast)
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func testNumberOfDays() {
        XCTAssertEqual(viewModel.numberOfDays, 8)
    }
    
    func testViewModel() {
        let weekDayViewModel = viewModel.viewModel(for: 5)
        
        XCTAssertEqual(weekDayViewModel.day, "Saturday")
        XCTAssertEqual(weekDayViewModel.date, "October 5")
    }

}
