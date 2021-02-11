//
//  MockURLSession1.swift
//  XPowerTests
//
//  Created by Sangeetha Gengaram on 3/25/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
class MockURLSession1: URLSession {
    var cachedUrl: URL?
    private let mockTask: MockTask
    
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
    mockTask = MockTask(data: data, urlResponse: urlResponse, error:
    error)
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    self.cachedUrl = url
    mockTask.completionHandler = completionHandler
    return mockTask
    }
}
