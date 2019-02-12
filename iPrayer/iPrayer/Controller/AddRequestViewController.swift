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

class AddPleadViewController: UIViewController {
    
    var dataController: DataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func addUserPlead(){
        let userPlead = PrayRequest(context: dataController.viewContext)
        userPlead.prayType = 11
        userPlead.creationdate = Date()
        try? dataController.viewContext.save()
        
    }
    @IBAction func addUserPleadAction(_ sender: Any) {
        addUserPlead()
    }
}
