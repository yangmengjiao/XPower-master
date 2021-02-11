//
//  Utilities.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/18/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseMessaging

class Utilities {
    
    static func setLoadingBackgroundFor(viewController:UIViewController) ->UIView
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.width, height: viewController.view.bounds.height))
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = view.center
        view.addSubview(activityView)
        activityView.startAnimating()
        activityView.hidesWhenStopped = true
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = false
        viewController.view.addSubview(view)
        return view
    }
    static func noDataView(viewController:UIViewController, emptyMsg:String) -> UIView
    {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: viewController.view.bounds.width, height: viewController.view.bounds.height))
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: view.frame.size.height/2 - 20, width: viewController.view.bounds.width, height: 40))
        label.textAlignment = .center
        label.text = emptyMsg
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        view.addSubview(label)
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = false
        return view
    }
    static func getAlertControllerwith(title:String, message:String) ->UIAlertController
    {
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        return alert
    }
    static func getAlertControllerwith(title:String, message:String, alertActionTitle:String) -> UIAlertController {
        let alert = UIAlertController(title: title, message:message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: alertActionTitle, style: .default, handler: nil))
        return alert
    }
   static func writeUserInfoToFile(userInfo:UserInfo) -> Bool {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
        .userDomainMask,
        true)
        let fileName:String = "userinfo"
        var success:Bool = false

        if let documentPath = documentDirectory.first {
            var url = URL(fileURLWithPath: documentPath)
            url = url.appendingPathComponent(fileName)
            var dictionary:Dictionary<String, Any> = Dictionary()
            dictionary[USER_NAME] = userInfo.username
            dictionary[PASSWORD] = userInfo.password
            dictionary[EMAIL] = userInfo.email
            dictionary[SCHOOL_NAME] = userInfo.schoolName
            let defaults = UserDefaults.standard
            defaults.set(userInfo.username, forKey: USER_NAME)
            defaults.set(userInfo.schoolName, forKey: SCHOOL_NAME)
            success = (dictionary as NSDictionary).write(to: url, atomically: true)
        }
        return success
    }
    static func readUserInfoFromFile() ->Bool
    {
        var userInfoAvailable:Bool = false
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
        .userDomainMask,
        true)
        let fileName:String = "userinfo"
        if let documentPath = documentDirectory.first {
        var url = URL(fileURLWithPath: documentPath)
           url = url.appendingPathComponent(fileName)
            if let dictionary = NSMutableDictionary(contentsOf: url) {
                let swiftDictionary:Dictionary<String,Any> = dictionary as! Dictionary
                if (swiftDictionary[USER_NAME] != nil) {
                    let defaults = UserDefaults.standard
                    defaults.set(swiftDictionary[USER_NAME], forKey: USER_NAME)
                    defaults.set(swiftDictionary[SCHOOL_NAME], forKey: SCHOOL_NAME)
                    userInfoAvailable = true
                }
            }
        }
        return userInfoAvailable
    }
    static func currentUserName() ->String
    {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: USER_NAME) as! String
    }
    static func currentUserSchoolName() -> String
    {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: SCHOOL_NAME) as! String
    }
    static func logOutUser()
    {
        let fileManager = FileManager.default
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
        .userDomainMask,
        true)
        let fileName:String = "userinfo"
        if let documentPath = documentDirectory.first {
        var url = URL(fileURLWithPath: documentPath)
           url = url.appendingPathComponent(fileName)
            do {
                try fileManager.removeItem(at: url)
            } catch let error as NSError {
                print("------Error",error.debugDescription)
            }
        }
        Firestore.firestore().collection("users").document(self.currentUserName()).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: USER_NAME)
            defaults.removeObject(forKey: USER_IMG_AVATAR)

        }
        
    }
    
}
