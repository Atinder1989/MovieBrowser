//
//  RequestManager.swift
//  WebserviceManager
//
//  Created by Atinderpal Singh on 25/07/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

let WEBSERVICE_TIMEOUT_INTERVAL = 30


class RequestManager: NSObject {
    
    static let sharedInstance = RequestManager()
    
    func createRequest(parameter: WebserviceParameter) -> URLRequest {
        var request: URLRequest!
        switch parameter.httpMethod {
        case .GET:
            request = create_GET_Request(parameter: parameter)
              break
        case .POST:
            request = create_POST_Request(parameter: parameter)
            break
        }
        return request
    }

    //MARK:- GET Request Method
  private func create_GET_Request(parameter: WebserviceParameter) -> URLRequest
    {
        let url = urlForGETRequest(parameter: parameter)
        var request = URLRequest(url: URL(string: url)!, cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: TimeInterval(WEBSERVICE_TIMEOUT_INTERVAL))
        request.httpMethod = parameter.httpMethod.rawValue
        for (key,value) in parameter.headers
        {
            request.addValue(value as! String, forHTTPHeaderField: key)
        }
        return request
    }
    
    private func urlForGETRequest(parameter: WebserviceParameter) -> String
    {
        let url = parameter.url
        var array_params = [String]()
        for (key,value) in parameter.body
        {
            array_params.append("\(key)=\(value)")
        }
        var paramString = ""
        if array_params.count > 0
        {
            let base_url = url! + "?"
            paramString = base_url + array_params.joined(separator: "&")
        }
        else
        {
            paramString = url!
        }
        var escapedString = paramString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        escapedString = escapedString?.trimmingCharacters(in: .whitespaces)
        return escapedString!
    }
    
    
    //MARK:- POST Request Method
   private func create_POST_Request(parameter: WebserviceParameter) -> URLRequest
    {
        var request = URLRequest(url: URL(string: parameter.url)!, cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: TimeInterval(WEBSERVICE_TIMEOUT_INTERVAL))
        
        request.httpMethod = parameter.httpMethod.rawValue
        
        var array_params = [String]()
        for (key,value) in parameter.body
        {
            array_params.append("\(key)=\(value)")
        }
        var paramString = ""
        paramString = paramString + array_params.joined(separator: "&")
        request.httpBody = paramString.data(using: .utf8)
        
        
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameter.body, options: .prettyPrinted)
//        } catch let error {
//            print(error.localizedDescription)
//        }
        
        
        for (key,value) in parameter.headers
        {
            request.addValue(value as! String, forHTTPHeaderField: key)
        }
        return request
    }

}
