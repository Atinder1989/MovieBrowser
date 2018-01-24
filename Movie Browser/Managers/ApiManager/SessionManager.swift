//
//  SessionManager.swift
//  WebserviceManager
//
//  Created by Atinderpal Singh on 25/07/17.
//  Copyright © 2017 ABC. All rights reserved.
//

import UIKit

let message_EmptyData = "Empty Data"

enum JSONError: Error {
    case JSONErrorEmptyData(message:String)
}

enum HTTPError: Error {
    case HTTPErrorInvalidResponse
    case HTTPErrorInvalidStatusCode
    case HTTPErrorRequestFailed(statusCode: Int, message: String)
}

enum HTTPStatusCodeMessage: String
{
    case HTTPStatusCodeMessageNotFound          = "Not Found"
    case HTTPStatusCodeMessageJTokenExpire      = "JToken Expire"
    case HTTPStatusCodeMessageUnKnown           = "Unknown"
}

enum HTTPStatusCode: Int
{
    case HTTPStatusCodeSuccess = 200
    case HTTPStatusCodeNotFound = 404
    case HTTPStatusCodeJTokenExpire = 403
    
    var isSuccessful: Bool {
        return (200..<300).contains(rawValue)
    }
}

class SessionManager: NSObject {
static let sharedInstance = SessionManager()

func processRequest(request: URLRequest,completionHandler:@escaping (Data?, Error?)->Void) {
        URLCache.shared.removeAllCachedResponses()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                try self.validate(response)
                guard let data = data else {
                    throw JSONError.JSONErrorEmptyData(message: message_EmptyData)
                }
                completionHandler(data,error)
            }
            catch {
                completionHandler(data,error)
            }
    }
        task.resume()
    }
    
  private func validate(_ response: URLResponse?) throws
    {
        guard let response = response as? HTTPURLResponse else {
            throw HTTPError.HTTPErrorInvalidResponse
        }
        guard let status = HTTPStatusCode(rawValue: response.statusCode) else {
            throw HTTPError.HTTPErrorInvalidStatusCode
        }
        if !status.isSuccessful {
            switch status {
            case .HTTPStatusCodeNotFound:
                 throw HTTPError.HTTPErrorRequestFailed(statusCode: status.rawValue, message: HTTPStatusCodeMessage.HTTPStatusCodeMessageNotFound.rawValue)
            case .HTTPStatusCodeJTokenExpire:
                throw HTTPError.HTTPErrorRequestFailed(statusCode: status.rawValue, message: HTTPStatusCodeMessage.HTTPStatusCodeMessageJTokenExpire.rawValue)
            default:
                throw HTTPError.HTTPErrorRequestFailed(statusCode: -1, message: HTTPStatusCodeMessage.HTTPStatusCodeMessageUnKnown.rawValue)
            }
        }
    }
    
}
