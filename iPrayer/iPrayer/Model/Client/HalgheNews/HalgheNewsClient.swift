//
//  HalgheNewsClient.swift
//  iPrayer
//
//  Created by Al Khaki on 2/22/19.
//  Copyright © 2019 iPrayer. All rights reserved.
//

import Foundation
// MARK: - HalgheNewsClient: NSObject
class HalgheNewsClient: NSObject {
    // MARK: Properties
    // shared session
    var session = URLSession.shared
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    // MARK: GET with
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject]?, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        if ConnectionManager.shared.isNetworkAvailable == false {
            completionHandlerForGET(nil, "No connection available")
           
        }
        /* 1. Set the parameters */
        let urlString = "http://node.jazzb.com:8000/api/ring_news"
        let url = URL(string: urlString)
      
        /* 2/3. Build the URL, Configure the request */
//        let request = NSMutableURLRequest(url: jazzbURLFromParameters(parameters, withPathExtension: method))
        let request = NSMutableURLRequest(url: url!)
        

        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                
                completionHandlerForGET(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    func taskForGETImage(_ filePath: String, completionHandlerForImage: @escaping (_ imageData: Data?, _ error: String?) -> Void) -> URLSessionTask {
        
        if ConnectionManager.shared.isNetworkAvailable == false {
            completionHandlerForImage(nil, "No connection available")
            
        }
        /* 1. Set the parameters */
        // There are none...
        
        /* 2/3. Build the URL and configure the request */
        //let baseURL = URL(string: config.baseImageURLString)!
        //        let url = baseURL.appendingPathComponent(size).appendingPathComponent(filePath)
        let url = URL(string: filePath)!
        let request = URLRequest(url: url)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request) { (data, response, error) in
            
            func sendError(_ error: String) {
                
                completionHandlerForImage(nil, error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            completionHandlerForImage(data, nil)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: String?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            completionHandlerForConvertData(nil, "Could not parse the data as JSON: '\(data)'")
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    // create a URL from parameters
    private func jazzbURLFromParameters(_ parameters: [String:AnyObject]?, withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = HalgheNewsClient.Constants.ApiScheme
        components.host = HalgheNewsClient.Constants.ApiHost
        components.path = HalgheNewsClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        if let parameters = parameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
    
    
    
    // MARK: Shared Instance
    class func sharedInstance() -> HalgheNewsClient {
        struct Singleton {
            static var sharedInstance = HalgheNewsClient()
        }
        return Singleton.sharedInstance
    }
}
