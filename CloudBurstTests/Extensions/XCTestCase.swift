//
//  XCTestCase.swift
//  CloudBurstTests
//
//  Created by Decheng Ma on 30/9/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import XCTest

extension XCTestCase {
    
    func loadStub(name: String, extension: String) -> Data {
        let bundle = Bundle(for: classForCoder)
        let url = bundle.url(forResource: name, withExtension: `extension`)
        
        return try! Data(contentsOf: url!)
    }
    
}
