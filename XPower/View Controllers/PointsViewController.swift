//
//  PointsViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/12/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit

class PointsViewController: UIViewController {
    var client:XpowerDataClient?
    var pointsData:[Points]?
    let searchController = UISearchController(searchResultsController: nil)
    var filteredDeeds: [Points] = []
    var favTaskList:TasksList?
    var noDataView:UIView = UIView()
    var loadingView:UIView = UIView()
    @IBOutlet weak var pointsTableView: UITableView!
    var selectedSegment: Int = 0
    @IBOutlet weak var deedsSegmentButton: UISegmentedControl!
    @IBOutlet weak var pointsTableHeaderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Points"
        noDataView = Utilities.noDataView(viewController: self, emptyMsg: "Could not load deeds")
        loadData()
    }
    func loadData()  {
        loadingView = Utilities.setLoadingBackgroundFor(viewController: self)
        client = XpowerDataClient()
          client?.getDeedsAndPoints(completionHandler: { pointsDat in
              self.pointsData = pointsDat
              self.client?.getFavouriteDeeds(completionHandler: { (taskList) in
                  self.favTaskList = taskList
                  self.loadTableview()
              })
          })
        
    }
    func loadTableview() {
        DispatchQueue.main.async
        {
            self.loadingView.removeFromSuperview()
            self.pointsTableView.delegate = self
            self.pointsTableView.dataSource = self
            self.pointsTableView.register(UINib(nibName: "PointsTableViewCell", bundle: .main), forCellReuseIdentifier: "PointsTableViewCell")
            self.pointsTableView.rowHeight = 100
            
            self.searchController.searchResultsUpdater = self
            self.searchController.obscuresBackgroundDuringPresentation = false
            self.searchController.searchBar.placeholder = SEARCH_DEEDS_PLACEHOLDER
            self.searchController.searchBar.sizeToFit()
            self.navigationController?.navigationItem.searchController = self.searchController
            self.definesPresentationContext = true
            self.pointsTableHeaderView.addSubview(self.searchController.searchBar)
            self.pointsTableView.tableHeaderView = self.pointsTableHeaderView
            self.pointsTableView.contentOffset = CGPoint(x: 0, y: self.pointsTableHeaderView.frame.height)
            
        }
    }
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    func filterContentForSearchText(_ searchText: String) {
        filteredDeeds = pointsData!.filter { (points: Points) -> Bool in
          return points.Description.lowercased().contains(searchText.lowercased())
        }
        pointsTableView.reloadData()
    }
    
}
extension PointsViewController:UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int = pointsData!.count
        
        if isFiltering {
            count = filteredDeeds.count
        }
        if count == 0
        {
            tableView.backgroundView = noDataView
            tableView.separatorStyle = .none
        }
       return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointsTableViewCell", for: indexPath) as! PointsTableViewCell
        cell.backgroundColor = .clear
        let favtask = self.favTaskList?.tasksList?.filter({$0.Task == self.pointsData?[indexPath.row].Description}).first
        let boolFav = favtask != nil
        let object: Points
         if isFiltering {
           object = filteredDeeds[indexPath.row]
         } else {
            object = (pointsData?[indexPath.row])!
        }
        
        cell.setCellData(points: object, isFavorite:boolFav )
        
        cell.viewController = self
        return cell
    }
    
    
}
