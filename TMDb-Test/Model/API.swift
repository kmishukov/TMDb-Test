//
//  API.swift
//  TMDb-Test
//
//  Created by Konstantin Mishukov on 25/11/2018.
//  Copyright © 2018 Konstantin Mishukov. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct apiReturn {
    public var error: NSError?
    public var data: Data?
    public var json: JSON?
}

// Main application program interface class
class API {
    static let api_key = "10a3eb9a4936774dd45e7db6ccd6b6b4"
    
//    static var genres: [Genre]?
    

    
    static func networkRequest(url: String, parameter: String, completion: @escaping (apiReturn)-> ()) -> () {
        var recieved = apiReturn()
        HTTPRequest.request(url, parameter: parameter, key: "10a3eb9a4936774dd45e7db6ccd6b6b4") { (data, response, error) in
            if let data = data, let json = try? JSON(data:data) {
                recieved.json = json
                recieved.data = data
            }
            recieved.error = error as NSError?
            completion(recieved)
        }
    }
}

class HTTPRequest{
    class func request(_ url: String, parameter: String,  key: String, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()) -> (){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let apiKeyString = "api_key=" + key
        let urlString = url + "?" + apiKeyString + parameter
        let requestURL = URL(string: urlString)!
        let request = NSMutableURLRequest(url: requestURL)
        print("Attemping to access: \(urlString)")
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            DispatchQueue.main.async(execute: { () -> Void in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    completionHandler(nil, nil, error as Error?)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }else{
                    completionHandler(data, response, nil)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            })
        })
        task.resume()
    }
}
