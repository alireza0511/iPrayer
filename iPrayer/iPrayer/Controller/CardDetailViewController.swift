//
//  CardDetailViewController.swift
//  iPrayer
//
//  Created by Al Khaki on 1/31/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class CardDetailViewController: UIViewController{
    
    var prayRequests: PrayRequest!
    var peoplePleads: DataSnapshot!
    var isUserCard: Bool!

    @IBOutlet weak var lbl_prayType: UILabel!
    @IBOutlet weak var lbl_userName: UILabel!
    @IBOutlet weak var lbl_feeling: UILabel!
    @IBOutlet weak var lbl_comment: UILabel!
    
    @IBOutlet weak var txf_message: UITextField!
    @IBOutlet weak var btn_send: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isUserCard {
            lbl_comment.text = prayRequests.commendBefore
            lbl_feeling.text = feelingEmojiFunc(Int(prayRequests.feelingBefore))
            lbl_prayType.text = prayRequests.prayType
            
        } else {
        let pleads = peoplePleads.value as! [String:Any]
        let name = pleads["userName"] as! String
            let ringType = pleads[FirebaseConstants.PleadFields.pleadType] as! String
            //let commentAfter = pleads[FirebaseConstants.PleadFields.userCommentAfter] as! String
            let commentBefore = pleads[FirebaseConstants.PleadFields.userCommentBefore] as! String
            //let feelAfter = pleads[FirebaseConstants.PleadFields.userFeelAfter] as! Int
            let feelBefore = pleads[FirebaseConstants.PleadFields.userFeelBefore] as! Int
            
            lbl_userName.text = "'\(name)' feeling:"
            lbl_comment.text = commentBefore
            lbl_feeling.text = feelingEmojiFunc(feelBefore)
            lbl_prayType.text = ringType
        }
    }
    
    
    @IBAction func btnSendAction(_ sender: Any) {
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
