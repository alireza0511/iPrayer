//
//  PeoplePleadViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 1/23/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PeoplePleadViewController: UICollectionViewController {
    
    // 6
    var ref: DatabaseReference!
    var peoplePleads: [DataSnapshot]! = []
    var storageRef: StorageReference!
    var user: User?
    var displayName = "Anonymous"
    fileprivate var _refHandle: DatabaseHandle!
    
    @IBOutlet var collectionView_people: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAuth()
        
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
            self.peoplePleads.append(snapshot)
            self.collectionView_people.insertItems(at: [IndexPath(row: self.peoplePleads.count - 1, section: 0)])
            print("pppppppp" )
            print(self.peoplePleads.count)
        }
    }
    
    deinit {
        ref.child("UserPleads").removeObserver(withHandle: _refHandle)
        
    }
    
    
    
     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return peoplePleads.count
     }
    
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeoplePleadsCell", for: indexPath) as! PeoplePleadCollectionViewCell
        
        let pleadsSnapshot: DataSnapshot! = peoplePleads[indexPath.row]
        
        let pleads = pleadsSnapshot.value as! [String:Any]
        let name = pleads["userName"] as! String
        let ringType = pleads[FirebaseConstants.PleadFields.pleadType] as! String
        let commentAfter = pleads[FirebaseConstants.PleadFields.userCommentAfter] as! String
        let commentBefore = pleads[FirebaseConstants.PleadFields.userCommentBefore] as! String
        let feelAfter = pleads[FirebaseConstants.PleadFields.userFeelAfter] as! Int
        let feelBefore = pleads[FirebaseConstants.PleadFields.userFeelBefore] as! Int
        
        cell.lbl_PeopleName.text = name
        cell.lbl_PeoplePleadType.text = ringType
        cell.lbl_PeopleFeelBefore.text = feelingEmojiFunc(feelBefore)
        cell.lbl_PeopleFeelAfter.text = feelingEmojiFunc(feelAfter)
        
     
//     let userPlead = self.prayRequests[(indexPath as NSIndexPath).row]
//     cell.lbl_test.text = String(userPlead.prayType)
//
//     cell.lbl_numUserInteraction.text = "2"
//     cell.lbl_feelBefore.text = String(userPlead.feelingBefore)
//     cell.lbl_feelAfter.text = String(userPlead.feelingAfter)
     
     
     
     
     
     
     return cell
     }
    
     override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     print("selected item")
        // Grab the DetailVC from Storyboard
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "CardDetailView") as! CardDetailViewController
        
        
        //Populate view controller with data from the selected item
        vc.peoplePleads = peoplePleads[(indexPath as NSIndexPath).row]
        vc.isUserCard = false
        
        // Present the view controller using navigation
        navigationController!.pushViewController(vc, animated: true)
     }
    
    func halgheType(_ type: Int) -> String {
        let halgheType = [10: "Ertebat Vije",11: "Faradarmani", 41: "+1", 42: "+2",
                          44: "-1", 44: "-2",91: "defaei 1",92: "defaei 2",93: "defaei 3",94: "defaei 4",95: "defaei 5",]
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
