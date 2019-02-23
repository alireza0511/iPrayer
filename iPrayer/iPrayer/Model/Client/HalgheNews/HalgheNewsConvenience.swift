//
//  HalgheNewsConvenience.swift
//  iPrayer
//
//  Created by Al Khaki on 2/22/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
// MARK: - HalgheNewsClient (Convenient Resource Methods)
extension HalgheNewsClient {
    // MARK: GET Convenience Methods
    
    func getNewsInfo(_ completionHandlerForNewsInfo: @escaping (_ result: [NewsStruct]?, _ error: NSError?, _ success: Bool ) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        var mutableMethod: String
        mutableMethod = Methods.NewsInfo
        
        /* 2. Make the request */
        let _ = taskForGETMethod(mutableMethod, parameters: nil) { (results, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForNewsInfo(nil, error, false)
            } else {
                
                        if let dbResults = results?[HalgheNewsClient.JSONResponseKeys.results] as? [[String:AnyObject]] {
                            let result = NewsStruct.newsFromResults(dbResults)
                            print("results")
                            print(dbResults)
                            completionHandlerForNewsInfo(result,nil,true)
                        }else {
                            completionHandlerForNewsInfo(nil, NSError(domain: "getFavoriteMovies parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getFavoriteMovies"]),false)
                        }
            }
        }
    }
}
