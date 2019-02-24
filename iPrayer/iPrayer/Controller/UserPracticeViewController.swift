//
//  UserPracticeViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 2/23/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class UserPracticeViewController: BaseViewController {
  
    var prayRequests: [PrayRequest] = []
    var dataController = SingletonClass.shared.state

    @IBOutlet weak var PracticeTebleView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getPrayFunc()
        PracticeTebleView.rowHeight = 120

    }
    private func getPrayFunc(){
        let fetchReguest: NSFetchRequest<PrayRequest> = PrayRequest.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchReguest.sortDescriptors = [sortDescriptor]
        if let result = try?
            dataController.viewContext.fetch(fetchReguest){
            prayRequests = result
            
        }
    }
    
    private func deletePracticeFunc(at indexPath: IndexPath){
        // 8.6 - let's get a reference to the notebook to delete, using our notebook at indexPath helper function.
        let practiceToDelete = prayRequests[indexPath.row]
        // 8.7 - then we call the context's delete function passing in that notebook
        dataController.viewContext.delete(practiceToDelete)
        // 8.8 - and finally we'll try to save the change to the persistent store, and we're done
        try? dataController.viewContext.save()
        prayRequests.remove(at: indexPath.row)

    }
    
//    @IBAction func addUserPractice(_ sender: Any) {
//    performSegue(withIdentifier: "segue_UserPleadToAddPlead", sender: self)
//}
}

extension UserPracticeViewController: UITableViewDelegate,UITableViewDataSource{
    
    func configureTable() {
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        PracticeTebleView.delegate = self
        PracticeTebleView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayRequests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        /* Get cell type */
                let cellReuseIdentifier = "UserPracticeTable"
                let pray = prayRequests[(indexPath as NSIndexPath).row]
                let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! UserPracticeViewCell
        
               /* Set cell defaults */
                cell.lbl_type.text = pray.prayType
        cell.lbl_feel.text = SingletonClass.shared.feelingEmojiFunc(Int(pray.feelingBefore))
        cell.lbl_comment.text = pray.commendBefore
        return cell
    }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // Grab the DetailVC from Storyboard
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "CardDetailView") as! CardDetailViewController
            
            
            //Populate view controller with data from the selected item
            vc.prayRequests = prayRequests[(indexPath as NSIndexPath).row]
            vc.isUserCard = true
            
            // Present the view controller using navigation
            navigationController!.pushViewController(vc, animated: true)
        }
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == UITableViewCell.EditingStyle.delete {
                deletePracticeFunc(at: indexPath)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            }
    }
}
