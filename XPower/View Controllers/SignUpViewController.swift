//
//  SignUpViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/11/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit
import Photos

class SignUpViewController: UIViewController {
var client:XpowerDataClient?
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var schoolNameLabel: UILabel!
    var imagePicker:UIImagePickerController!
    var schoolName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "IMG_0268.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 0.5
        self.view.insertSubview(backgroundImage, at: 0)
        
        client = XpowerDataClient()
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectUserImage))
        userImage.addGestureRecognizer(tapGesture)
        self.navigationController?.isNavigationBarHidden = false
        
        userNameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
    }
    
    @IBAction func selectSchoolClicked(_ sender: Any) {
        let button = sender as! UIButton
        let actionMenu = UIAlertController(title: APP_NAME, message: SELECT_SCHOOL, preferredStyle: .actionSheet)
        let alertAction1 = UIAlertAction(title: SCHOOL_HAVERFORD, style: .default) { (alert: UIAlertAction!) -> Void in
            button.titleLabel?.text = SCHOOL_HAVERFORD
            self.schoolNameLabel.text = MAIL_HAVERFORD
            self.schoolName = SCHOOL_HAVERFORD
            }
        let alertAction2 = UIAlertAction(title: SCHOOL_AGNES_IRWIN, style: .default) { (alert:UIAlertAction!)->Void in
            button.titleLabel?.text = SCHOOL_AGNES_IRWIN
            self.schoolNameLabel.text = MAIL_AGNES_IRWIN
            self.schoolName =  SCHOOL_AGNES_IRWIN
        }
        actionMenu.addAction(alertAction1)
        actionMenu.addAction(alertAction2)
        
        self.navigationController?.present(actionMenu, animated: true, completion: nil)
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        var signUpParameters:Dictionary<String,Any>?
        if userNameField.text=="" || passwordField.text=="" || emailField.text=="" || confirmPasswordField.text=="" {
            let alert = UIAlertController(title: ACTION_REQUIRED, message:SIGNUP_NO_EMPTY_ALLOWED , preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: ACTION_OK, style: UIAlertAction.Style.destructive, handler: nil))
            OperationQueue.main.addOperation {
                self.present(alert, animated: true, completion:nil)
            }}
            else {
            signUpParameters = [USER_NAME:self.userNameField.text! , PASSWORD:self.passwordField.text! , EMAIL:self.emailField.text! , SCHOOL_NAME:schoolNameLabel.text! as Any , AVATAR :true , AVATAR_IMG_URL:"" , TOUCH_ID_ON:false]
            client?.signUpUser(parameters: signUpParameters!) { (result) in
                
                
                let alert = UIAlertController(title: ACTION_SIGNUP, message:result , preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: ACTION_OK, style: UIAlertAction.Style.destructive, handler: nil))
                DispatchQueue.main.async {
                    self.present(alert, animated: true) {
                         if (result == "success") {
                            self.goToLoginView(withUsername: self.userNameField.text!, password: self.passwordField.text!)
                        }
                    }
                }
            }
            }
        }
        
    func goToLoginView(withUsername username:String, password:String) {
        self.dismiss(animated: true) {
             self.navigationController?.popViewController(animated: true)
                   let loginVC = self.navigationController?.viewControllers[0] as! LoginViewController
                   print(loginVC)
            loginVC.loginWithUsernameAndPassword(username: username, password: password)

        }
       
    }
    @objc func selectUserImage()
    {
        checkPermission {
            DispatchQueue.main.async {
                self.imagePicker.sourceType = .savedPhotosAlbum
                self.imagePicker.delegate = self
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)
            }
           
        }
    }
    func checkPermission(hanler: @escaping () -> Void) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            // Access is already granted by user
            hanler()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized {
                    // Access is granted by user
                    hanler()
                }
            }
        default:
        let alert = Utilities.getAlertControllerwith(title: "Error", message: "Error: no access to photo album.")
        self.present(alert, animated: true)
        }
    }
    func saveImage(userImage:UIImage)  {
        let imageData = userImage.jpegData(compressionQuality: 1.0)
        let defaults = UserDefaults.standard
        defaults.setValue(imageData, forKey: USER_IMG_AVATAR)
        
    }
}
extension SignUpViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate
{
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
         if let possibleImage = info[.editedImage] as? UIImage {
            userImage.image = possibleImage
           } else if let possibleImage = info[.originalImage] as? UIImage {
               userImage.image = possibleImage
           }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
