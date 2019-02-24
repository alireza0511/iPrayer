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
        configureAuth()
    }
    
    func configureAuth() {
        let provider: [FUIAuthProvider] = [FUIGoogleAuth()]
        FUIAuth.defaultAuthUI()?.providers = provider
        _authHandle = Auth.auth().addStateDidChangeListener({ (auth: Auth, user: User?) in
            if let activeUser = user {
                if self.user != activeUser {
                    self.user = activeUser
                    
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
        ref = Database.database().reference()
        
    }
    func signedInStatus(isSignedIn: Bool){
        
        if (isSignedIn){
            performSegue(withIdentifier: "segue_signInToTab", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segue_signInToUser" {
            let controller = segue.destination as! UserInfoViewController
            controller.isFirstLunch = true
        }
        
    }
    
    @IBAction func showLoginPage(_ sender: Any) {
        
        
        if (UserDefaults.standard.bool(forKey:  "hasLaunchedBefore")){
            performSegue(withIdentifier: "segue_signInToTab", sender: self)
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

