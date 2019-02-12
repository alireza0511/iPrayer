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
    
    @IBOutlet weak var txtF_userType: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmUserInfo(_ sender: UIButton){
        getUserInfoFunc()
        performSegue(withIdentifier: "segue_userToTab", sender: self)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_userToTab" {
            let controller = segue.destination as! TabViewController
            //        controller.user = user
        }
    }
    
       fileprivate func getUserInfoFunc() {
        UserDefaults.standard.setValue(txtF_userType.text, forKey: "userType")
    
        }
}
