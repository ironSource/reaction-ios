//
//  Reaction.swift
//  Reaction
//
//  Created by g8y3e on 9/5/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation
import Google.CloudMessaging

// Reaction SDK
public class Reaction: NSObject, GGLInstanceIDDelegate  {
    static let TAG = "Reaction"
    
    var isDebug_ = false
    var isSendedUserData_ = false
    
    var senderID_: String
    var applicationKey_: String
    var deviceID_: String?
    
    var registrationOptions_ = [String: AnyObject]()
    
    var registrationToken_: String?
    
    /**
     SDK Contructor
     
     - parameter isDebug: enable print debug info
     
     */
    public init(senderID: String, applicationKey: String, isDebug: Bool = false) {
        self.senderID_ = senderID
        self.applicationKey_ = applicationKey
        
        setSharedPreference(Config.APP_KEY, value: self.applicationKey_)
        
        super.init()
        
        var configureError:NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        self.initNotificationCallbacks()
        
        // register for notifications
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        self.enableDebug(isDebug)
    }
    
    /**
     Enable print debug information
     
     - parameter isDebug: enable print debug info
     */
    public func enableDebug(isDebug: Bool) {
        self.isDebug_ = isDebug
    }
    
    func initNotificationCallbacks() {
        // register remote notification callbacks
        NSNotificationCenter.defaultCenter().addObserverForName(
            ReactionNotificationType.registerError.rawValue,
            object: nil, queue: nil, usingBlock: { (notification) -> Void in
                
                self.registerError(notification)
        })
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            ReactionNotificationType.registerSuccess.rawValue,
            object: nil, queue: nil, usingBlock: { (notification) -> Void in
                
                self.registerSuccess(notification)
        })
        
