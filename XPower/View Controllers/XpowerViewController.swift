//
//  XpowerViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/18/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class XpowerViewController: UIViewController {
    var viewControllerDelegate: HomeViewControllerDelegate?
    var backgroundImage:String = ""
    {
        didSet
        {
            let bgImage = UIImageView(frame: self.view.bounds)
            bgImage.image = UIImage(named: self.backgroundImage)
            bgImage.contentMode = UIView.ContentMode.scaleAspectFill
            bgImage.alpha = 0.5
            self.view.insertSubview(bgImage, at: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.init(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(menuButtonClicked(_:)))
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.black
    }
    
   @objc func menuButtonClicked(_ sender: Any) {
        viewControllerDelegate?.toggleLeftPanel()
    }
}
