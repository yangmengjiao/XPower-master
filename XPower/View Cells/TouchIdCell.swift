//
//  TouchIdCell.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/20/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class TouchIdCell: UITableViewCell {
    let client:XpowerDataClient = XpowerDataClient()
    weak var viewController:XpowerViewController?
    
    @IBAction func touchIdToggled(_ sender: Any) {
        let toggleIdSwitch = sender as! UISwitch
        client.toggleTouchId(touchId: toggleIdSwitch.isOn) { (result) in
                self.showAlertWithMessage(message: result)
            }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func showAlertWithMessage(message:String) {
        DispatchQueue.main.async {
            let alert = Utilities.getAlertControllerwith(title: APP_NAME, message: message)
            self.viewController?.present(alert, animated: true, completion: {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_ ) in
                    self.viewController?.dismiss(animated: true, completion: nil)
                }
            })
            }
    }
}
