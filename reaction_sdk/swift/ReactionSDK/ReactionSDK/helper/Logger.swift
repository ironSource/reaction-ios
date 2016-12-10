//
//  Logger.swift
//  Reaction
//
//  Created by g8y3e on 9/20/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation

class Logger {
    static let DEBUG_TAG = "DEBUG"
    static let sharedInstance_ = Logger()
    
    static func sharedLogger() -> Logger {
        return sharedInstance_
    }
    
    func debug(tag: String, message: String) {
        print("\(Logger.DEBUG_TAG):\(tag): \(message)")
    }
}
