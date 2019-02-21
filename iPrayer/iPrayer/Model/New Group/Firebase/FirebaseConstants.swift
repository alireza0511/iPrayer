//
//  Constants.swift
//  iPrayer
//
//  Created by Al Khaki on 1/28/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation

struct FirebaseConstants {
    // PleadFields
    struct PleadFields {
        static let pleadType = "pleadType"
        static let userFeelBefore = "userFeelBefore"
        static let userFeelAfter = "userFeelAfter"
        static let userCommentBefore = "userCommentBefore"
        static let userCommentAfter = "userCommentAfter"
        static let isPleadPublic = "isPleadPublic"
        static let pleadCreationDate = "pleadCreationDate"
    }
    
    struct MessageFields {
        static let name = "name"
        static let text = "text"
        static let imageUrl = "photoUrl"
    }
}
