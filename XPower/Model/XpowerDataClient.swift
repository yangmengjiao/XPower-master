//
//  XpowerDataClient.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/10/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
import UIKit

let rest = RestManager()

struct XpowerDataClient {

    let decoder = JSONDecoder()
    func loginWithUsernameAndPassword(paramterDic:Dictionary<String,Any>, completionHandler: @escaping (UserInfo? , ResultData?)->()) {
        var jsonData:UserInfo?
        guard let url = URL(string: BASE_URL + USER_SERVICE_URL + AUTHENTICATION_PATH) else { return }
        rest.httpBodyParameters.addAllBodyParameters(dic: paramterDic)
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        jsonData = try self.decoder.decode(UserInfo.self, from: data)
                        completionHandler(jsonData, nil)
                    } catch  {
                        do {
                            let loginFailData = try self.decoder.decode(ResultData.self, from: data)
                            completionHandler(nil,loginFailData)
                        } catch  {
                            print("error decoding dta:\(error)")
                        }
                    }
                }
            }
        }
    }
    func signUpUser(parameters:Dictionary<String,Any>, completionHandler: @escaping (String)->()) {
        guard let url = URL(string: BASE_URL + USER_SERVICE_URL + CREATE_ACCOUNT)
            else
        {
            return
        }
        rest.httpBodyParameters.addAllBodyParameters(dic: parameters)
        rest.makePostRequest(toURL: url) { (results, success) in
            if success
            {
                if let data = results.data {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonData = try! self.decoder.decode(ResultData.self, from: data)
                    completionHandler(jsonData.Result)
                }
            }
        }
    }
    func getDeedsAndPoints(completionHandler: @escaping ([Points]) -> ()) {
        var pointsData:[Points]?
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + POINTS_TABLE)!
        rest.makeRequest(toURL: url, withHttpMethod: .get) { (results) in
            if results.response?.httpStatusCode == 200 {
                if let data = results.data {
                    do {
                        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                        pointsData = try self.decoder.decode(Array<Points>.self, from: data)
                        completionHandler(pointsData!)
                    } catch  {
                        print("error decoding dta:\(error)")
                    }
                }
            }
        }
    }
    
    func getFavouriteDeeds(completionHandler: @escaping (TasksList) -> ()) {
        var favTasks:TasksList?
        
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + GET_FAVORITE_TASK + "?Username=" + Utilities.currentUserName())!
        rest.makePostRequest(toURL: url) { (results, success) in
            if success
            {
                if let data = results.data {
                    do {
                        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                        favTasks = try self.decoder.decode(TasksList.self, from: data)
                        completionHandler(favTasks!)
                        
                    } catch  {
                        print("error decoding dta:\(error)")
                    }
                }
            }
        }
    }
    func addDeed(deed:String, completionHandler :  @escaping (String)->()) {
        let date:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let dateString:String = dateFormatter.string(from: date)
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + ADD_DEEDS)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "UserName")
        rest.httpBodyParameters.add(value: deed, forKey: "Deed")
        rest.httpBodyParameters.add(value: dateString, forKey: "Date")
        rest.makePostRequest(toURL: url) { (results, success) in
            if success
            {
                if let data = results.data {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonData = try! self.decoder.decode(ResultData.self, from: data)
                    completionHandler(jsonData.Result)
                }
            }
        }
        
    }
    func setFavoutiteTask(taskDescription:String,isFavorite:Bool, completionHandler :  @escaping (String)->()) {
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + SET_FAVORITE_TASK)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Username")
        rest.httpBodyParameters.add(value: taskDescription, forKey: "Task")
        rest.httpBodyParameters.add(value: isFavorite , forKey: "isFavorite")
        rest.makePostRequest(toURL: url, completionHandler: { (results, success) in
            if success
            {
                if let data = results.data {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonData = try! self.decoder.decode(ResultData.self, from: data)
                    completionHandler(jsonData.Result)
                }
            }
        })
    }
    func getRecentDeeds(completionHandler: @escaping ([RecentDeed]) -> ()) {
        var recentDeeds:[RecentDeed]?
        
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + RECENT_DEEDS + "?Username=" + Utilities.currentUserName())!
        rest.requestHttpHeaders.add(value: "application/json", forKey: "Content-Type")
        rest.makePostRequest(toURL: url) { (results, success) in
            if success
            {
                if let data = results.data {
                    do {
                        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                        recentDeeds = try self.decoder.decode([RecentDeed].self, from: data)
                        completionHandler(recentDeeds!)
                        
                    } catch  {
                        print("error decoding dta:\(error)")
                    }
                }
            }
        }
    }
    
    func getSchoolPoints(schoolName:String, completionHandler : @escaping (SchoolPoints) -> ()) {
        let str:String = BASE_URL + POINT_SERVICE_URL + SCHOOL_POINTS + "?Schoolname=" + schoolName

        guard let url = URL(string: str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
        rest.makePostRequest(toURL: url) { (results, success) in
            if success
            {
                if let data = results.data {
                    do {
                        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let schPoints:SchoolPoints = try self.decoder.decode(SchoolPoints.self, from: data)
                        completionHandler(schPoints)
                    } catch  {
                        print("error decoding dta:\(error)")
                    }
                }
            }
        }
    }
    func getFriendList(completionHandler : @escaping (FriendList) -> ()) {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + GET_FRIEND_LIST + "?Username=" + Utilities.currentUserName())!
        rest.makePostRequest(toURL: url) { (results, success) in
            if let data = results.data {
                do {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let friendList:FriendList = try self.decoder.decode(FriendList.self, from: data)
                    completionHandler(friendList)
                } catch  {
                    print("error decoding dta:\(error)")
                }
            }
        }
    }
    func getFriendRequestList(completionHandler :  @escaping (FriendRequests) -> ()) {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + GET_FRIEND_REQUEST_LIST + "?Username=" + Utilities.currentUserName())!
        rest.makePostRequest(toURL: url, completionHandler: { (results, success) in
            if success
            {
                if let data = results.data {
                    do {
                        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let friendReqs:FriendRequests = try self.decoder.decode(FriendRequests.self, from: data)
                        completionHandler(friendReqs)
                    } catch  {
                        print("error decoding dta:\(error)")
                    }
                }
            }
        })
    }
    func respondToFriendRequest(receiverName:String, status:Int, completionHandler :  @escaping (String)->()) {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + RESPOND_TO_REQUEST)!
        rest.httpBodyParameters.add(value: receiverName, forKey: "Sender")
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Reciever")
        rest.httpBodyParameters.add(value: status, forKey: "Status")
        
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let data = results.data {
                    let jsonData = try! self.decoder.decode(ResultData.self, from: data)
                    completionHandler(jsonData.Result)
                }
            }
        }
    }
    func addFriendRequest(receiverName:String, completionHandler :  @escaping (String)->()) {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + ADD_FRIEND_REQUEST)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Sender")
        rest.httpBodyParameters.add(value: receiverName, forKey: "Reciever")
        
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let data = results.data {
                    let jsonData = try! self.decoder.decode(ResultData.self, from: data)
                    completionHandler(jsonData.Result)
                }
            }
        }
        
    }
    func changePasswordWith(newPassword:String, completionHandler: @escaping (String)->()) {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + CHANGE_PASSWORD)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: USER_NAME)
        rest.httpBodyParameters.add(value: newPassword, forKey: PASSWORD)
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let data = results.data {
                    let jsonData = try! self.decoder.decode(ResultData.self, from: data)
                    completionHandler(jsonData.Result)
                }
            }
        }
    }
    func toggleTouchId(touchId:Bool, completionHandler: @escaping (String) -> ())  {
        let url = URL(string: BASE_URL + USER_SERVICE_URL + TOGGLE_TOUCH_ID)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: USER_NAME)
        rest.httpBodyParameters.add(value: touchId, forKey: TOUCH_ID_ON)
        
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let data = results.data {
                    let jsonData = try! self.decoder.decode(ResultData.self, from: data)
                    completionHandler(jsonData.Result)
                }
            }
        }
    }
    func getMessagesFrom(receiverName:String, completionHandler: @escaping (Conversation) -> ()) {
        //        let date:Date = Date()
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString:String = "1970/01/01 00:00:00"
        let url = URL(string: BASE_URL + CHAT_SERVICE_URL + GET_MESSAGES)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Sender")
        rest.httpBodyParameters.add(value: receiverName, forKey: "Reciever")
        rest.httpBodyParameters.add(value: dateString, forKey: "DateAndTime")
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let conversationMsg:Conversation = try self.decoder.decode(Conversation.self, from: data)
                        completionHandler(conversationMsg)
                    } catch  {
                        print("error decoding dta:\(error)")
                    }
                }
            }
        }
    }
    func sendMessage(receiverName:String, message:String, completionHandler: @escaping (String) -> ()) {
        let date:Date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let dateString:String = dateFormatter.string(from: date)
        let url = URL(string: BASE_URL + CHAT_SERVICE_URL + SEND_MESSAGE)!
        rest.httpBodyParameters.add(value: Utilities.currentUserName(), forKey: "Sender")
        rest.httpBodyParameters.add(value: receiverName, forKey: "Reciever")
        rest.httpBodyParameters.add(value: message, forKey: "Message")
        rest.httpBodyParameters.add(value: dateString, forKey: "DateAndTime")
        
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                if let data = results.data {
                    let jsonData = try! self.decoder.decode(ResultData.self, from: data)
                    completionHandler(jsonData.Result)
                }
            }
        }
    }
    func getUserProgress(completionHandler: @escaping (ProgressPoints, Int) ->()) {
        
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + GET_USER_PROGRESS + Utilities.currentUserName())!
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    do {
                        let userProgress:UserProgress = try self.decoder.decode(UserProgress.self, from: data)
                       let progressPoints =  self.modelProgressPoints(progress: userProgress)
                        completionHandler(progressPoints, userProgress.maxPoint)
                    } catch  {
                        print("error decoding dta:\(error)")
                    }
                }
            }
        }
    }
    func modelProgressPoints(progress:UserProgress) -> ProgressPoints {
        var progressPoints:ProgressPoints?
        var months:[Month] = [Month]()
        
        let month1:Month = Month(name: "Jan", progress: progress.jan )
                months.append(month1 )
        
        let month2:Month = Month(name: "Feb", progress: progress.feb )
                months.append(month2)
        let month3:Month = Month(name: "Mar", progress: progress.mar )
                months.append(month3)
        let month4:Month = Month(name: "Apr", progress: progress.apr)
                months.append(month4)
        let month5:Month = Month(name: "May", progress: progress.may)
               months.append(month5)
        let month6:Month = Month(name: "Jun", progress: progress.jun )
                months.append(month6)
        let month7:Month = Month(name: "Jul", progress: progress.jul)
               months.append(month7)
        let month8:Month = Month(name: "Aug", progress: progress.aug)
                months.append(month8)
        let month9:Month = Month(name: "Sep", progress: progress.sep)
                months.append(month9)
        let month10:Month = Month(name: "Oct", progress: progress.oct)
                months.append(month10)
        let month11:Month = Month(name: "Nov", progress: progress.nov)
               months.append(month11)
        let month12:Month = Month(name: "Dec", progress: progress.dec)
                months.append(month12)
        progressPoints = ProgressPoints(allMonths: months)
        return progressPoints!
    }
    func getUserDailyPoints(completionHandler: @escaping (Int) -> ()) {
        let url = URL(string: BASE_URL + POINT_SERVICE_URL + GET_DAILY_POINTS + Utilities.currentUserName())!
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonData = try! self.decoder.decode(DailyPoints.self, from: data )
                    completionHandler(jsonData.dailypoints)
                }
            }
        }
    }
    func getTotalSchoolPoints(completionHandler: @escaping (Int) -> ()) {
        let str:String = BASE_URL + POINT_SERVICE_URL + SCHOOL_POINTS + "?Schoolname=" + Utilities.currentUserSchoolName()

        guard let url = URL(string: str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else { return }
        
        rest.makePostRequest(toURL: url) { (results, success) in
            if success {
                if let data = results.data {
                    self.decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let jsonData = try! self.decoder.decode(SchoolPoints.self, from: data)
                    completionHandler(jsonData.totalpoints)
                }
            }
        }
    }
}
