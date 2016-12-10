//
//  Utils.swift
//  Reaction
//
//  Created by g8y3e on 9/6/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation

/**
 Convert Device Token (NSData) to String
 
 - parameter deviceToken: unique token for device
 
 - returns: converted device token
 */
func convertDeviceTokenToString(deviceToken: NSData) -> String {
    var deviceTokenStr = deviceToken.description.stringByReplacingOccurrencesOfString(">", withString: "", options: [], range: nil)
    
    deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString("<", withString: "", options: [], range: nil)
    deviceTokenStr = deviceTokenStr.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)
    
    deviceTokenStr = deviceTokenStr.uppercaseString
    
    return deviceTokenStr
}

/**
 Convert Object to Json string
 
 - parameter data: object to convert
 
 - returns: Json string
 */
func objectToJsonStr(data: NSObject) -> String {
    var jsonData: NSData
    var jsonStr: String = ""
    
    do {
        jsonData = try NSJSONSerialization.dataWithJSONObject(data, options:  NSJSONWritingOptions(rawValue: 0))
    } catch _ {
        return jsonStr
    }
    
    jsonStr = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
    return jsonStr
}

func jsonStrToDictionary(text: String) -> [String:AnyObject]? {
    if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
        } catch let error as NSError {
            print(error)
        }
    }
    return nil
}

/**
 Current application version
 
 - returns: application version
 */
func getCurrentAppVersion() -> String {
    let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
    
    return nsObject as! String
}

/**
 Get GMT offset
 
 - returns: gmt offset
 */
func getGMTOffset() -> String {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "Z"
    return formatter.stringFromDate(NSDate())
}

/**
 Set Shared Preference for key, value
 
 - parameter key:   name of preference
 - parameter value: data for preference
 */
func setSharedPreference(key: String, value: String) {
    NSUserDefaults.standardUserDefaults().setObject(value,
                                                    forKey: key)
}

/**
 Get Shared Preference by key
 
 - parameter key: name of preference
 
 - returns: preference value
 */
func getSharedPreference(key: String) -> String? {
    return NSUserDefaults.standardUserDefaults().stringForKey(key)
}

/**
 Open URL in new default browser
 
 - parameter url: address for webpage
 */
func openUrlInView(url: NSURL) {
    UIApplication.sharedApplication().openURL(url)
}

/**
 Change view with animation
 
 - parameter destinationController: result view controller
 - parameter duration:              change time
 - parameter animationType:         type for animation
 */
func viewControllerTransition(destinationController: UIViewController,
                              duration: Double = 0.2,
                              animationType: UIViewAnimationOptions = UIViewAnimationOptions.TransitionCrossDissolve) {
    
    let window = UIApplication.sharedApplication().windows[0] as UIWindow
    UIView.transitionFromView(
        window.rootViewController!.view,
        toView: destinationController.view,
        duration: duration,
        options: animationType,
        completion: {
            finished in window.rootViewController = destinationController
    })
}

func deviceOrientationIsLandscape() -> Bool {
    /*let currentDevice: UIDevice = UIDevice.currentDevice()
     let orientation: UIDeviceOrientation = currentDevice.orientation
     
     return orientation.isLandscape*/
    
    return UIScreen.mainScreen().bounds.width > UIScreen.mainScreen().bounds.height
}

func getTypeFromNotificationData(notificationData: Dictionary<String, NSObject> ) -> String {
    var type = notificationData["type"] as? String
    if type == nil {
        type = ""
        if (notificationData["aps"] != nil) {
            type = "notification"
        }
    }
    
    return type!
}

func getUserAgentName() -> String? {
    let webView = UIWebView()
    
    webView.loadHTMLString("<html></html>", baseURL: nil)
    return webView.stringByEvaluatingJavaScriptFromString("navigator.userAgent")
}

func validateUrl(urlStr: String?) -> Bool {
    //Check for nil
    if let urlStr = urlStr {
        // create NSURL instance
        if let url = NSURL(string: urlStr) {
            // check if your application can open the NSURL instance
            return UIApplication.sharedApplication().canOpenURL(url)
        }
    }
    return false
}

func scheduleTaskTimer(time: Int64, callback: ()->()) {
    let seconds: Int64 = time * Int64(NSEC_PER_SEC)
    
    let time = dispatch_time(DISPATCH_TIME_NOW, seconds)
    dispatch_after(time, dispatch_get_main_queue(), {
        callback()
    })
}
