//
//  UserInfo.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/17/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
struct UserInfo: Codable {
    let username, password, email, schoolName: String
    let avatarimageurl: String
    let touchIDOn: Bool

    enum CodingKeys: String, CodingKey {
        case username = "Username"
        case password = "Password"
        case email = "Email"
        case schoolName = "SchoolName"
        case avatarimageurl = "Avatarimageurl"
        case touchIDOn = "TouchIdOn"
    }
}
struct loginFailed: Codable {
    let result:String
    let reason:String
}
struct ResultData: Codable{
    let Result:String
}

