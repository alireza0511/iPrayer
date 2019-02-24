//
//  NEWSViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 2/23/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import UIKit
class NEWSViewController: BaseViewController  {
    
    var newsInfo: [NewsStruct] = [NewsStruct]()

    
    @IBOutlet weak var news_TableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTable()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getNewsFunc()
        news_TableView.rowHeight = 220
        
       
    }
    
    private func getNewsFunc(){
        if ConnectionManager.shared.isNetworkAvailable == true {
            self.showSpinner()
        }
        
        HalgheNewsClient.sharedInstance().getNewsInfo { (newsResults, error, success) in
            
            if success {
                
                if let newsResults = newsResults {
                    self.newsInfo = newsResults
                    performUIUpdatesOnMain {
                        self.removeSpinner()
                        self.news_TableView.reloadData()
                    }
                }
            } else {
                self.showConnectionResponseError(errorMessage: error ?? "error")
            }
        }
        
    }
    
   
}


extension NEWSViewController: UITableViewDelegate, UITableViewDataSource{
    
    func configureTable() {
        
        // This view controller itself will provide the delegate methods and row data for the table view.
        news_TableView.delegate = self
        news_TableView.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /* Get cell type */
        let cellReuseIdentifier = "newsCell"
        let news = newsInfo[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! NEWSTableViewCell
        
        /* Set cell defaults */
        cell.lbl_title.text = news.title
        cell.lbl_subTitle.text = news.abstract
        cell.iv_news.image = UIImage(named: "ic_news")
        if let img = news.imgUrl {
          print(img)
            let _ = HalgheNewsClient.sharedInstance().taskForGETImage(img) { (imageData, error) in
                if let image = UIImage(data: imageData!){
                    performUIUpdatesOnMain {
                        //                                    cell?.imageView!.image = image
                        cell.iv_news.image = image
                    }
                } else {
                    print(error ?? "empty error")
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
                let controller = storyboard!.instantiateViewController(withIdentifier: "storyId_detailNews") as! DetailNewsViewController
                controller.news = newsInfo[(indexPath as NSIndexPath).row]

                navigationController!.pushViewController(controller, animated: true)
    }
    
}
