//
//  ViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/8/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var client:XpowerDataClient?
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var keepLoginSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        client = XpowerDataClient()
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "IMG_0268.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 0.5
        self.view.insertSubview(backgroundImage, at: 0)
        
        userNameField.delegate = self
        passwordField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        super.viewWillAppear(animated)
    }
       @IBAction func signUpButtonClicked(_ sender: Any) {
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(signUpVC, animated: true)
       }
       @IBAction func loginButtonClicked(_ sender: Any) {
         if userNameField.text=="" || passwordField.text=="" {
             DispatchQueue.main.async {
                let alert = Utilities.getAlertControllerwith(title: ACTION_REQUIRED, message: LOGIN_NO_EMPTY_ALLOWED, alertActionTitle: ACTION_OK)
                self.present(alert, animated: true, completion:nil)
               }
           }
           else {
            loginWithUsernameAndPassword(username: userNameField.text!, password: passwordField.text!)
            }
        
       }
    func loginWithUsernameAndPassword(username:String, password:String) {
        let loadView:UIView = Utilities.setLoadingBackgroundFor(viewController:self)
        let keepLogin = self.keepLoginSwitch.isOn
        let parameterDic = [USER_NAME:username,PASSWORD:password]
        client?.loginWithUsernameAndPassword(paramterDic: parameterDic, completionHandler: { (currentUserInfo, loginFailData) in
            if currentUserInfo != nil && keepLogin
            {
                if (Utilities.writeUserInfoToFile(userInfo: currentUserInfo!))
                {
                    DispatchQueue.main.async {
                    let alert = Utilities.getAlertControllerwith(title:MSG_SUCCESS , message: LOGIN_SUCCESS, alertActionTitle: ACTION_OK)
                    self.present(alert, animated: true, completion: nil)
                    self.setHomeViewController()
                    }
                }
            }
            else {
                DispatchQueue.main.async {
                    let alert = Utilities.getAlertControllerwith(title: APP_NAME, message: loginFailData!.Result, alertActionTitle: "Ok")
                self.present(alert, animated: true, completion:nil)
                }
            }
            
        })
        loadView.removeFromSuperview()
    }
    @IBAction func clearButton(_ sender: Any) {
        userNameField.text = ""
        passwordField.text = ""
    }
    func setHomeViewController()
    {
        let containerViewController = ContainerViewController()
        UIApplication.shared.windows.first?.rootViewController = containerViewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        let pushManager = PushNotificationManager(userID: Utilities.currentUserName())
        pushManager.registerForPushNotifications()
    }
}
extension LoginViewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
       
    }
    
}
