//
//  UserInfoViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 1/19/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import UIKit

class UserInfoViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var txf_userBirth: UITextField!
    @IBOutlet weak var txf_Name: UITextField!
    @IBOutlet weak var txf_userGender: UITextField!
    @IBOutlet weak var txf_userType1: UITextField!
    @IBOutlet weak var txf_userType2: UITextField!
    @IBOutlet weak var btn_userData: UIButton!
    
    // MARK: Properties
    var keyboardOnScreen = false
    var genderPickerView: [String] = [String]()
    var userType1PickerView: [String] = [String]()
    var userType2PickerView: [String] = [String]()
    let pickerView1 = UIPickerView()
    let pickerView2 = UIPickerView()
    let pickerView3 = UIPickerView()
    let datePicker = UIDatePicker()
    var isFirstLunch: Bool?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        subscribeToKeyboardNotifications()

        prepareTextField()
        creatPickerView()
        dissmissPickerView()
        genderPickerView = SingletonClass.shared.gender
        userType1PickerView = SingletonClass.shared.userType1
        userType2PickerView = SingletonClass.shared.userType2
        
        if isFirstLunch ?? false{
        btn_userData.setTitle("Confirm", for: .normal)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromAllNotifications()
    }
    
    @IBAction func confirmUserInfo(_ sender: UIButton){
        getUserInfoFunc()
        if isFirstLunch ?? false{
        performSegue(withIdentifier: "segue_userToTab", sender: self)
        }
    }
    
       fileprivate func getUserInfoFunc() {
        UserDefaults.standard.setValue(txf_Name.text, forKey: "userName")
        UserDefaults.standard.setValue(txf_userGender.text, forKey: "userGender")
        UserDefaults.standard.setValue(txf_userBirth.text, forKey: "userBirthDay")
        UserDefaults.standard.setValue(txf_userType1.text, forKey: "userType1")
        UserDefaults.standard.setValue(txf_userType2.text, forKey: "userType2")
    
        // next step post data to database
        }
    
    func prepareTextField() {
        txf_Name.text = UserDefaults.standard.value(forKey: "userName") as? String
        txf_userGender.text = UserDefaults.standard.value(forKey: "userGender") as? String
        txf_userBirth.text = UserDefaults.standard.value(forKey: "userBirthDay") as? String
        txf_userType1.text = UserDefaults.standard.value(forKey: "userType1") as? String
        txf_userType2.text = UserDefaults.standard.value(forKey: "userType2") as? String
    }

    func configureUI() {
        configureTextField(txf_Name)
    }
    func configureTextField(_ textField: UITextField) {
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

extension UserInfoViewController: UITextFieldDelegate{
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
            view.frame.origin.y -= keyboardHeight(notification)/4
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardOnScreen {
            view.frame.origin.y += keyboardHeight(notification)/4
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
    
    @IBAction func userDidTapView(_ sender: AnyObject){
        resignIfFirstResponder(txf_Name)
        resignIfFirstResponder(txf_userGender)
        resignIfFirstResponder(txf_userBirth)
        resignIfFirstResponder(txf_userType1)
        resignIfFirstResponder(txf_userType2)
    }
}

extension UserInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
        case pickerView1: return genderPickerView.count
        case pickerView2: return userType1PickerView.count
        default:
            return userType2PickerView.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case pickerView1: return genderPickerView[row]
        case pickerView2: return userType1PickerView[row]
        default:
            return userType2PickerView[row]
        }
       
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickerView1:
            txf_userGender.text = genderPickerView[row]
        case pickerView2:
            txf_userType1.text = userType1PickerView[row]
        default:
            txf_userType2.text = userType2PickerView[row]
        }
        
    }
    
    func creatPickerView(){
       
        pickerView1.delegate = self
        pickerView2.delegate = self
        pickerView3.delegate = self

        txf_userGender.inputView = pickerView1
        txf_userType1.inputView = pickerView2
        txf_userType2.inputView = pickerView3

        //Formate Date
        datePicker.datePickerMode = .date
        txf_userBirth.inputView = datePicker
    }
    
    func dissmissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let donButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dissmissKeyboard))
        toolBar.setItems([donButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txf_userGender.inputAccessoryView = toolBar
        txf_userType1.inputAccessoryView = toolBar
        txf_userType2.inputAccessoryView = toolBar

        // birthday ToolBar
        let toolbar2 = UIToolbar();
        toolbar2.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        
        toolbar2.setItems([doneButton,spaceButton], animated: false)
        
        txf_userBirth.inputAccessoryView = toolbar2
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txf_userBirth.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func dissmissKeyboard()
    {
        view.endEditing(true)
    }
    
}

