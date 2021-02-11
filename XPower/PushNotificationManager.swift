//
//  PushNotificationManager.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/26/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications
class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    let userID: String
    init(userID: String) {
        self.userID = userID
        super.init()
    }
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        updateFirestorePushTokenIfNeeded()
    }
    func updateFirestorePushTokenIfNeeded() {
       
        if let token = Messaging.messaging().fcmToken {
            let usersRef = Firestore.firestore().collection("users").document(userID)
            usersRef.setData(["fcmToken": token, "userId" : userID])
        }
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        updateFirestorePushTokenIfNeeded()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("User notification center")
        
        let userInfo:Dictionary<String,Any> = response.notification.request.content.userInfo as! Dictionary<String, Any>
        let alertDic:Dictionary<String,Any> = userInfo["aps"] as! Dictionary<String,Any>
        let NotificationAlert:Dictionary<String,String> = alertDic["alert"] as! Dictionary<String, String>
      
        if (NotificationAlert["title"]?.contains(NOTIFICATION_TITLE_MESSAGE))! {
            let username = NotificationAlert["title"]?.replacingOccurrences(of: String(format: "%@ from", NOTIFICATION_TITLE_MESSAGE) , with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            let containerVC = UIApplication.shared.windows.first?.rootViewController as! ContainerViewController
            containerVC.toggleLeftPanel()
            containerVC.didSelectMenu(VC: Menu(menuName: .friends, controllerName: "FriendListViewController"))
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            chatVC.receiverName = username
            containerVC.centerNavigationController?.pushViewController(chatVC, animated: true)
            
        }
        if ((NotificationAlert["title"]?.contains(NOTIFICATION_TITLE_REQUEST))!) {
            let containerVC = UIApplication.shared.windows.first?.rootViewController as! ContainerViewController
            containerVC.toggleLeftPanel()
            containerVC.didSelectMenu(VC: Menu(menuName: .friends, controllerName: "FriendListViewController"))
            
        }
        completionHandler()
    }
}
