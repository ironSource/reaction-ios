//
//  NotificationHandler.swift
//  Reaction
//
//  Created by g8y3e on 9/16/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation

class NotificationHandler: MessageHandler {
    static let TAG = "NotificationHandler"
    
    func process(data: Dictionary<String, NSObject>) {
        let message = data["body"] as? String
        if message == nil {
            Logger.sharedLogger().debug(NotificationHandler.TAG, message: "Not exist 'body' key in notification data!")
            return
        }
        
        let title = data["title"] as? String
        if title == nil {
            Logger.sharedLogger().debug(NotificationHandler.TAG, message: "Not exist 'title' key in notification data!")
            return
        }
        
        let cancelTitle = "Dismiss"
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: cancelTitle,
                                          style: .Destructive, handler: nil)
        
        alert.addAction(dismissAction)
        UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(
            alert, animated: true, completion: nil)
    }
}
