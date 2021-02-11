//
//  SideMenuViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/8/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit
import Photos

struct Menu {
    let menuName:menu
    let controllerName:String
    
}

class SideMenuViewController: UIViewController {
    @IBOutlet weak var sideMenuTableView: UITableView!
    var delegate: SidePanelViewControllerDelegate?
    
    var menuItems:[Menu] = [Menu(menuName: .home, controllerName:"HomeViewController" ), Menu(menuName: .points, controllerName: "PointsTabBarController"),Menu(menuName: .score, controllerName: "ScoreViewController"),Menu(menuName:.friends , controllerName: "FriendListViewController"),Menu(menuName: .settings, controllerName: "SettingsViewcontroller"),Menu(menuName: .logout, controllerName: "LoginViewController")]

    @IBOutlet weak var userAvatar: UIImageView!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.image = UIImage(named: "SideMenuBG.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        backgroundImage.alpha = 0.5
        sideMenuTableView.backgroundView = backgroundImage
        sideMenuTableView.backgroundColor = UIColor.clear
        sideMenuTableView.dataSource = self
        sideMenuTableView.delegate = self
        sideMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SideMenuCell")
        sideMenuTableView.rowHeight = 55.0
        
        getUserImageIfAvailable()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        gesture.numberOfTapsRequired = 1
        userAvatar.isUserInteractionEnabled = true
        userAvatar.addGestureRecognizer(gesture)
        
        userName.text = Utilities.currentUserName()

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
    @objc func imageTapped() {
        checkPermission {
            DispatchQueue.main.async {
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.modalPresentationStyle = UIModalPresentationStyle.currentContext
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        }
    }
    
  func saveImage(userImage:UIImage)  {
         let imageData = userImage.jpegData(compressionQuality: 1.0)
         let defaults = UserDefaults.standard
         defaults.setValue(imageData, forKey: USER_IMG_AVATAR)
         
     }
    func getUserImageIfAvailable() {
        let defaults = UserDefaults.standard
        if (defaults.data(forKey: USER_IMG_AVATAR) != nil) {
            let userImg:UIImage = UIImage(data: defaults.data(forKey: USER_IMG_AVATAR)!)!
            userAvatar.image = userImg
        }
        
    }
}
extension SideMenuViewController:UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        
        cell.textLabel?.text = menuItems[indexPath.row].menuName.rawValue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        delegate?.didSelectMenu(VC: menuItems[indexPath.row])
       
    }
   @objc  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         if let possibleImage = info[.editedImage] as? UIImage {
            userAvatar.image = possibleImage
           } else if let possibleImage = info[.originalImage] as? UIImage {
               userAvatar.image = possibleImage
           } else {
               return
           }
        self.saveImage(userImage: self.userAvatar.image!)
           dismiss(animated: true)
    }
    
}
protocol SidePanelViewControllerDelegate {
    func didSelectMenu(VC:Menu)
}

