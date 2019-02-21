//
//  TestController.swift
//  iPrayer
//
//  Created by Al Khaki on 1/27/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserPleadsViewController: UICollectionViewController {
    
    var prayRequests: [PrayRequest] = []
    
    //var dataController: DataController!
    var dataController = SingletonClass.shared.state
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fetchReguest: NSFetchRequest<PrayRequest> = PrayRequest.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchReguest.sortDescriptors = [sortDescriptor]
        if let result = try?
            dataController.viewContext.fetch(fetchReguest){
            prayRequests = result
            
        }
    }
    
    @IBAction func addUserPlead(_ sender: Any) {
        performSegue(withIdentifier: "segue_UserPleadToAddPlead", sender: self)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.prayRequests.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! TestCell
        
        let userPlead = self.prayRequests[(indexPath as NSIndexPath).row]
        cell.lbl_test.text = userPlead.prayType
    
               //  cell.lbl_numUserInteraction.text = "2"
        cell.lbl_feelBefore.text = feelingEmojiFunc(Int(userPlead.feelingBefore))
                 //cell.lbl_feelAfter.text = feelingEmojiFunc(Int(userPlead.feelingAfter))

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item")
        // Grab the DetailVC from Storyboard
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CardDetailView") as! CardDetailViewController
        
        
        //Populate view controller with data from the selected item
        vc.prayRequests = prayRequests[(indexPath as NSIndexPath).row]
        vc.isUserCard = true
        
        // Present the view controller using navigation
        navigationController!.pushViewController(vc, animated: true)
        
    
        
    }
    func halgheType(_ type: Int) -> String {
        let halgheType = [11: "fara darmani", 12: "flock", 13: "pride"]
        return halgheType[type]!
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
