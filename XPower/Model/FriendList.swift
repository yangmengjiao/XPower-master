//
//  FriendList.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/17/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
struct FriendList: Codable {
    let count: Int
    let results: [Friend]

    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case results = "results"
    }
}

// MARK: - Friend
struct Friend: Codable {
    let username: String

    enum CodingKeys: String, CodingKey {
        case username = "Username"
    }
}
struct FriendRequests: Codable {
    let count: Int
    let results: [Request]?

    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case results = "results"
    }
}

// MARK: - Request
struct Request: Codable {
    let username: String

    enum CodingKeys: String, CodingKey {
        case username = "Username"
    }
}

struct Conversation: Codable {
    let count: Int
    let messages: [Message]?

    enum CodingKeys: String, CodingKey {
        case count = "Count"
        case messages = "Messages"
    }
}

// MARK: - Message
struct Message: Codable {
    let dateAndTime, message, reciever, sender: String

    enum CodingKeys: String, CodingKey {
        case dateAndTime = "DateAndTime"
        case message = "Message"
        case reciever = "Reciever"
        case sender = "Sender"
    }
}
