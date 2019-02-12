//
//  ViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 1/16/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let emojiRanges = [
            0x1F601...0x1F64F
        ]
        
        for range in emojiRanges {
            for i in range {
                let c = String(UnicodeScalar(i)!)
                print(c)
            }
        }
    }


}

