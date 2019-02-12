//
//  ViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 1/16/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import CoreData


class SignInViewController: UIViewController {
    
    var ref: DatabaseReference!
    var storegeRef: StorageReference!
    var remoteConfig: RemoteConfig!
    fileprivate var _refHandle: DatabaseHandle!
    fileprivate var _authHandle: AuthStateDidChangeListenerHandle!
    
    @IBOutlet weak var singInBtn: UIButton!
    
    var user: User?
    
    var dataController: DataController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
            configureAuth()

    }

    func configureAuth() {
        let provider: [FUIAuthProvider] = [FUIGoogleAuth()]
        FUIAuth.defaultAuthUI()?.providers = provider
        _authHandle = Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in
            if let activeUser = user {
                if self.user != activeUser {
                    self.user = activeUser
                  
                        //let name1 = user!.email!.components(separatedBy: "@")[0]
                    if let name = UserDefaults.standard.value(forKey: "userName") {
                            print(name)
                    } else {
                        if let name = user!.displayName{
                            UserDefaults.standard.setValue(name, forKey: "userName")
                            }
                        }
                    
                    if let email = UserDefaults.standard.value(forKey: "userEmail"){
                        print(email)
                    } else {
                        if let email = user!.email{
                            UserDefaults.standard.setValue(email, forKey: "userEmail")
                        }
                    }
                    
                    if let phoneNum = UserDefaults.standard.value(forKey: "userPhoneNum") {
                        print(phoneNum)
                    } else {
                        if let phoneNum = user!.phoneNumber{
                            UserDefaults.standard.setValue(phoneNum, forKey: "userPhoneNum")
                        }
                    }
                    
                    if let uid = UserDefaults.standard.value(forKey: "userUid") {
                        print(uid)
                    } else {
                        if let uid = user?.uid {
                            UserDefaults.standard.setValue(uid, forKey: "userUid")
                        }
                    }
                    
                    if let userPhoto = UserDefaults.standard.value(forKey: "userPhoto"){
                        print(userPhoto)
                    } else {
                        if let userPhoto = user!.photoURL?.absoluteString {
                        UserDefaults.standard.setValue(userPhoto, forKeyPath: "userPhoto")
                        }
                    }
                    
//                        let r = user!.providerData
              
                    self.signedInStatus(isSignedIn: true)
                    self.singInBtn.setTitle(" start ", for: UIControl.State.normal)
                }
            } else {
                self.signedInStatus(isSignedIn: false)
                self.loginSession()
            }
        })
    }
    
    func configureDatabase(){
        //1.3
        ref = Database.database().reference()
        /*
         // 1.21-1 for appear messeges that store in database in table view. put listener to trigger an action any time there's a change to the database
         _refHandle = ref.child("messages").observe(.childAdded){ (snapshot: DataSnapshot) in
         self.messages.append(snapshot)
         self.messagesTable.insertRows(at: [IndexPath(row: self.messages.count - 1, section:  0)], with: .automatic)
         self.scrollToBottomMessage()
         
         }
         */
    }
    func signedInStatus(isSignedIn: Bool){
        /*
         signInButton.isHidden = isSignedIn
         signOutButton.isHidden = !isSignedIn
         messagesTable.isHidden = !isSignedIn
         messageTextField.isHidden = !isSignedIn
         sendButton.isHidden = !isSignedIn
         imageMessage.isHidden = !isSignedIn
         */
        
        
        if (isSignedIn){
           
            // 1.2
            //configureDatabase()
            print("go to next page")
//            let controller: TabViewController
//            controller = storyboard?.instantiateViewController(withIdentifier: "TabBarView") as! TabViewController
//
//            present(controller, animated: true, completion: nil)
                performSegue(withIdentifier: "segue_signInToTab", sender: self)
         
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segue_signInToTab" {
//        let controller = segue.destination as! TabViewController
//        //controller.dataController = dataController
//        }
//        if segue.identifier == "segue_signInToUser" {
//            let controller = segue.destination as! UserInfoViewController
//            //        controller.user = user
//        }
        

        
    }

    @IBAction func showLoginPage(_ sender: Any) {
//        loginSession()
//        performSegue(withIdentifier: "segue_signInToTab", sender: self)
        
                  if (UserDefaults.standard.bool(forKey:  "hasLaunchedBefore")){
                      performSegue(withIdentifier: "segue_signInToTab", sender: self)
                                  //self.signedInStatus(isSignedIn: true)
                      print("has lunch before")
                  } else {
                    UserDefaults.standard.setValue(true, forKey: "hasLaunchedBefore")
                    

                      self.performSegue(withIdentifier: "segue_signInToUser", sender: self)
                      print("has not lunch before")
                  }
    }
    

    
    func loginSession() {
        let authViewController = FUIAuth.defaultAuthUI()!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }

}
//        let emojiRanges = [
//            0x1F601...0x1F64F
//        ]
//
//        for range in emojiRanges {
//            for i in range {
//                let c = String(UnicodeScalar(i)!)
//                print(c)
//            }
//        }
