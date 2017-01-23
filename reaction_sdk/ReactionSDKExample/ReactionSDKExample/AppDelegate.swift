//
//  AppDelegate.swift
//  ReactionSDKExample
//
//  Created by Valentine.Pavchuk on 9/21/16.
//  Copyright © 2016 ReAction. All rights reserved.
//

import UIKit
import ReActionSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GCMReceiverDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [NSObject : AnyObject]?) -> Bool {
        ISReactionApp.applicationDidFinishLaunching(application,
                                                    launchOptions: launchOptions)
        
        return true
    }
    
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        ISReactionApp.registerGCMServiceWithApplication(application,
                                                        deviceToken:deviceToken)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        ISReactionApp.applicationDidBecomeActive(application)
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        ISReactionApp.applicationDidEnterBackground(application)
    }
    
    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        ISReactionApp.receiveRemoteNotificationWithApplication(application,
                                                               userInfo:userInfo);
    }
    
    func application(application: UIApplication,
                     didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                  fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        ISReactionApp.receiveRemoteNotificationWithApplication(application,
                        userInfo:userInfo, fetchCompletionHandler:completionHandler)
    }
    
    func application(application: UIApplication,
                     didReceiveLocalNotification notification: UILocalNotification) {
        ISReactionApp.receiveLocalNotificationWithApplication(application,
                                                              notification:notification);
    }
    
    // deep link isrtest://test_page
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        if (url.host == "test_page") {
            let alert = UIAlertController(title: "Deep Link", message: "Hi,test_page", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
            self.window?.rootViewController!.presentViewController(alert, animated: true, completion: nil)
            
            return true
        } else {
            return false
        }
    }
}

