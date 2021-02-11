//
//  FavoritesViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/14/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class RecentDeedsViewController: UIViewController {
var client:XpowerDataClient?
    @IBOutlet weak var recentdeedsTableView: UITableView!
    var recentDeeds:[RecentDeed] = [RecentDeed]()
    var noDataView:UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        noDataView = Utilities.noDataView(viewController: self, emptyMsg: "No Recent Deeds")
    }
    
    func loadData() {
        client = XpowerDataClient()
                      client?.getRecentDeeds(completionHandler: { (deeds) in
                          self.recentDeeds = deeds
                          self.loadTableView()
                      })
    }
    
    func loadTableView() {
        DispatchQueue.main.async
        {
            self.recentdeedsTableView.delegate = self
            self.recentdeedsTableView.dataSource = self
            self.recentdeedsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DeedsCell")
            self.recentdeedsTableView.rowHeight = 100
            self.recentdeedsTableView.reloadData()
        }
    }
}
extension RecentDeedsViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = self.recentDeeds.count
        if cnt==0 {
            tableView.backgroundView = noDataView
            tableView.separatorStyle = .none
        }
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeedsCell", for: indexPath) 
        cell.textLabel?.text = recentDeeds[indexPath.row].deed
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.numberOfLines = 4
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
    
    
}
