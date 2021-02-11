//
//  PushNotificationSender.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/30/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseMessaging
class PushNotificationSender {
    
    func ifUserHasToken(userId:String, completionHandler: @escaping (Any) -> ()) {
        // get the fcm token of the user
                let dbRef = Firestore.firestore().collection("users")
                dbRef.whereField("userId", isEqualTo: userId).getDocuments { (querySnap, error) in
                    if let err = error {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnap!.documents {
                            print("Data from the documents:\(document.data())")
                            if let token = document.get("fcmToken") {
                                completionHandler(token)
                            }
                        }
                    }
                }
    }
    func sendPushNotification(to user: String, title: String, body: String) {
        
        ifUserHasToken(userId: user) { (token) in
            let urlString = "https://fcm.googleapis.com/fcm/send"
                let url = NSURL(string: urlString)!
            let paramString: [String : Any] = ["to" : token as Any,
                                                   "notification" : ["title" : title, "body" : body],
                                                   "data" : ["user" : user]
                ]
                let request = NSMutableURLRequest(url: url as URL)
                request.httpMethod = "POST"
                request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("key=AAAARyFHiaI:APA91bGM5Mgro1GsQtwPQ79VvUD0sk8oYlq0UnFATJoYSk9ovOnBc0FG0ftg888vziy9gIY_MZbpFEhGvRsXPFsvAaL62BuKRQC-3BEyUlbSitwOnhk2S2CAlJmQtbVuzBNy-PigDkKT", forHTTPHeaderField: "Authorization")
                let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
                    do {
                        if let jsonData = data {
                            if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                                NSLog("Received data:\n\(jsonDataDict))")
                            }
                        }
                    } catch let err as NSError {
                        print(err.debugDescription)
                    }
                }
                task.resume()
        }
        
    }
}
