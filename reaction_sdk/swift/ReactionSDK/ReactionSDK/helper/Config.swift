//
//  Config.swift
//  Config
//
//  Created by g8y3e on 9/6/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation

class Config {
    static let ADD_USER_URL = "https://rct-upopa.com/user/addUser"
    static let ADD_DEMO_USER = "https://rct-upopa.com/user/addDebugDevice"
    
    static let SDK_VERSION = "1.0.0"
    
    static let TOKEN_KEY = "com.reaction.sdk.registration_token"
    static let DEVICE_ID_KEY = "com.reaction.sdk.device_id"
    static let APP_KEY = "com.reaction.sdk.app_key"
    
    static let FIRST_LAUNCH = "com.reaction.sdk.first_launch"
    
    static let REQUEST_RETRY_TIMEOUT: Int64 = 10 * 60
}
