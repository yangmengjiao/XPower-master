//
//  MockUrlSession.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/25/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    var nextData:Data?
    var nextError:Error?
    
    private (set) var lastURL: URL?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
//        completionHandler(<#Data?#>, <#URLResponse?#>, <#Error?#>)
        completionHandler(nextData, successHttpURLResponse(request: request as URLRequest), nextError)
        return nextDataTask
    }
}
extension URLSession: URLSessionProtocol {
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }
}
