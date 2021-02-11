//
//  FriendListViewController.swift
//  XPower
//
//  Created by Mengjiao Yang on 3/17/20.
//  Copyright © 2020 Mengjiao Yang. All rights reserved.
//

import UIKit

class FriendListViewController: XpowerViewController {
    struct Constant {
        struct Cell {
            static let reuseIdentifier = "FriendRequestCell"
            static let nibName = "FriendRequestCell"
            static let rowHeight: CGFloat = 80.0
        }
        struct Action {
            static let send = "Send"
            static let cancel = "Cancel"
        }
        static let msg = "No FavouriteDeeds"
        static let title = "Friends"
        static let backgroundImageName = "IMG_0653.jpg"
        static let placeholder = "Enter Username"
        static let sendMsg = "Send Request"
        static let noFriendMsg = "No friend found"
        static let controllerIdentifier = "ChatViewController"
        static let newFriendRequst = "New Friend Request"
    }
    
    let client = XpowerDataClient()
    var friendList:FriendList?
    var friendRequests:FriendRequests?
    var isShowingList:Bool = true
    var loadingView:UIView = UIView()
    var noDataView:UIView = UIView()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var friendListTableView: UITableView!
    @IBAction func listRequestCtrl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0)
        {
            isShowingList = true
            friendListTableView.reloadData()
        }
        else
        {
            isShowingList = false
            friendListTableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constant.title
        backgroundImage = Constant.backgroundImageName
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addRequestClicked(_:)))
        loadingView = Utilities.setLoadingBackgroundFor(viewController: self)
        noDataView = Utilities.noDataView(viewController: self, emptyMsg: Constant.noFriendMsg)
        
        loadFriendList()
        loadFriendRequestList()
    }
    @objc func addRequestClicked(_ sender: Any) {
        let alert = UIAlertController(title: APP_NAME, message: Constant.sendMsg, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = Constant.placeholder
        }
        let cancelAction = UIAlertAction(title: Constant.Action.cancel, style: .cancel, handler: nil)
        let sendAction = UIAlertAction(title: Constant.Action.send, style: .default) { [unowned alert] _ in
            let receiverName = alert.textFields![0]
            DispatchQueue.main.async {
                if receiverName.text != nil
                {
                    self.sendNewRequestNotification(receiverName: receiverName.text!)
                }
            }
            self.client.addFriendRequest(receiverName: receiverName.text ?? "") { (result) in
                self.showAlertWithMessage(message: result)
            }
        }
        
        alert.addAction(sendAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func sendNewRequestNotification(receiverName:String) {
        let sender = PushNotificationSender()
        let title = "\(Constant.newFriendRequst) \(String(describing: Utilities.currentUserName))"
        sender.sendPushNotification(to: receiverName, title: title, body: "")
    }
    
    func showAlertWithMessage(message:String) {
        DispatchQueue.main.async {
            let alert = Utilities.getAlertControllerwith(title: APP_NAME, message: message)
            self.present(alert, animated: true, completion: {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_ ) in
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    func loadFriendList() {
        client.getFriendList(completionHandler: { (friendList) in
            self.friendList = friendList
            self.loadTableView()
        })
        
    }
    func loadFriendRequestList()  {
        client.getFriendRequestList(completionHandler: { (friendReqs) in
            self.friendRequests = friendReqs
            self.loadTableView()
        })
    }
    func loadTableView() {
        DispatchQueue.main.async
        {
            self.loadingView.removeFromSuperview()
            self.friendListTableView.delegate = self
            self.friendListTableView.dataSource = self
            self.friendListTableView.tableHeaderView = self.headerView
            self.friendListTableView.register(UINib(nibName: Constant.Cell.nibName, bundle: .main), forCellReuseIdentifier: Constant.Cell.reuseIdentifier)
            self.friendListTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constant.Cell.reuseIdentifier)
            self.friendListTableView.rowHeight = Constant.Cell.rowHeight
            self.friendListTableView.reloadData()
        }
    }
    
}
extension FriendListViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int = 0
        
        if isShowingList {
            count = self.friendList?.results.count ?? 0
        }
        else
        {
            count = self.friendRequests?.results?.count ?? 0
        }
        if (count==0) {
            tableView.backgroundView = noDataView
            tableView.separatorStyle = .none
        }
        else
        {
            tableView.backgroundView = nil
            noDataView.removeFromSuperview()
            tableView.separatorStyle = .singleLine
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isShowingList {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Cell.reuseIdentifier, for: indexPath)
            cell.textLabel?.text = friendList?.results[indexPath.row].username
            cell.accessoryType = .disclosureIndicator
            cell.isUserInteractionEnabled = true
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Cell.reuseIdentifier, for: indexPath) as! FriendRequestCell
            cell.viewController = self
            cell.setCellData(friendRequest: (friendRequests?.results?[indexPath.row])!)
            cell.selectionStyle = .none
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isShowingList {
            let receiverName = friendList?.results[indexPath.row].username
            let chatVC = self.storyboard?.instantiateViewController(withIdentifier: Constant.controllerIdentifier) as! ChatViewController
            chatVC.receiverName = receiverName
            tableView.deselectRow(at: indexPath, animated: true)
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
        
    }
    
    
}
