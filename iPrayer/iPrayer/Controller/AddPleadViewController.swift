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

class AddPleadViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
   
    
    
    var dataController = SingletonClass.shared.state
    // 5.2
    var ref: DatabaseReference!
    var userPleads: [DataSnapshot]! = []
    var storageRef: StorageReference!
    var user: User?
    var displayName = "Anonymous"
    fileprivate var _refHandle: DatabaseHandle!
    
    @IBOutlet weak var txtF_pleadType: UITextField!
    var selectedPleadType : String?
   
    @IBOutlet weak var lbl_pleadTypeDesc: UILabel!
    
    @IBOutlet weak var sBar_beforeFeel: UISlider!
    
    @IBOutlet weak var lbl_beforeFeel: UILabel!
    
    @IBOutlet weak var txtF_commentBefore: UITextView!
    
    @IBOutlet weak var switch_public: UISwitch!
    
    var pickerPlead: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        pickerPlead = ["Fara Darmani", "Ertebat Vije", "+1", "+2", "-2", "-1", "defaei 1", "defaei 2", "defaei 3", "defaei 4", "defaei 5"]
        
        creatPickerView()
        dissmissPickerView()
        configureAuth()
        
    }
    
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
        txtF_pleadType.text = selectedPleadType
        lbl_pleadTypeDesc.text = "Type Descreption: "
        lbl_pleadTypeDesc.text?.append(selectedPleadType!)
    }
    
    func creatPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        txtF_pleadType.inputView = pickerView
    }
    
    func dissmissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let donButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.dissmissKeyboard))
        toolBar.setItems([donButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        txtF_pleadType.inputAccessoryView = toolBar
    }
    
    @objc func dissmissKeyboard()
    {
        view.endEditing(true)
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
        
        lbl_beforeFeel.text = feelingEmojiFunc(Int(sender.value))
    }
    
    func addUserPlead(){
        let userPlead = PrayRequest(context: dataController.viewContext)
        userPlead.prayType = 12
        userPlead.creationDate = Date()
        userPlead.publicPlead = switch_public.isOn
        userPlead.feelingBefore = Int16(Int(sBar_beforeFeel.value))
        userPlead.commendBefore = txtF_commentBefore.text
        userPlead.feelingAfter = 4
        userPlead.commendAfter = "good*"
        
        
        try? dataController.viewContext.save()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myDate = formatter.string(from: Date())
        // convert your string to date
        let yourDate = formatter.date(from: myDate)
        
        let data = [FirebaseConstants.PleadFields.pleadType: 11 as Int,FirebaseConstants.PleadFields.pleadCreationDate: myDate as String,  FirebaseConstants.PleadFields.isPleadPublic: switch_public.isOn as Bool, FirebaseConstants.PleadFields.userCommentBefore: "bad" as String, FirebaseConstants.PleadFields.userFeelBefore: Int(sBar_beforeFeel.value) as Int, FirebaseConstants.PleadFields.userCommentAfter: "ggod" as String, FirebaseConstants.PleadFields.userFeelAfter: 5 as Int] as [String : Any]
        if (userPlead.publicPlead){
            sendPleadToDatabase(data: data)
            
        }
        
    }
    
    func sendPleadToDatabase(data: [String: Any]) {
        var mData = data
        mData["userName"] = UserDefaults.standard.value(forKey: "userName")
        ref.child("UserPleads").childByAutoId().setValue(mData)
    }
    @IBAction func addUserPleadAction(_ sender: Any) {
        presentNewPleadAlert()
        
        
    }
    
    func presentNewPleadAlert(){
        let alert = UIAlertController(title: "New Plead", message: "Are you want?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            self!.addUserPlead()
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    func feelingEmojiFunc(_ feel: Int) -> String {
        switch feel {
        case -5:
            return String(UnicodeScalar(128545)!)
        case -4:
            return String(UnicodeScalar(128567)!)
        case -3:
            return String(UnicodeScalar(128557)!)
        case -2:
            return String(UnicodeScalar(128560)!)
        case -1:
            return String(UnicodeScalar(128542)!)
        case 0:
            return String(UnicodeScalar(128530)!)
        case 1:
            return String(UnicodeScalar(128528)!)
        case 2:
            return String(UnicodeScalar(128522)!)
        case 3:
            return String(UnicodeScalar(128513)!)
        case 4:
            return String(UnicodeScalar(128514)!)
        case 5:
            return String(UnicodeScalar(128519)!)
        default:
            return String(UnicodeScalar(128591)!)
        }
    }
}
