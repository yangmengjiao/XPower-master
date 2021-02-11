//
//  FriendRequestCellTableViewCell.swift
//  XPower
//
//  Created by Mengjiao Yang on 3/18/20.
//  Copyright © 2020 Mengjiao Yang. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {
    let client:XpowerDataClient = XpowerDataClient()
    weak var viewController:FriendListViewController?
    
    @IBOutlet weak var friendName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func acceptButtonClicked(_ sender: Any) {
        client.respondToFriendRequest(receiverName: friendName.text!, status: 2) { (acceptResult) in
            self.showAlertWithMessage(message: acceptResult)
        }
    }
    
    @IBAction func rejectButtonClicked(_ sender: Any) {
        client.respondToFriendRequest(receiverName: friendName.text!, status: 0) { (acceptResult) in
            self.showAlertWithMessage(message: acceptResult)
        }
    }
    func showAlertWithMessage(message:String) {
        DispatchQueue.main.async {
            let alert = Utilities.getAlertControllerwith(title: APP_NAME, message: message)
            self.viewController?.present(alert, animated: true, completion: {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_ ) in
                    self.viewController?.dismiss(animated: true, completion:{
                        self.viewController?.loadFriendRequestList()
                    })
                }
            })
            }
    }
    func setCellData(friendRequest:Request) {
        friendName.text = friendRequest.username
    }
    
}
