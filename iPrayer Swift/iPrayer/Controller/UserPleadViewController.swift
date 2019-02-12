//
//  UserPleadViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 1/23/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class UserPleadViewController: UICollectionViewController {
    
    var prayRequests: [PrayRequest] = []
    //var dataController: DataController!
    var dataController = SingletonClass.shared.state
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("user plead")
        print(SingletonClass.shared.state)
        let fetchReguest: NSFetchRequest<PrayRequest> = PrayRequest.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchReguest.sortDescriptors = [sortDescriptor]
        if let result = try?
            dataController.viewContext.fetch(fetchReguest){
            prayRequests = result
            print(prayRequests[0].prayType)
            print(prayRequests[1].prayType)
            print(prayRequests[2].prayType)
            print(prayRequests.count)
            print("*************")
        }
        
    }
    
//    @IBAction func AddPleadAction(_ sender: Any) {
//        performSegue(withIdentifier: "segue_ViewPleadToAdd", sender: self)
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "segue_ViewPleadToAdd" {
//        let vc = segue.destination as! AddPleadViewController
//            vc.dataController = dataController
//        
//        }
//    }
    
    /// Deletes the plead at the specified index path
    func deletePlead(at indexPath: IndexPath) {
        
//        let notebookToDelete = notebook(at: indexPath)
//
//        dataController.viewContext.delete(notebookToDelete)
//
//        try? dataController.viewContext.save()
//        notebooks.remove(at: indexPath.row)
//        tableView.deleteRows(at: [indexPath], with: .fade)
//        if numberOfNotebooks == 0 {
//            setEditing(false, animated: true)
//        }
//        updateEditButtonState()
    }
    
    /*
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     switch editingStyle {
     case .delete: deleteNotebook(at: indexPath)
     default: () // Unsupported
     }
     }
     */
}

extension UserPleadViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.prayRequests.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPleadCollectionViewCell", for: indexPath) as! UserPleadCollectionViewCell
        
        let userPlead = self.prayRequests[(indexPath as NSIndexPath).row]
        cell.lbl_UserPleadType.text = String(userPlead.prayType)
//        cell.lbl_UserInteractionnum.text = "2"
//        cell.lbl_UserFeelBefore.text = String(userPlead.feelingBefore)
//        cell.lbl_UserFeelAfter.text = String(userPlead.feelingAfter)
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected item")
    }
}
