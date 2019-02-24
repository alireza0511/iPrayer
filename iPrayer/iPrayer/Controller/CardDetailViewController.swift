//
//  CardDetailViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 1/31/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class CardDetailViewController: UIViewController{
    
    var prayRequests: PrayRequest!
    var peoplePleads: DataSnapshot!
    var isUserCard: Bool!
    var ref: DatabaseReference!
    var keyboardOnScreen = false
    fileprivate var _refHandle: DatabaseHandle!
    var user: User?
    var messages: [DataSnapshot]! = []
    var msglength: NSNumber = 140
    var displayName: String = "Alireza"
    var commentChildKey: String!
    
    @IBOutlet weak var lbl_prayType: UILabel!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_feeling: UILabel!
    @IBOutlet weak var lbl_comment: UILabel!
    
    @IBOutlet weak var tv_message: UITextView!
    @IBOutlet weak var btn_send: UIButton!
    @IBOutlet weak var table_comments: UITableView!
    
    @IBOutlet var dismissKeyboardRecognizer: UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        if isUserCard {
            lbl_comment.text = prayRequests.commendBefore
            lbl_feeling.text = SingletonClass.shared.feelingEmojiFunc(Int(prayRequests.feelingBefore))
            lbl_prayType.text = prayRequests.prayType
            commentChildKey = prayRequests.dbKey
            configureAuth()
        } else {
            let pleads = peoplePleads.value as! [String:Any]
            commentChildKey = peoplePleads.key
            let name = pleads["userName"] as! String
            let ringType = pleads[FirebaseConstants.PleadFields.pleadType] as! String
            let commentBefore = pleads[FirebaseConstants.PleadFields.userCommentBefore] as! String
            let feelBefore = pleads[FirebaseConstants.PleadFields.userFeelBefore] as! Int
            
            lbl_userName.text = "'\(name)' feeling:"
            lbl_comment.text = commentBefore
            lbl_feeling.text = SingletonClass.shared.feelingEmojiFunc(feelBefore)
            lbl_prayType.text = ringType
            
            configureAuth()
        }
        displayName = UserDefaults.standard.value(forKey: "userName") as! String
        
        configureTextField(tv_message)
        subscribeToKeyboardNotifications()
    }
    
    func configureAuth() {
        self.messages.removeAll(keepingCapacity: false)
        
        self.signedInStatus(isSignedIn: true)
        
    }
    
    func configureDatabase() {
        // TODO: configure database to sync messages
        ref = Database.database().reference()
        _refHandle = ref.child("UserPleads").child(commentChildKey).child("comments").observe(.childAdded){ (snapshot: DataSnapshot) in
            self.messages.append(snapshot)
            self.table_comments.beginUpdates()
            self.table_comments.insertRows(at: [IndexPath(row: self.messages.count - 1,section: 0)], with: .automatic)
            self.table_comments.endUpdates()
            self.scrollToBottomMessage()
            
        }
    }
    
    // MARK: Sign In and Out
    
    func signedInStatus(isSignedIn: Bool) {
        
        if (isSignedIn) {
            table_comments.rowHeight = UITableView.automaticDimension
            table_comments.estimatedRowHeight = 122.0
            
            // 1.17-2 confidure the database
            configureDatabase()
        }
    }
    
    // MARK: Send Message
    
    func sendMessage(data: [String:String]) {
        // TODO: create method that pushes message to the firebase database
        // 1.18-1 push message to the database.
        var mdata = data
        mdata[FirebaseConstants.MessageFields.name] = displayName
        ref.child("UserPleads").child(commentChildKey).child("comments").childByAutoId().setValue(mdata)
    }
    
    // MARK: Scroll Messages
    
    func scrollToBottomMessage() {
        if messages.count == 0 { return }
        let bottomMessageIndex = IndexPath(row: table_comments.numberOfRows(inSection: 0) - 1, section: 0)
        table_comments.scrollToRow(at: bottomMessageIndex, at: .bottom, animated: true)
    }
    
    
    @IBAction func btnSendAction(_ sender: Any) {
        let _ = textFieldShouldReturn(tv_message)
        tv_message.text = ""
    }
}

extension CardDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("message count")
        print(self.messages.count)
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = table_comments.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        // unpack message from firebase data snapshot
        let messageSnapshot: DataSnapshot! = messages[indexPath.row]
        let message = messageSnapshot.value as! [String:String]
        let name = message[FirebaseConstants.MessageFields.name] ?? "[username]"
        let text = message[FirebaseConstants.MessageFields.text] ?? "[message]"
        cell!.textLabel?.text = name + ": " + text
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    // 2.8-1
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

private extension CardDetailViewController {
    func subscribeToNotification(_ name: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    
    func unsubscribeFromAllNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
}

extension CardDetailViewController: UITextViewDelegate {
    
    //    func configureTextField(_ textField: UITextField) {
    func configureTextField(_ textField: UITextView) {
        
        textField.delegate = self
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // set the maximum length of the message
        guard let text = textField.text else { return true }
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= msglength.intValue
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    func textFieldShouldReturn(_ textField: UITextView) -> Bool {
        
        if !textField.text!.isEmpty {
            let data = [FirebaseConstants.MessageFields.text: textField.text! as String]
            sendMessage(data: data)
            textField.resignFirstResponder()
        }
        return true
    }
    
    private func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Show/Hide Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardOnScreen {
            self.view.frame.origin.y -= self.keyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            self.view.frame.origin.y += self.keyboardHeight(notification)
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
        dismissKeyboardRecognizer.isEnabled = true
        scrollToBottomMessage()
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        dismissKeyboardRecognizer.isEnabled = false
        keyboardOnScreen = false
    }
    
    func resignTextfield() {
        
        if tv_message.isFirstResponder {
            tv_message.resignFirstResponder()
        }
    }
}

extension CardDetailViewController {
    
    func subscribeToKeyboardNotifications(){
        
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(self.keyboardWillShow))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(self.keyboardWillHide))
        subscribeToNotification(UIResponder.keyboardDidShowNotification, selector: #selector(self.keyboardDidShow))
        subscribeToNotification(UIResponder.keyboardDidHideNotification, selector: #selector(self.keyboardDidHide))
    }
    
}
