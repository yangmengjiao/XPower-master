//
//  HttpClientTests.swift
//  XPowerTests
//
//  Created by Sangeetha Gengaram on 3/25/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import XCTest
class HttpClientTests: XCTestCase {

      var httpClient: HttpClient!
      let session = MockURLSession()
      override func setUp() {
          super.setUp()
          httpClient = HttpClient(session: session)
      }
      override func tearDown() {
          super.tearDown()
      }

    func test_get_request_withURL() {
        guard let url = URL(string: "https://mockurl") else {
            fatalError("URL can't be empty")
        }
        httpClient.get(url: url) { (success, response) in
            // Return data
        }
        XCTAssert(session.lastURL == url)
    }
    func test_get_resume_called() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        guard let url = URL(string: "https://mockurl") else {
            fatalError("URL can't be empty")
        }
        httpClient.get(url: url) { (success, response) in
            // Return data
        }
        XCTAssert(dataTask.resumeWasCalled)
    }
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
