//
//  ReactionApp.swift
//  Reaction
//
//  Created by g8y3e on 9/6/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation
import UIKit
import Google.CloudMessaging

enum ReactionNotificationType : String {
    case registerSuccess = "reactionRegisterSuccess",
    registerError = "reactionRegisterError",
    
    receiveMessage = "reactionReceiveMessage",
    
    applicationActive = "applicationActive",
    applicationNotActive = "applicationNotActive"
}

public class ReactionApp: UIResponder, UIApplicationDelegate, GCMReceiverDelegate {
    static let TAG = "ReactionApp"
    
    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let userInfo = ["deviceToken": deviceToken]
        
        let gcmConfig = GCMConfig.defaultConfig()
        gcmConfig.receiverDelegate = self
        GCMService.sharedInstance().startWithConfig(gcmConfig)
        
        GCMService.sharedInstance().connectWithHandler({
            (error) -> Void in
            if error != nil {
                Logger.sharedLogger().debug(ReactionApp.TAG, message: "Could not connect to GCM: \(error.localizedDescription)")
            } else {
                Logger.sharedLogger().debug(ReactionApp.TAG, message: "Connected to GCM")
            }
        })
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            ReactionNotificationType.registerSuccess.rawValue, object: nil,
            userInfo: userInfo)
    }
    
    public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        let userInfo = ["error": error.description]
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            ReactionNotificationType.registerError.rawValue, object: nil,
            userInfo: userInfo)
    }
    
    public func applicationDidBecomeActive(application: UIApplication) {
        GCMService.sharedInstance().connectWithHandler({
            (error) -> Void in
            if error != nil {
                Logger.sharedLogger().debug(ReactionApp.TAG, message: "Could not connect to GCM: \(error.localizedDescription)")
            } else {
                Logger.sharedLogger().debug(ReactionApp.TAG, message: "Connected to GCM")
            }
        })
        NSNotificationCenter.defaultCenter().postNotificationName(
            ReactionNotificationType.applicationActive.rawValue, object: nil,
            userInfo: nil)
    }
    
    public func applicationDidEnterBackground(application: UIApplication) {
        GCMService.sharedInstance().disconnect()
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            ReactionNotificationType.applicationNotActive.rawValue, object: nil,
            userInfo: nil)
        
    }
    
    public func application( application: UIApplication,
                             didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        Logger.sharedLogger().debug(ReactionApp.TAG, message: "Notification received 1")
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            ReactionNotificationType.receiveMessage.rawValue,
            object: nil,
            userInfo: userInfo)
    }
    
    public func application( application: UIApplication,
                             didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                                                          fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
        Logger.sharedLogger().debug(ReactionApp.TAG, message: "Notification received 2")
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            ReactionNotificationType.receiveMessage.rawValue,
            object: nil,
            userInfo: userInfo)
        
        handler(UIBackgroundFetchResult.NoData)
    }
}
 
