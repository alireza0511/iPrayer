//
//  ConnectionManager.swift
//  iPrayer
//
//  Created by Al Khaki on 2/23/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
class ConnectionManager {
    static let shared = ConnectionManager()
    
    let reachability = Reachability()!
    
    var isNetworkAvailable : Bool {
        return reachability.connection != .none
    }
}
