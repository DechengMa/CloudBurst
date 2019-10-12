//
//  WeekDayRepresentable.swift
//  CloudBurst
//
//  Created by Decheng Ma on 1/10/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import UIKit

protocol WeekDayRepresentable {
    
    var day: String { get }
    var date: String { get }
    var temperature: String { get }
    var windSpeed: String { get }
    var image: UIImage? { get }
    
}
