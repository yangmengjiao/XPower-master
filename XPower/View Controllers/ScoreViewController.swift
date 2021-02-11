//
//  ScoreViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/16/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class ScoreViewController: XpowerViewController {
    @IBOutlet weak var agnesLabel: UILabel!
    @IBOutlet weak var haverfordLabel: UILabel!
    let client:XpowerDataClient = XpowerDataClient()
    var schoolPoints:[Int]?
    var loadingView:UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Score"
        backgroundImage = "IMG_0624.jpg"
        loadingView = Utilities.setLoadingBackgroundFor(viewController: self)
        SetSchoolPoints()
    }
    
    func SetSchoolPoints() {
      
            self.client.getSchoolPoints(schoolName: "Haverford") { (haverfordPts) in
            self.schoolPoints?.append(haverfordPts.totalpoints)
                self.client.getSchoolPoints(schoolName: "Agnes Irwin") { (agnesPts) in
                        self.schoolPoints?.append(agnesPts.totalpoints)
                    DispatchQueue.main.async {
                    self.haverfordLabel.text = String(format: "Haverford : %d",haverfordPts.totalpoints )
                    self.agnesLabel.text = String(format: "Agnes Irwin : %d", agnesPts.totalpoints)
                        self.loadingView.removeFromSuperview()
                       }
                }
        }
    }
}
