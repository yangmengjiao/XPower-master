//
//  PointsTableViewCell.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/12/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class PointsTableViewCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    weak var viewController:UIViewController!
    let client:XpowerDataClient = XpowerDataClient()
    
    
    override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

    @IBAction func starButtonClicked(_ sender: Any) {
        if starButton.backgroundImage(for: .normal) == UIImage.init(named: "favorites.png") {
            
            starButton.setBackgroundImage(UIImage.init(named: "NoFavorite.png"), for: .normal)
            client.setFavoutiteTask(taskDescription: descriptionLabel.text!, isFavorite: false) { (result) in
                self.showAlertWithMessage(message: result)
            }
        }
        else
        {
            starButton.setBackgroundImage(UIImage.init(named: "favorites.png"), for: .normal)
            client.setFavoutiteTask(taskDescription: descriptionLabel.text!, isFavorite:true) { (result) in
                self.showAlertWithMessage(message: result)
            }
        }
    }
    @IBAction func addButtonClicked(_ sender: Any) {
        client.addDeed(deed: descriptionLabel.text!) { (result) in
             self.showAlertWithMessage(message: result)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setCellData(points:Points, isFavorite:Bool) {
        descriptionLabel.text = points.Description
        if isFavorite{
           starButton.setBackgroundImage(UIImage.init(named: "favorites.png"), for: .normal)
        } else {
            starButton.setBackgroundImage(UIImage.init(named: "NoFavorite.png"), for: .normal)
        }
    }
    func setFavouriteTask(task:TaskList) {
        descriptionLabel.text = task.Task
        starButton.setBackgroundImage(UIImage.init(named: "favorites.png"), for: .normal)
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
