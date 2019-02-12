//
//  PrayRequest+Extra.swift
//  iPrayer
//
//  Created by Al Khaki on 1/21/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
import CoreData
extension PrayRequest {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        creationDate = Date()
    }
}
