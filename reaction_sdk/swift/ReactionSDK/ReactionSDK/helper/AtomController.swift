//
//  AtomController.swift
//  Reaction
//
//  Created by g8y3e on 9/6/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation
import AtomSDK

class AtomController {
    static let TAG = "AtomController"
    
    let END_POINT = "https://track.atom-data.io/"
    let AUTH_KEY = "p2gw4V3hVwgYCzGFmcy2EGTV6DdKtj"
    
    let STREAM_USERS = "ironlabs.gcm.users"
    let STREAM_CLICK = "ironlabs.gcm.clicks"
    let STREAM_EVENTS = "ironlabs.gcm.events"
    let STREAM_ERRORS = "ironlabs.gcm.errors";
    let STREAM_INTERNAL_ERRORS = "ironlabs.gcm.errors_internal";
    let STREAM_IMPRESSIONS = "ironlabs.gcm.impressions"
    let STREAM_LOGS = "ironlabs.gcm.logs";
    let STREAM_AD_ID = "ironlabs.gcm.adid";
    
    var atomTracker_: IronSourceAtomTracker?
    
    static let sharedInstance_ = AtomController()
    
    static func sharedController() -> AtomController {
        return sharedInstance_
    }
    
    init() {
        self.atomTracker_ = IronSourceAtomTracker()
        
        self.atomTracker_?.enableDebug(true)
        self.atomTracker_?.setAuth(AUTH_KEY)
        self.atomTracker_?.setEndpoint(END_POINT)
        
        self.atomTracker_?.setBulkSize(1) // 4
        self.atomTracker_?.setFlushInterval(2) // 10
        
        Logger.sharedLogger().debug(AtomController.TAG, message: "Tracker created!")
    }
    
    func sendEvent(streamName: String, data: Dictionary<String, NSObject>,
                   isForceReport: Bool = false) {
        let registrationToken = getSharedPreference(Config.TOKEN_KEY)
        let sessionID = ""
        let deviceID = getSharedPreference(Config.DEVICE_ID_KEY)
        let applicationKey = getSharedPreference(Config.APP_KEY)
        
        Logger.sharedLogger().debug(AtomController.TAG, message: "Send event: \(registrationToken); \(deviceID); \(applicationKey)")
        
        if (registrationToken != nil) && (registrationToken != "") &&
            (applicationKey != nil) && (applicationKey != "") ||
            isForceReport {
            
            var sendData = data
            sendData["session_id"] = sessionID
            sendData["reg_id"] = registrationToken
            sendData["ios_id"] = deviceID
            sendData["app_key"] = applicationKey
            sendData["package"] = NSBundle.mainBundle().bundleIdentifier
            sendData["app_version"] = getCurrentAppVersion()
            sendData["sdk_version"] = Config.SDK_VERSION
            sendData["datetime"] = getGMTOffset()
            
            Logger.sharedLogger().debug(AtomController.TAG, message: "Add event: \(sendData)")
            
            self.atomTracker_!.track(streamName, data: objectToJsonStr(sendData))
        }
    }
    
    func sendLog(message: String) {
        var eventObject = Dictionary<String, NSObject>()
        eventObject["message"] = message
        
        self.sendEvent(STREAM_LOGS, data: eventObject)
    }
    
    func sendUser(isNewUser: Bool) {
        var eventObject = Dictionary<String, NSObject>()
        eventObject["new_user"] = isNewUser
        
        self.sendEvent(STREAM_USERS, data: eventObject)
    }
    
    func sendClick(compaignID: String) {
        var eventObject = Dictionary<String, NSObject>()
        eventObject["campaign_id"] = compaignID
        
        self.sendEvent(STREAM_CLICK, data: eventObject)
    }
    
    func sendImpressions(compaignID: String) {
        var eventObject = Dictionary<String, NSObject>()
        eventObject["campaign_id"] = compaignID
        
        self.sendEvent(STREAM_IMPRESSIONS, data: eventObject)
    }
    
    func sendError(name: String, message: String, stackTrace: String,
                   code: Double, isInternal: Bool = false) {
        var eventObject = Dictionary<String, NSObject>()
        eventObject["error_name"] = name
        eventObject["error_message"] = message
        eventObject["error_stack_trace"] = stackTrace
        eventObject["error_code"] = code
        
        if isInternal {
            self.sendEvent(STREAM_INTERNAL_ERRORS, data: eventObject,
                           isForceReport: true)
        } else {
            self.sendEvent(STREAM_ERRORS, data: eventObject,
                           isForceReport: true)
        }
    }
    
    func sendAdvertisingID(adID: String) {
        var eventObject = Dictionary<String, NSObject>()
        eventObject["ad_id"] = adID
        
        self.sendEvent(STREAM_AD_ID, data: eventObject)
    }
    
    
    func sendReport(name: String, value: NSObject, keyName: String) {
        
        var eventObject = Dictionary<String, NSObject>()
        eventObject["event_name"] = name
        eventObject[keyName] = value

        self.sendEvent(STREAM_EVENTS, data: eventObject)
    }
    
    func sendReportString(name: String, value: String) {
        self.sendReport(name, value: value, keyName: "string_value")
    }
    
    func sendReportNumber(name: String, value: Float) {
        self.sendReport(name, value: value, keyName: "float_value")
    }
    
    func sendReportBoolean(name: String, value: Bool) {
        self.sendReport(name, value: value, keyName: "bool_value")
    }
    
    func sendReportPurchase(purchase: Float) {
        self.sendReport("Purchase", value: purchase, keyName: "float_value")
    }
    
    func sendReportRevenue(revenue: Float) {
        self.sendReport("Revenue", value: revenue, keyName: "float_value")
    }

}
