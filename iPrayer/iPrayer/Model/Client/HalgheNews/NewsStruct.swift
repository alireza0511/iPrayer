//
//  NewsStruct.swift
//  iPrayer
//
//  Created by Al Khaki on 2/22/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation

// MARK: - CompanyInfo

struct NewsStruct {
    // MARK: Properties
    let id: Int
    let title: String
    let date: String
    let abstract: String
    let link: String?
    let imgUrl: String?
    
    // MARK: Initializers
    // construct a CompanyStruct from a dictionary
    init(dictionary: [String:AnyObject]) {
        id = dictionary[HalgheNewsClient.JSONResponseKeys.NewsID] as! Int
        title = dictionary[HalgheNewsClient.JSONResponseKeys.NewsTitle] as! String
        date = dictionary[HalgheNewsClient.JSONResponseKeys.NewsDate] as! String
        abstract = dictionary[HalgheNewsClient.JSONResponseKeys.NewsAbstract] as! String
        if let linkData = dictionary[HalgheNewsClient.JSONResponseKeys.NewsLink] as? String,
            linkData.isEmpty == false {
            link = linkData
        } else {
            link = "Not Available!"
        }
        if let imgUrlData = dictionary[HalgheNewsClient.JSONResponseKeys.NewsPic] as? String,
            imgUrlData.isEmpty == false {
            imgUrl = imgUrlData
        } else {
            imgUrl = "Not Available!"
        }
    }
    
    static func newsFromResults(_ results: [[String:AnyObject]]) -> [NewsStruct] {
        
        var newsInformation = [NewsStruct]()
        
        // iterate through array of dictionaries, each news is a dictionary
        for result in results {
            newsInformation.append(NewsStruct(dictionary: result))
        }
        
        return newsInformation
    }
    
}
