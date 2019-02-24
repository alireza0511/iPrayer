//
//  AddRequestViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 1/23/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import UIKit
import CoreData
//5.1
import Firebase

class AddPrayViewController: UIViewController {
   
    
    // MARK: Properties
    var keyboardOnScreen = false
    var dataController = SingletonClass.shared.state
    var ref: DatabaseReference!
    var userPleads: [DataSnapshot]! = []
    var storageRef: StorageReference!
    var user: User?
    var displayName = "Anonymous"
    var childAutoId: String?
    fileprivate var _refHandle: DatabaseHandle!
    var selectedPleadType : String = "Ertebat Vizhe"
    var pickerPlead: [String] = [String]()
    
    // MARK: Outlets
    @IBOutlet weak var txf_prayType: UITextField!
    @IBOutlet weak var lbl_pleadTypeDesc: UILabel!
    @IBOutlet weak var sBar_beforeFeel: UISlider!
    @IBOutlet weak var lbl_beforeFeel: UILabel!
    @IBOutlet weak var txf_comment: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        subscribeToKeyboardNotifications()
        
        pickerPlead = SingletonClass.shared.halgheType
        creatPickerView()
        dissmissPickerView()
        configureAuth()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromAllNotifications()
    }
 
    
    func configureAuth() {
        // check sign in
        signedInStatus(isSigned: true)
    }
    
    func signedInStatus(isSigned: Bool){
        if (isSigned){
            
             configureDatabase()
             /*
             configureStorage()
             */
        } else {
            // go to login page
        }
    }
    
    func configureDatabase() {
        ref = Database.database().reference()
        _refHandle = ref.child("UserPleads").observe(.childAdded) { (snapshot: DataSnapshot) in
            self.userPleads.append(snapshot)
           
        }
    }
    
    deinit {
        ref.child("UserPleads").removeObserver(withHandle: _refHandle)
        
    }
    
    
    @IBAction func slidbarActionFunc(_ sender: UISlider) {
        
        lbl_beforeFeel.text = SingletonClass.shared.feelingEmojiFunc(Int(sender.value))
    }
    
    fileprivate func savePrayData() {
        let userPlead = PrayRequest(context: dataController.viewContext)
        userPlead.prayType = selectedPleadType
        userPlead.creationDate = Date()
        userPlead.feelingBefore = Int16(Int(sBar_beforeFeel.value))
        userPlead.commendBefore = txf_comment.text
        userPlead.dbKey = childAutoId
        
        try? dataController.viewContext.save()
    }
    
    func addUserPlead(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myDate = formatter.string(from: Date())
        // convert your string to date
        _ = formatter.date(from: myDate)
        
        let userType = "\(UserDefaults.standard.value(forKey: "userType1") as? String ?? "Unspecific") \(UserDefaults.standard.value(forKey: "userType2") as? String ?? "user")"
        
        let data = [FirebaseConstants.PleadFields.pleadType: selectedPleadType ,FirebaseConstants.PleadFields.pleadCreationDate: myDate as String, FirebaseConstants.PleadFields.userCommentBefore: txf_comment.text as String, FirebaseConstants.PleadFields.userFeelBefore: Int(sBar_beforeFeel.value) as Int,FirebaseConstants.PleadFields.userType: userType as String] as [String : Any]

        sendPleadToDatabase(data: data)
            savePrayData()
       
    }
    
    func sendPleadToDatabase(data: [String: Any]) {
        var mData = data
        mData["userName"] = UserDefaults.standard.value(forKey: "userName")
        
        //ref.child("UserPleads").childByAutoId().setValue(mData)
        
        let reference  = ref.child("UserPleads").childByAutoId()
        
        reference.setValue(mData)
        childAutoId = reference.key

    }
    @IBAction func addUserPleadAction(_ sender: Any) {
        presentNewPleadAlert()
        
        
    }
    
    func presentNewPleadAlert(){
        let alert = UIAlertController(title: "New Ertebat", message: "Are you want to publish it?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Send", style: .default) { [weak self] action in
            self!.addUserPlead()
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
        
    }
}

extension AddPrayViewController: UITextViewDelegate{
    
    func configureUI() {
        
        configureTextField(txf_comment)
        configureTextField(txf_prayType)
    }
    
    func configureTextField(_ textField: UITextField) {
     textField.delegate = self
    }
    func configureTextField(_ textField: UITextView) {
        textField.delegate = self
    }
    func subscribeToKeyboardNotifications(){
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(self.keyboardWillShow))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(self.keyboardWillHide))
        subscribeToNotification(UIResponder.keyboardDidShowNotification, selector: #selector(self.keyboardDidShow))
        subscribeToNotification(UIResponder.keyboardDidHideNotification, selector: #selector(self.keyboardDidHide))
    }
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

extension AddPrayViewController: UITextFieldDelegate{

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
            view.frame.origin.y -= keyboardHeight(notification)/10
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)/10
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardOnScreen = true
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        keyboardOnScreen = false
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    private func resignIfFirstResponder(_ textField: UITextView) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject){
        resignIfFirstResponder(txf_comment)
        resignIfFirstResponder(txf_prayType)
        
    }
    
}

extension AddPrayViewController: UIPickerViewDelegate, UIPickerViewDataSource{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerPlead.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerPlead[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPleadType = pickerPlead[row]
        txf_prayType.text = selectedPleadType
        lbl_pleadTypeDesc.text = "Type Descreption: "
        lbl_pleadTypeDesc.text?.append(SingletonClass.shared.halgheDesc(selectedPleadType))
    }
    
    func creatPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        txf_prayType.inputView = pickerView
    }
    
    func dissmissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let donButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dissmissKeyboard))
        toolBar.setItems([donButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txf_prayType.inputAccessoryView = toolBar
    }
    
    @objc func dissmissKeyboard()
    {
        view.endEditing(true)
    }
}
