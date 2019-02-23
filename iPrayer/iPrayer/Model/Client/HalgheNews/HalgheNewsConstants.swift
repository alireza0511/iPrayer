//
//  HalgheNewsConstants.swift
//  iPrayer
//
//  Created by Al Khaki on 2/22/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
// MARK: - HalgheNewsClient (Constants)
extension HalgheNewsClient{
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "http"
        static let ApiHost = "node.jazzb.com:8000"
        static let ApiPath = "/api"

    }
    
    // MARK: Methods
    struct Methods {
       
        // MARK: News Info
        static let NewsInfo = "/ring_news"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "message"
        static let StatusCode = "responseCode"
        static let results = "ringNews"
        
        // MARK: News
        static let NewsID = "id"
        static let NewsTitle = "titer"
        static let NewsDate = "date"
        static let NewsAbstract = "abstract"
        static let NewsLink = "link"
        static let NewsPic = "headerPic"
        
    }
}
