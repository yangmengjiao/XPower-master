//
//  SettingsViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/20/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: XpowerViewController {

    @IBOutlet weak var settingsTableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.backgroundImage = "IMG_1390.jpg"
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.backgroundColor = .clear
        settingsTableView.register(UINib(nibName: "TouchIdCell", bundle: .main), forCellReuseIdentifier: "TouchIdCell")
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        settingsTableView.rowHeight = 60
    }
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["Xpower@consoaring.com"])
            let subjectStr:String = String(format: "Concerns of %@", Utilities.currentUserName())
            mail.setSubject(subjectStr)

            present(mail, animated: true)
        } else {
           let alert = Utilities.getAlertControllerwith(title: APP_NAME, message: MAIL_NOT_ALLOWED, alertActionTitle: ACTION_OK)
            present(alert, animated: true, completion: nil)
        }
    }
}
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            cell.backgroundColor = .clear
            cell.textLabel?.text = SETTINGS_CHANGE_PASSWORD
            return cell
        case 1:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            cell.backgroundColor = .clear
            cell.textLabel?.text = SETTINGS_REPORT
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TouchIdCell", for: indexPath) as! TouchIdCell
            cell.backgroundColor = .clear
            cell.viewController = self
            return cell
        
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let changePwdVC = self.storyboard?.instantiateViewController(withIdentifier: "ChangePwdViewController") as! ChangePwdViewController
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(changePwdVC, animated: true)
        case 1:
            sendEmail()
            tableView.deselectRow(at: indexPath, animated: true)

        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
}
