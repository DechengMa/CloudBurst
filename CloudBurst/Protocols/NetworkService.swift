//
//  NetworkService.swift
//  CloudBurst
//
//  Created by Decheng Ma on 12/10/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import Foundation

protocol NetworkService {

    typealias FetchDataCompletion = (Data?, URLResponse?, Error?) -> Void
    
    func fetchData(with url: URL, completionHandler: @escaping FetchDataCompletion)
    
}
