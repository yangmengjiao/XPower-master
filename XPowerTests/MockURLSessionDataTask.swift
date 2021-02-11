//
//  MockURLSessionDataTask.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/25/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}
