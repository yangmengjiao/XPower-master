//
//  PointsViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/11/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class PointsTabBarController : UITabBarController {
var viewControllerDelegate: HomeViewControllerDelegate?
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        viewControllerDelegate?.toggleLeftPanel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImageView(frame: self.view.bounds)
        bgImage.image = UIImage(named: "IMG_1390.jpg")
        bgImage.contentMode = UIView.ContentMode.scaleAspectFill
        bgImage.alpha = 0.5
        self.view.insertSubview(bgImage, at: 0)
    }
    

}
extension PointsTabBarController:UITabBarControllerDelegate
{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 1:
            let pointsVC:PointsViewController = self.viewControllers?[0] as! PointsViewController
            pointsVC.loadData()
        case 2:
            let favVC:FavouritesViewController = self.viewControllers?[1] as! FavouritesViewController
            favVC.loadData()
            
        case 3:
       let recentDeeds:RecentDeedsViewController = self.viewControllers?[2] as! RecentDeedsViewController
                  recentDeeds.loadData()
        
        default:
            return
        }
    }
}
