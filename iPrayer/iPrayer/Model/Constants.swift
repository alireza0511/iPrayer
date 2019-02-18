//
//  Constants.swift
//  iPrayer
//
//  Created by Al Khaki on 2/8/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Halghe {
        let id: Int
        let name : String
        let desc : String?
        let isPublic : Bool
        
        
    }
    
    struct vizhe {
        static let id = 10
        static let name = "Special Contact"
        static let desc = "public medition, every body can use it."
        static let isPublic = true
    }
    
    struct faraDarmani {
        static let id = 11
        static let name = "Byound the cure"
        static let desc = "this medition help you to better health condition."
        static let isPublic = true
    }
    
    func halgheType(_ type: Int) -> String {
        let halgheType = [10: "Ertebat Vije",11: "Faradarmani", 41: "+1", 42: "+2",
                          44: "-1", 44: "-2",91: "defaei 1",92: "defaei 2",93: "defaei 3",94: "defaei 4",95: "defaei 5"]
        return halgheType[type]!
    }
    
    
    
//    var halgheType = [Int:String]()
    //: Dictionary literal
//    var halgheType = [11: faraDarmani.name, 12: "flock", 13: "pride"]
//
//    var volumeMilliliters: Double
//
//    // These are US ounces
//    var volumeOunces: Double {
//        return 0.033814
//    }


}
