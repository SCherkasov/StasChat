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
    
    @IBOutlet weak var baseViewheightConstraint: NSLayoutConstraint!
    
    var messages = [
        "first",
        "secgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgdgggggggggggggggggggond",
        "third",
        "1",
        "2",
        "3",
        "43525",
        "third",
        "1",
        "2",
        "3",
        "43525",
        "third",
        "1",
        "2",
        "3",
        "last message"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let customMessageCellNib
            = UINib.init(
                nibName: "CustomMessageCell",
                bundle: nil
            )
      
        messageTableView.register(
            customMessageCellNib,
            forCellReuseIdentifier: "CustomMessageCell"
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
        self.messageTableView.scrollToRow(
            at: IndexPath.init(row: self.messages.count - 1, section: 0),
            at: UITableViewScrollPosition.bottom,
            animated: true
        )
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        }
        catch {
            print("erorr to log out")
        }
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    @objc func sendButtonTouched(_ sender: UIGestureRecognizer) {
        self.messages.append(self.messageTextField.text ?? "")
        self.messageTextField.text = nil
        
        self.messageTableView.beginUpdates()
        self.messageTableView.insertRows(
            at: [IndexPath.init(row: self.messages.count - 1, section: 0)],
            with: .fade
        )
        self.messageTableView.endUpdates()
        
        UIView.animate(
            withDuration: 0.3,
            delay: 0.1,
            options: UIViewAnimationOptions.beginFromCurrentState,
            animations: {
                
                self.messageTextField.resignFirstResponder()
                //self.controlPanelHeightConstaint.constant = 0
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
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "CustomMessageCell",
            for: indexPath
        ) as! CustomMessageCell
        
        cell.messageBodyLabel.text = messages[indexPath.row]
        
        return cell
    }
    
    func configurateTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        heightConstraint.constant = 370
//        view.layoutIfNeeded()
        //scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}


