//
//  MessageHandlerFactory.swift
//  Reaction
//
//  Created by g8y3e on 9/16/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation

class MessageHandlerFactory {
    static var currentView_: UIView?
    
    static func createMessageHandler(type: String) -> MessageHandler? {
        switch type {
        case "html":
            return HtmlHandler()
        case "url":
            return UrlHandler()
        case "message":
            return NotificationHandler()
        default:
            return nil
        }
    }
    
    static func setCurrentView(view: UIView) {
        currentView_ = view
    }
    
    static func getCurrentView() -> UIView? {
        return currentView_
    }
}
