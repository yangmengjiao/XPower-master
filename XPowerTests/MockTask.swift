//
//  MockTask.swift
//  XPowerTests
//
//  Created by Sangeetha Gengaram on 3/25/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
class MockTask: URLSessionDataTask {
  private let data: Data?
  private let urlResponse: URLResponse?
    private let nextError: Error?

  var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
  init(data: Data?, urlResponse: URLResponse?, error: Error?) {
    self.data = data
    self.urlResponse = urlResponse
    self.nextError = error
  }
  override func resume() {
    DispatchQueue.main.async {
        self.completionHandler!(self.data, self.urlResponse, self.nextError)
    }
  }
}
