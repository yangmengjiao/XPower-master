//
//  ChatViewController.swift
//  XPower
//
//  Created by Sangeetha Gengaram on 3/21/20.
//  Copyright © 2020 Sangeetha Gengaram. All rights reserved.
//

import UIKit



class ChatViewController: UIViewController {
    struct Constant {
        struct Cell {
            static let reuseIdentifier = "ChatCell"
            static let nibName = "ChatCell"
            static let rowHeight: CGFloat = 50.0
            
        }
        static let newFriendRequst = "New Friend Request"
    }

    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var chatView: UIView!
    var conversationList:Conversation?
    let client:XpowerDataClient = XpowerDataClient()
    var receiverName:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.backgroundColor = UIColor.clear
        loadData()
        messageTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(loadData), userInfo: nil, repeats: true)

    }
   
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight:CGFloat = keyboardSize.height
            let safeAreaBottom = view.safeAreaLayoutGuide.layoutFrame.maxY
             let viewHeight = view.bounds.height
             let safeAreaOffset = viewHeight - safeAreaBottom
             
             let lastVisibleCell = chatTableView.indexPathsForVisibleRows?.last
            UIView.animate(
              withDuration: 0.3,
              delay: 0,
              options: [.curveEaseInOut],
              animations: {
                self.chatViewBottom.constant = -keyboardHeight + safeAreaOffset
                self.view.layoutIfNeeded()
                if let lastVisibleCell = lastVisibleCell {
                  self.chatTableView.scrollToRow(
                    at: lastVisibleCell,
                    at: .bottom,
                    animated: false)
                }
            })
           
        }
        
    }
    @objc func keyboardWillHide(notification: NSNotification)
    {
        UIView.animate(
             withDuration: 0.3,
             delay: 0,
             options: [.curveEaseInOut],
             animations: {
               self.chatViewBottom.constant = 0
               self.view.layoutIfNeeded()
           })
    }
   @objc func loadData() {
        client.getMessagesFrom(receiverName: receiverName ?? "") { (conversation) in
            self.conversationList = conversation
            self.loadTableView()
        }
    }
    func loadTableView() {
        DispatchQueue.main.async
        {
            self.chatTableView.delegate = self
            self.chatTableView.dataSource = self
            self.chatTableView.register(UINib(nibName: Constant.Cell.nibName, bundle: .main), forCellReuseIdentifier: Constant.Cell.reuseIdentifier)
            self.chatTableView.rowHeight = Constant.Cell.rowHeight

            self.chatTableView.reloadData()
            self.view.layoutIfNeeded()
        }
    }
   
   
   
    @IBAction func sendButtonClicked(_ sender: Any) {
        messageTextField.resignFirstResponder()
        if messageTextField.text != "" {
            client.sendMessage(receiverName: receiverName ?? "", message: messageTextField.text!) { (result) in
                DispatchQueue.main.async {
                   self.sendNewMessageNotification(msg: self.messageTextField.text!)
                    let alert = Utilities.getAlertControllerwith(title: APP_NAME, message: result)
                    self.present(alert, animated: true, completion: {
                            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_ ) in
                            self.dismiss(animated: true, completion: nil)
                                self.messageTextField.text = ""
                                self.loadData()
                                self.loadTableView()
                                self.chatTableView.layoutIfNeeded()
                        }})
                }
            }
        }
    }
    func sendNewMessageNotification(msg:String) {
        let sender = PushNotificationSender()
        let title = "\(Constant.newFriendRequst) \(String(describing: Utilities.currentUserName))"
        sender.sendPushNotification(to: receiverName!, title: title, body: msg)
    }
    deinit {
      let notificationCenter = NotificationCenter.default
      notificationCenter.removeObserver(
        self,
        name: UIResponder.keyboardWillShowNotification,
        object: nil)
      notificationCenter.removeObserver(
        self,
        name: UIResponder.keyboardWillHideNotification,
        object: nil)
    }
}
extension ChatViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        conversationList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msgObj:Message = (conversationList?.messages?[indexPath.row])!
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.Cell.reuseIdentifier, for: indexPath) as! ChatCell
        cell.setMessage(message: msgObj)
        cell.contentView.backgroundColor = UIColor.clear
        return cell
    }
    //PRAGMA text field delegate methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.resignFirstResponder()
    }
}
