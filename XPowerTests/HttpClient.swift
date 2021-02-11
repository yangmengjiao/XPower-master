//
//  HttpClient.swift
//  XPowerTests
//
//  Created by Sangeetha Gengaram on 3/24/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
class HttpClient {
    typealias completeClosure = ( _ data: Data?, _ error: Error?)->Void
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol) {
        self.session = session
    }
    func get( url: URL, callback: @escaping completeClosure ) {
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            callback(data, error)
        }
        task.resume()
    }
}


protocol URLSessionProtocol { typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: NSURLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}
protocol URLSessionDataTaskProtocol { func resume() }


