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
        if ConnectionManager.shared.isNetworkAvailable == false {
            showNoConnectionAlert()
        } else {
        _refHandle = ref.child("UserPleads").observe(.childAdded) { (snapshot: DataSnapshot) in
            self.peoplePleads.append(snapshot)
            self.collectionView_people.insertItems(at: [IndexPath(row: self.peoplePleads.count - 1, section: 0)])
            
        }
        }
        
    }
    
    deinit {
//        if let refferance = ref.child("UserPleads") as! Database {
//            refferance.removeObserver(withHandle: _refHandle)
//        }
        //ref.child("UserPleads").removeObserver(withHandle: _refHandle)
        
    }
    
    func showNoConnectionAlert() {
        
        let alertController = UIAlertController(title: nil, message: "No Network Connection Available", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
extension PeoplePleadViewController {
     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return peoplePleads.count
     }
    
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PeoplePleadsCell", for: indexPath) as! PeoplePleadCollectionViewCell
        
        let pleadsSnapshot: DataSnapshot! = peoplePleads[indexPath.row]
        
        let pleads = pleadsSnapshot.value as! [String:Any]
        let name = pleads["userName"] as! String
        let ringType = pleads[FirebaseConstants.PleadFields.pleadType] as! String
//        let commentAfter = pleads[FirebaseConstants.PleadFields.userCommentAfter] as! String
//        let commentBefore = pleads[FirebaseConstants.PleadFields.userCommentBefore] as! String
        let feelAfter = pleads[FirebaseConstants.PleadFields.userFeelAfter] as! Int
        let feelBefore = pleads[FirebaseConstants.PleadFields.userFeelBefore] as! Int
        let userType = pleads[FirebaseConstants.PleadFields.userType] as! String

        cell.lbl_PeopleName.text = name
        cell.lbl_PeoplePleadType.text = ringType
        cell.lbl_PeopleFeelBefore.text = SingletonClass.shared.feelingEmojiFunc(feelBefore)
        cell.lbl_PeopleFeelAfter.text = SingletonClass.shared.feelingEmojiFunc(feelAfter)
        cell.lbl_userType.text = userType
     
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
     
}
