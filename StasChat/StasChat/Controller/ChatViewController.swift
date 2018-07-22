//
//  ChatViewController.swift
//  StasChat
//
//  Created by Stanislav Cherkasov on 14.07.2018.
//  Copyright © 2018 Stanislav Cherkasov. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController, UIGestureRecognizerDelegate {
  
  @IBOutlet var messageTextField: UITextField!
  @IBOutlet var sendButton: UIView!
  @IBOutlet var messageTableView: UITableView!
  @IBOutlet weak var controlPanelHeightConstaint: NSLayoutConstraint!
  @IBOutlet weak var sendButtonLabel: UILabel!
  
  var tapGesture: UITapGestureRecognizer?
  
  let viewControll = ViewController()
  
  @IBOutlet weak var baseViewheightConstraint: NSLayoutConstraint!
  
  var messageArray = [Message]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    viewControll.translucentNavBar()
    
    // Hide backBarButtonItem
    let backButton = UIBarButtonItem(title: "", style: .plain,
                                     target: navigationController, action: nil)
    navigationItem.leftBarButtonItem = backButton
    //***********************
    
    let customMessageCellNib
      = UINib.init(
        nibName: "CustomMessageCell",
        bundle: nil
    )
    
    messageTableView.register(
      customMessageCellNib,
      forCellReuseIdentifier: "MessageCell"
    )
    
    configurateTableView()
    
    messageTextField.delegate = self
    
    self.messageTableView.dataSource = self
    
    let tapGesture = UITapGestureRecognizer.init(
      target: self,
      action: #selector(ChatViewController.sendButtonTouched(_:))
    )
    
    self.tapGesture = tapGesture
    tapGesture.delegate = self
    self.sendButton.addGestureRecognizer(tapGesture)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(ChatViewController.keyboardWillShow(_:)),
      name: NSNotification.Name.UIKeyboardWillShow, object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(ChatViewController.keyboardDidShow(_:)),
      name: NSNotification.Name.UIKeyboardDidShow, object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(ChatViewController.keyboardDidHide(_:)),
      name: NSNotification.Name.UIKeyboardDidHide, object: nil
    )
  }
  
  override func viewDidAppear(_ animated: Bool) {
      self.scrollToTheMessagesBottom()
  }
  
  @objc func keyboardWillShow(_ notification: Notification) {
    if let size
      = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect)?.size
    {
      self.baseViewheightConstraint.constant = size.height
    }
  }
  
  @objc func keyboardDidShow(_ notification: Notification) {
      self.scrollToTheMessagesBottom()
  }
  
  @objc func keyboardDidHide(_ notification: Notification) {
      self.scrollToTheMessagesBottom()
  }
  
  func scrollToTheMessagesBottom() {
    if messageArray.count > 0 {
    self.messageTableView.scrollToRow(
      at: IndexPath.init(row: self.messageArray.count - 1, section: 0),
      at: UITableViewScrollPosition.bottom,
      animated: true
    )
    } else {
      messageTableView.reloadData()
    }
  }
  
  @IBAction func logOutPressed(_ sender: Any) {
    do {
      try Auth.auth().signOut()
      navigationController?.popToRootViewController(animated: true)
      print("logout")
    }
    catch {
      print("erorr to log out")
    }
  }
  
  @objc func sendButtonTouched(_ sender: UIGestureRecognizer) {
    //self.messages.append(self.messageTextField.text ?? "")
   
    // Add message to FireBase
    let messageDB = Database.database().reference().child("Messages")
    let messageDictionary = ["Sender": Auth.auth().currentUser?.email,
                             "MessageBody": self.messageTextField.text!]
    
    messageDB.childByAutoId().setValue(messageDictionary) {
      (error, reference) in
      
      if error != nil {
        print(error!)
      } else {
        print("Message save seccesfully")
      }
    
    }
    //*************************
    
    func retrieveMessages() {
      let messageDB = Database.database().reference().child("Messages")
      messageDB.observe(.childAdded, with: { (snapshot) in
        let snapshotValue = snapshot.value as! Dictionary<String, String>
        let text = snapshotValue["MessageBody"]!
        let sender = snapshotValue["Sender"]!
        print(text, sender)
        let message = Message()
        message.messageBody = text
        message.sender = sender
        self.messageArray.append(message)
        self.configurateTableView()
        //self.messageTableView.reloadData()
      })
    }
    
    self.messageTextField.text = nil
    self.messageTableView.beginUpdates()
    
    if messageArray.isEmpty {
      self.messageTableView.insertRows(at: [IndexPath.init(row: self.messageArray.count, section: 0)], with: .fade)
    } else {
      self.messageTableView.insertRows(
      at: [IndexPath.init(row: self.messageArray.count - 1, section: 0)],
      with: .fade
      )
    }
    
//    if messageArray.count >= 1 {
//    self.messageTableView.insertRows(
//      at: [IndexPath.init(row: self.messageArray.count - 1, section: 0)],
//      with: .fade
//    )
//    } else {
//      self.messageTableView.insertRows(at: [IndexPath.init(row: self.messageArray.count, section: 0)], with: .fade)
//    }
    
    self.messageTableView.endUpdates()
    
    UIView.animate(
      withDuration: 0.3,
      delay: 0.1,
      options: UIViewAnimationOptions.beginFromCurrentState,
      animations: {
        
        self.messageTextField.resignFirstResponder()
        self.baseViewheightConstraint.constant = 0
    },
      completion: { completion in
    }
    )
  }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.messageArray.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "MessageCell",
      for: indexPath
      ) as! CustomMessageCell
    
    cell.messageBodyLabel.text = messageArray[indexPath.row].messageBody
    cell.senderUserNameLabel.text = messageArray[indexPath.row].sender
    cell.avatarImageView.image = UIImage(named: "smile")
    
    return cell
  }
  
  func configurateTableView() {
    messageTableView.rowHeight = UITableViewAutomaticDimension
    messageTableView.estimatedRowHeight = 120
  }
}

extension ChatViewController: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
  }
}
