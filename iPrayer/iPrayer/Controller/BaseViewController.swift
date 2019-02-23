//
//  BaseViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 2/23/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {

    var activitySpinner: ActivitySpinnerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func showSpinner() {
        activitySpinner = Bundle.main.loadNibNamed("ActivitySpinnerView", owner: self, options: nil)?.first as? ActivitySpinnerView
        let size = self.view.frame.size
        activitySpinner?.center = CGPoint(x: size.width/2, y: size.height/2)
        self.view.addSubview(activitySpinner!)
    }
    
    func removeSpinner() {
        self.activitySpinner?.removeFromSuperview()

    }
    
    func showNoConnectionAlert() {
        
        let alertController = UIAlertController(title: nil, message: "No Network Connection Available", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showConnectionResponseError(errorMessage: String) {
        
        let alertController = UIAlertController(title: "Error", message: "something went wrong: " + errorMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
