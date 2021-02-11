//
//  ChangePwdViewController.swift
//  XPower
//
//  Created by Mengjiao Yang on 3/20/20.
//  Copyright © 2020 Mengjiao Yang. All rights reserved.
//

import UIKit

class ChangePwdViewController: UIViewController {

    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBOutlet weak var oldPwdTextField: UITextField!
    @IBOutlet weak var newPwdTextField: UITextField!
    let client:XpowerDataClient = XpowerDataClient()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changePasswordClicked(_ sender: Any) {
        if comparePassword() {
            client.changePasswordWith(newPassword: confirmPwdTextField.text ?? "") { (result) in
                self.showAlertWithMessage(message: result)
            }
        }
        
    }
    func showAlertWithMessage(message:String) {
        DispatchQueue.main.async {
            let alert = Utilities.getAlertControllerwith(title: APP_NAME, message: message)
            self.present(alert, animated: true, completion: {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_ ) in
                    self.dismiss(animated: true, completion: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            })
            }
    }
    func comparePassword() -> Bool {
        if (oldPwdTextField?.text != newPwdTextField.text) && (newPwdTextField.text == confirmPwdTextField.text) {
            return true
        }
        else {
            return false
        }
    }
}
