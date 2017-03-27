//
//  NotificationService.swift
//  TestCenter
//
//  Created by Valentine.Pavchuk on 3/27/17.
//  Copyright © 2017 ReAction. All rights reserved.
//

//import ReactionExtension

class NotificationService: ReactionServiceExtension {
/*
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            bestAttemptContent.subtitle = "\(bestAttemptContent.userInfo["subtitle"]) [modified]"
            
            
            if let imageURL = bestAttemptContent.userInfo["image"] as? String {
                // Grab the attachment
                if let fileUrl = URL(string: imageURL) {
                    // Download the attachment
                    URLSession.shared.downloadTask(with: fileUrl) { (location, response, error) in
                        if let location = location {
                            // Move temporary file to remove .tmp extension
                            let tmpDirectory = NSTemporaryDirectory()
                            let tmpFile = "file://".appending(tmpDirectory).appending("g8y3e\(fileUrl.lastPathComponent)")
                            let tmpUrl = URL(string: tmpFile)!
                            try! FileManager.default.moveItem(at: location, to: tmpUrl)
                            
                            // Add the attachment to the notification content
                            if let attachment = try? UNNotificationAttachment(identifier: "", url: tmpUrl) {
                                self.bestAttemptContent?.attachments = [attachment]
                            }
                        }
                        // Serve the notification content
                        self.contentHandler!(self.bestAttemptContent!)
                        }.resume()
                }
            }
            
            //contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
*/
}
