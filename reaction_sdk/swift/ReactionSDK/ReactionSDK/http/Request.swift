//
//  Request.swift
//  Reaction
//
//  Created by g8y3e on 9/6/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation

/// Reaction callback type definition
typealias ReactionCallback = (Response) -> Void

/// For make async HTTP requests to server
class Request {
    static let TAG = "Request"
    
    var url_: String
    var data_: String
    var isDebug_: Bool
    
    var callback_: ReactionCallback?
    var headers_: Dictionary<String, String>
    
    /**
     Constructor for Request
     
     - parameter url:      For server address.
     - parameter data:     For sending data.
     - parameter callback: For get response data.
     - parameter headers:  For sending headers.
     - parameter isDebug:  if set to <c>true</c> is debug.
     */
    init(url: String, data: String, headers: Dictionary<String, String>,
         isDebug: Bool) {
        self.url_ = url
        self.data_ = data
        
        self.isDebug_ = isDebug
        
        self.headers_ = headers
    }
    
    func initListener(callback: ReactionCallback?) {
        self.callback_ = callback
    }
    
    /**
     GET request to server
     */
    func get() {
        let utf8str = self.data_.dataUsingEncoding(NSUTF8StringEncoding)
        let encodedUri = utf8str!.base64EncodedStringWithOptions(
            NSDataBase64EncodingOptions(rawValue: 0))
        
        let urlWithGet = self.url_ + "?data=" + encodedUri
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlWithGet)!)
        request.HTTPMethod = "GET"
        
        self.sendRequest(request)
    }
    
    /**
     POST request to server
     */
    func post() {
        let request = NSMutableURLRequest(URL: NSURL(string: self.url_)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = self.data_.dataUsingEncoding(NSUTF8StringEncoding)
        
        self.sendRequest(request)
    }
    
    /**
     Send and read response from server
     
     - parameter request: Object with request information.
     */
    func sendRequest(request: NSMutableURLRequest) {
        let session = NSURLSession.sharedSession()
        
        for (key, value) in self.headers_ {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if let userAgent = getUserAgentName() {
            Logger.sharedLogger().debug(Request.TAG, message: "User-Agent: \(userAgent)")
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
        }
        
        let task = session.dataTaskWithRequest(request, completionHandler: {data,
            response, error -> Void in
            var status = -1
            var errorStr: String = ""
            var dataStr: String = ""
            
            if(error != nil) {
                errorStr = error!.localizedDescription
            } else {
                dataStr = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
                Logger.sharedLogger().debug(Request.TAG, message: "Body: \(dataStr)")
                
                let responseBody = jsonStrToDictionary(dataStr)
                if responseBody != nil {
                    let statusExists = responseBody!["status"]
                    if statusExists != nil {
                        status = statusExists as! Int
                    }
                    
                    let errorExists = responseBody!["error"]
                    if errorExists != nil {
                        errorStr =  objectToJsonStr(errorExists as! NSObject)
                        dataStr = ""
                    }
                    
                    let dataExists = responseBody!["data"]
                    if dataExists != nil {
                        dataStr = objectToJsonStr(dataExists as! NSObject)
                    }
                } else {
                    status = (response as! NSHTTPURLResponse).statusCode
                }
            }
            Logger.sharedLogger().debug(Request.TAG, message: "Response: \(self.url_) - \(status) - from: \(self.data_)")
            
            self.callback_?(Response(error: errorStr, data: dataStr, status: status))
        })
        
        task.resume()
    }
}
