//
//  NetworkManager.swift
//  CloudBurst
//
//  Created by Decheng Ma on 12/10/19.
//  Copyright © 2019 Decheng. All rights reserved.
//

import Foundation

class NetworkManager: NetworkService {
    
    func fetchData(with url: URL, completionHandler: @escaping NetworkService.FetchDataCompletion) {
        URLSession.shared.dataTask(with: url, completionHandler: completionHandler).resume()
    }
    
}
