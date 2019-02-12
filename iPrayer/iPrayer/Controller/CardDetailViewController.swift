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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isUserCard {
            print(prayRequests.commendAfter)
        } else {
        let pleads = peoplePleads.value as! [String:Any]
        let name = pleads["userName"] as! String
        print(name)
        }
    }
}
