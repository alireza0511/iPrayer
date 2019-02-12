//
//  SingletonClass.swift
//  iPrayer
//
//  Created by Al Khaki on 1/26/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation

class SingletonClass {
    
    private init(){}
    
    static let shared = SingletonClass()
    
    var state = DataController(modelName: "iPrayer")
    
    
    func logSinglton(){
        print("function in singlton")
    }
}

