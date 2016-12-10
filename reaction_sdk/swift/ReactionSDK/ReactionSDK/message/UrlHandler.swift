//
//  UrlHandler.swift
//  Reaction
//
//  Created by g8y3e on 9/16/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation

class UrlHandler: MessageHandler {
    static let TAG = "UrlHandler"
    
    func process(data: Dictionary<String, NSObject>) {
        var urlStr: String?  = data["url"] as? String
        
        if urlStr != nil {
            if !(urlStr!.hasPrefix("http://")) && !(urlStr!.hasPrefix("https://")) {
                urlStr = "http://" + urlStr!
            }
            
            if (validateUrl(urlStr)) {
                if let openLink  = NSURL(string: urlStr!) {
                    openUrlInView(openLink)
                }
            } else {
                Logger.sharedLogger().debug(UrlHandler.TAG, message: "Not valid 'url': \(urlStr)!")
            }
        } else {
            Logger.sharedLogger().debug(UrlHandler.TAG, message: "Not exist 'url' key in notification data!")
        }
    }
}
