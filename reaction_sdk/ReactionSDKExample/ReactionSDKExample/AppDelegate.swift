//
//  AppDelegate.swift
//  ReactionSDKExample
//
//  Created by Valentine.Pavchuk on 9/21/16.
//  Copyright © 2016 ReAction. All rights reserved.
//

import UIKit
import Reaction

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GCMReceiverDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ReactionApp.applicationDidFinishLaunching(application,
                                                    launchOptions: launchOptions)
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        ReactionApp.registerGCMService(with: application,
                                                        deviceToken:deviceToken)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        ReactionApp.applicationDidBecomeActive(application)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        ReactionApp.applicationDidEnterBackground(application)
    }
 
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        ReactionApp.receiveRemoteNotification(with: application,
                                                               userInfo:userInfo);
    }
    /*
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                  fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        ReactionApp.receiveRemoteNotification(with: application,
                        userInfo:userInfo, fetchCompletionHandler:completionHandler)
         completionHandler(.newData)
    }
    
    func application(_ application: UIApplication,
                     didReceive notification: UILocalNotification) {
        ReactionApp.receiveLocalNotification(with: application,
                                                              notification:notification);
    } */
    
    // deep link isrtest://test_page
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        if (url.host == "test_page") {
            let alert = UIAlertController(title: "Deep Link", message: "Hi,test_page", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.window?.rootViewController!.present(alert, animated: true, completion: nil)
            
            return true
        } else {
            return false
        }
    }
}

