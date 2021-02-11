//
//  AppDelegate.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/8/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Received remote notification")
        let  apsDict = userInfo as! Dictionary<String, Any>
        let alertDic:Dictionary<String,Any> = apsDict["aps"] as! Dictionary<String,Any>
        let NotificationAlert:Dictionary<String,String> = alertDic["alert"] as! Dictionary<String, String>
        if (NotificationAlert["title"]?.contains(NOTIFICATION_TITLE_MESSAGE))! {
            let username = NotificationAlert["title"]?.replacingOccurrences(of: String(format: "%@ from", NOTIFICATION_TITLE_MESSAGE) , with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            let containerVC = UIApplication.shared.windows.first?.rootViewController as! ContainerViewController
            containerVC.toggleLeftPanel()
            containerVC.didSelectMenu(VC: Menu(menuName: .friends, controllerName: "FriendListViewController"))
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let chatVC = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            chatVC.receiverName = username
            containerVC.navigationController?.pushViewController(chatVC, animated: true)
            
        }
        if ((NotificationAlert["title"]?.contains(NOTIFICATION_TITLE_REQUEST))!) {
            let containerVC = UIApplication.shared.windows.first?.rootViewController as! ContainerViewController
            containerVC.toggleLeftPanel()
            containerVC.didSelectMenu(VC: Menu(menuName: .friends, controllerName: "FriendListViewController"))
            
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken :\(deviceToken)")
    }
}