        // show notification callback
        NSNotificationCenter.defaultCenter().addObserverForName(
            ReactionNotificationType.receiveMessage.rawValue,
            object: nil, queue: nil, usingBlock: { (notification) -> Void in
                
                self.showReceivedMessage(notification)
        })
    }
    
    /**
     Registration to remote notification error callback
     
     - parameter notification: device token info
     */
    func registerError(notification: NSNotification) {
        let userInfo:Dictionary<String, String!> = notification.userInfo as!
            Dictionary<String, String!>
        let errorString = userInfo["error"]
        
        if errorString != nil {
            Logger.sharedLogger().debug(Reaction.TAG, message: errorString!)
        }
    }
    
    /**
     Registration to remote notification success callback
     
     - parameter notification: device token info
     */
    func registerSuccess(notification: NSNotification) {
        let userInfo:Dictionary<String, NSData!> = notification.userInfo as!
            Dictionary<String, NSData!>
        let deviceToken = userInfo["deviceToken"]! as NSData
        self.deviceID_ = convertDeviceTokenToString(deviceToken)
        setSharedPreference(Config.DEVICE_ID_KEY, value: self.deviceID_!)
        
        Logger.sharedLogger().debug(Reaction.TAG, message: "Device ID: " + self.deviceID_!)
        
        let instanceIDConfig = GGLInstanceIDConfig.defaultConfig()
        instanceIDConfig.delegate = self
        
        // Start the GGLInstanceID shared instance with that config and request a registration
        // token to enable reception of notifications
        GGLInstanceID.sharedInstance().startWithConfig(instanceIDConfig)
        
        registrationOptions_ = [kGGLInstanceIDRegisterAPNSOption: deviceToken,
                                kGGLInstanceIDAPNSServerTypeSandboxOption: true]
        
        
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(self.senderID_,
            scope: kGGLInstanceIDScopeGCM, options: self.registrationOptions_,
            handler: self.registrationHandler)
    }
    /**
     Callback for registration token
     
     - parameter registrationToken: GCM registration token
     - parameter error:             error description
     */
    func registrationHandler(registrationToken: String!, error: NSError!) {
        if (registrationToken != nil) {
            self.registrationToken_ = registrationToken
            Logger.sharedLogger().debug(Reaction.TAG, message: "Registration Token: \(registrationToken)")
            
            let isNewUser = self.isNewUser()
            Logger.sharedLogger().debug(Reaction.TAG, message: "Is new user: \(isNewUser)")
            
            let prevRegistrationToken = getSharedPreference(Config.TOKEN_KEY)
            if (self.registrationToken_ != prevRegistrationToken) {
                setSharedPreference(Config.TOKEN_KEY, value: self.registrationToken_!)
                self.sendAddUser()
            }
        
            if !self.isSendedUserData_ {
                self.isSendedUserData_ = true
                AtomController.sharedController().sendUser(isNewUser)
                AtomController.sharedController().sendAdvertisingID(self.getAdvertisingID())
            }
        } else {
            Logger.sharedLogger().debug(Reaction.TAG, message: "Registration to GCM failed with error: \(error.localizedDescription)")
            
            scheduleTaskTimer(20, callback: {()->() in
                GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(self.senderID_,
                    scope: kGGLInstanceIDScopeGCM, options: self.registrationOptions_,
                    handler: self.registrationHandler)
            })
        }
    }
    
    /**
     Check if current user is new
     
     - returns: is new user
     */
    func isNewUser() -> Bool {
        let firstLaunch = getSharedPreference(Config.FIRST_LAUNCH)
        if (firstLaunch == nil) || (firstLaunch?.characters.count == 0) {
            setSharedPreference(Config.FIRST_LAUNCH, value: "NO")
            return true
        }
        
        return false
    }
    
    /**
     Get current device unique ID
     
     - returns: device unique ID
     */
    func getAdvertisingID() -> String {
        return UIDevice.currentDevice().identifierForVendor!.UUIDString
    }
    
    /**
     show receive notification
     
     - parameter notification: notification information
     */
    func showReceivedMessage(notification: NSNotification) {
        let notificationData: Dictionary<String, NSObject> = notification.userInfo as!
            Dictionary<String, NSObject>
        GCMService.sharedInstance().appDidReceiveMessage(notificationData);
        Logger.sharedLogger().debug(Reaction.TAG, message: "Notification received: \(notificationData)")
        
        let type = getTypeFromNotificationData(notificationData)
        // add queue if background
        if let messageHandler = MessageHandlerFactory.createMessageHandler(type) {
            messageHandler.process(notificationData)
        }
    }
    
    /**
     Send user data to Reaction server
     */
    func sendAddUser() {
        // gather userdata
        var userData = Dictionary<String, NSObject>()
        
        userData["token"] = self.registrationToken_
        userData["app_key"] = self.applicationKey_
        userData["android_id"] = self.deviceID_
        userData["app_version"] = getCurrentAppVersion()
        userData["package"] = NSBundle.mainBundle().bundleIdentifier
        userData["sdk_version"] = Config.SDK_VERSION
        userData["locale"] = NSLocale.preferredLanguages()[0]
        userData["gmt"] = getGMTOffset()
        //userData["debug"] = 1
        
        let userDataJson = objectToJsonStr(userData)
        
        Logger.sharedLogger().debug(Reaction.TAG, message: userDataJson)
        
        var headers = Dictionary<String, String>()
        headers["Content-Type"] = "application/json"
        
        var request = Request(url: Config.ADD_USER_URL, data: userDataJson,
                              headers: headers,
                              isDebug: self.isDebug_)
        
        func httpCallback(response: Response) {
            Logger.sharedLogger().debug(Reaction.TAG, message: "From callback (data): \(response.data)")
            Logger.sharedLogger().debug(Reaction.TAG, message: "From callback (error): \(response.error)")
            Logger.sharedLogger().debug(Reaction.TAG, message: "From callback (status): \(response.status)")
            
            // retry if response from reaction not 200
            if (response.status != 200) {
                if !response.data.lowercaseString.containsString("exist") {
                    
                    scheduleTaskTimer(Config.REQUEST_RETRY_TIMEOUT, callback: {()->() in
                        request.post()
                    })
                }
            }
        }
        
        request.initListener(httpCallback)
        request.post()
    }
    
    /**
     Add current device as demo device on reaction web page
     */
    public func registerDemoDevice() {
        var userData = Dictionary<String, NSObject>()
        
        userData["app_key"] = self.applicationKey_
        userData["android_id"] = self.deviceID_
        userData["package"] = NSBundle.mainBundle().bundleIdentifier
        userData["name"] = UIDevice.currentDevice().name
        
        var headers = Dictionary<String, String>()
        headers["Content-Type"] = "application/json"
        
        let userDataJson = objectToJsonStr(userData)
        
        Logger.sharedLogger().debug(Reaction.TAG, message: userDataJson)
        
        var request = Request(url: Config.ADD_DEMO_USER, data: userDataJson,
                              headers: headers,
                              isDebug: self.isDebug_)
        
        func httpCallback(response: Response) {
            Logger.sharedLogger().debug(Reaction.TAG, message: "From callback (data): \(response.data)")
            Logger.sharedLogger().debug(Reaction.TAG, message: "From callback (error): \(response.error)")
            Logger.sharedLogger().debug(Reaction.TAG, message: "From callback (status): \(response.status)")
        }
        
        request.initListener(httpCallback)
        request.post()
    }
    
    /**
     Refresh registration token
     */
    public func onTokenRefresh() {
        // A rotation of the registration tokens is happening, so the app needs to request a new token.
        Logger.sharedLogger().debug(Reaction.TAG, message: "The GCM registration token needs to be changed.")
        GGLInstanceID.sharedInstance().tokenWithAuthorizedEntity(
            self.senderID_, scope: kGGLInstanceIDScopeGCM,
            options: registrationOptions_, handler: registrationHandler)
    }
    
    /**
     Device description
     
     - returns: device ID
     */
    public func getDeviceID() -> String? {
        return getSharedPreference(Config.DEVICE_ID_KEY)
    }
    
    /**
     Send number report to Atom
     
     - parameter name:  key for number
     - parameter value: data for number
     */
    public func reportNumber(name: String, value: Float) {
        AtomController.sharedController().sendReportNumber(name, value: value)
    }
    
    /**
     Send boolean report to Atom
     
     - parameter name:  key for boolean
     - parameter value: data for boolean
     */
    public func reportBoolean(name: String, value: Bool) {
        AtomController.sharedController().sendReportBoolean(name, value: value)
    }
    
    /**
     Send string report to Atom
     
     - parameter name:  key for string
     - parameter value: data for string
     */
    public func reportString(name: String, value: String) {
        AtomController.sharedController().sendReportString(name, value: value)
    }
    
    /**
     Send purchase report to Atom
     
     - parameter value: data for purchase
     */
    public func reportPurchase(value: Float) {
        AtomController.sharedController().sendReportPurchase(value)
    }
    
    /**
     Send revenue report to Atom
     
     - parameter value: data for revenue
     */
    public func reportRevenue(value: Float) {
        AtomController.sharedController().sendReportRevenue(value)
    }
}
