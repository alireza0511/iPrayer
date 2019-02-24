//
//  DetailNewsViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 2/23/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import UIKit
class DetailNewsViewController: BaseViewController {
    
    var news: NewsStruct!
    var  link: String?
    
    
    @IBOutlet weak var iv_img: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    
    @IBOutlet weak var lbl_date: UILabel!
    
   
    @IBOutlet weak var lbl_abst: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbl_title.text = news.title
        lbl_date.text = news.date
        lbl_abst.text = news.abstract
        link = news.link
        
        if let img = news.imgUrl {
            let _ = HalgheNewsClient.sharedInstance().taskForGETImage(img) { (imageData, error) in
                if let data = imageData{
                    if let image = UIImage(data: data){
                        performUIUpdatesOnMain {
                            self.iv_img.image = image
                        }
                    }
                }
                 else {
                    self.showConnectionResponseError(errorMessage: error ?? "error")
                }
            }
        }
    }
    @IBAction func actionLink(_ sender: Any) {
        if let link = link {
              openUrl(link)
        }
    }
    
  



    @objc func openUrl(_ validUrlPath: String ) {
    
    if
        let validUrl = URL(string: validUrlPath) {
        
        UIApplication.shared.open(validUrl, options: [:], completionHandler: nil)
    }
}
}
