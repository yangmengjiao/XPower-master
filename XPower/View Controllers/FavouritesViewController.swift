//
//  FavouritesViewController.swift
//  XPower
//
//  Created by Mengjiao Yang on 3/13/20.
//  Copyright © 2020 Mengjiao Yang. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    struct Constant {
        struct Cell {
            static let reuseIdentifier = "PointsTableViewCell"
            static let nibName = "PointsTableViewCell"
            static let rowHeight: CGFloat = 80.0
        }
        static let msg = "No FavouriteDeeds"
    }
    var client:XpowerDataClient?
    @IBOutlet weak var favouriteDeedsTableview: UITableView!
    var favTaskList:TasksList?
    var noDataView:UIView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        noDataView = Utilities.noDataView(viewController: self, emptyMsg: Constant.msg)
    }
    func loadData() {
        client = XpowerDataClient()
        client?.getFavouriteDeeds(completionHandler: { (taskList) in
            self.favTaskList = taskList
            self.loadTableView()
        })
    }
    
    func loadTableView() {
        DispatchQueue.main.async
        {
            self.favouriteDeedsTableview.delegate = self
            self.favouriteDeedsTableview.dataSource = self
            self.favouriteDeedsTableview.register(UINib(nibName: Constant.Cell.nibName, bundle: .main), forCellReuseIdentifier: Constant.Cell.reuseIdentifier)
            self.favouriteDeedsTableview.rowHeight = Constant.Cell.rowHeight
            self.favouriteDeedsTableview.reloadData()
        }
    }
}

extension FavouritesViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cnt = favTaskList?.tasksList?.count ?? 0
        if cnt==0
        {
            tableView.backgroundView = noDataView
            tableView.separatorStyle = .none
        }
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointsTableViewCell", for: indexPath) as! PointsTableViewCell
        
        cell.setFavouriteTask(task: (favTaskList?.tasksList?[indexPath.row])!)
        return cell
    }
    
    
}
