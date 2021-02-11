//
//  HomeCollectionViewCell.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/22/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var treeImage: UIImageView!
    var monthName:String = ""
    
    let treeDic:Dictionary<Int,String> = [1:"Tree1", 2:"Tree2", 3:"Tree3", 4:"Tree4" , 5:"Tree5"]
    override func awakeFromNib() {
        super.awakeFromNib()        
    }
    func setCellData(monthPoint:Month, maxPoint:Int) {
        let pointIn = (Double(monthPoint.progress) / Double(maxPoint))
        let score = pointIn * 100
        progressLabel.text = String(format: "%@ - %d%%", monthPoint.name, Int(score))

        switch score {
        case 0...20:
            treeImage.image = UIImage.init(named: treeDic[1]!)
        case 20...40:
            treeImage.image = UIImage.init(named: treeDic[2]!)
        case 40...60:
            treeImage.image = UIImage.init(named: treeDic[3]!)
        case 60...80:
            treeImage.image = UIImage.init(named: treeDic[4]!)
        default:
            treeImage.image = UIImage.init(named: treeDic[5]!)

        }
        
    }
}
