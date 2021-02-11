//
//  PointsAPITests.swift
//  XPowerTests
//
//  Created by Sangeetha Gengaram on 3/25/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import XCTest
@testable import XPower
class PointsAPITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testGetPointsDataWithExpectedURLHostAndPath() {
      let apiRepository = PointsAPIRepository()
        let mockURLSession  = MockURLSession1(data: nil, urlResponse: nil, error: nil)
        apiRepository.session = mockURLSession
        apiRepository.getPointsData(completion: { (pointsData, error) in
        })
        XCTAssertEqual(mockURLSession.cachedUrl?.host, BASE_URL)
        XCTAssertEqual(mockURLSession.cachedUrl?.path, POINT_SERVICE_URL+POINTS_TABLE)
    }
    func testGetPointsSuccessReturnsPoints() {
        let jsonData = "[{\"Description\": \"Shake dry your hands (5 points)\",\"Point\":5}, {\"Description\": \"Turn of the sink while brushing teeth (7 points)\",\"Point\": 7}]".data(using: .utf8)
        
      let apiRespository = PointsAPIRepository()
      let mockURLSession  = MockURLSession1(data: jsonData, urlResponse: nil, error: nil)
      apiRespository.session = mockURLSession
      let pointsExpectation = expectation(description: "points")
      var pointsData: [Points]?
//      var client = XpowerDataClient()
      apiRespository.getPointsData { (pointsArr, error) in
        pointsData = pointsArr
        pointsExpectation.fulfill()
      }
      waitForExpectations(timeout: 1) { (error) in
        XCTAssertNotNil(pointsData)
      }
    }
   func testGetPointsDataWhenResponseErrorReturnsError() {
      let apiRespository = PointsAPIRepository()
      let error = NSError(domain: "error", code: 1234, userInfo: nil)
      let mockURLSession  = MockURLSession1(data: nil, urlResponse: nil, error: error)
      apiRespository.session = mockURLSession
      let errorExpectation = expectation(description: "error")
      var errorResponse: Error?
      apiRespository.getPointsData { (pointsArr, error) in
        errorResponse = error
        errorExpectation.fulfill()
      }
      waitForExpectations(timeout: 1) { (error) in
        XCTAssertNotNil(errorResponse)
      }
    }
    func testGetPointsDataWhenEmptyDataReturnsError() {
      let apiRespository = PointsAPIRepository()
      let mockURLSession  = MockURLSession1(data: nil, urlResponse: nil, error: nil)
      apiRespository.session = mockURLSession
      let errorExpectation = expectation(description: "error")
      var errorResponse: Error?
      apiRespository.getPointsData { (pointsArr, error) in
        errorResponse = error
        errorExpectation.fulfill()
      }
      waitForExpectations(timeout: 1) { (error) in
        XCTAssertNotNil(errorResponse)
      }
    }
    func testGetPOintsDataInvalidJSONReturnsError() {
      let jsonData = "[{\"t\"}]".data(using: .utf8)
      let apiRespository = PointsAPIRepository()
      let mockURLSession  = MockURLSession1(data: jsonData, urlResponse: nil, error: nil)
      apiRespository.session = mockURLSession
      let errorExpectation = expectation(description: "error")
      var errorResponse: Error?
      apiRespository.getPointsData { (pointsArr, error) in
        errorResponse = error
        errorExpectation.fulfill()
      }
      waitForExpectations(timeout: 1) { (error) in
        XCTAssertNotNil(errorResponse)
      }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
