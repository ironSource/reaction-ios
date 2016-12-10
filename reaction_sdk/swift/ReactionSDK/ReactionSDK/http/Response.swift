//
//  Response.swift
//  Reaction
//
//  Created by g8y3e on 9/6/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation

/// Response data from server
public class Response {
    /// Description of error
    public var error: String
    /// Response data from server
    public var data: String
    /// Code from server
    public var status: Int
    
    /**
     Response constructor
     
     - parameter error:  Description of error
     - parameter data:   Response data from server
     - parameter status: Code from server
     */
    public init(error: String, data: String, status: Int) {
        self.error = error
        self.data = data
        self.status = status
    }
}
