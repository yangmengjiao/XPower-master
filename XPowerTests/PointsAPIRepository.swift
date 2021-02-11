//
//  PointsAPIRepository.swift
//  XPowerTests
//
//  Created by Sangeetha Gengaram on 3/25/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
@testable import XPower
class PointsAPIRepository
{
    var session: URLSession!
    func getPointsData(completion: @escaping ([Points]?, Error?) -> Void) {
        guard let url = URL(string: "http://www.consoaring.com/PointService.svc/pointstable")
             else { fatalError() }
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
              completion(nil, error)
              return
            }
            guard let data = data else {
             completion(nil, NSError(domain: "no data", code: 10, userInfo: nil))
             return
            }
            
         do {
                let pointsArr = try JSONDecoder().decode([Points].self, from: data)
                completion(pointsArr, nil)
              } catch {
                completion(nil, error)
              }
            }.resume()
    }
    
}

