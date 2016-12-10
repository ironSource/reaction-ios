//
//  HtmlHandler.swift
//  Reaction
//
//  Created by g8y3e on 9/6/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation

class HtmlHandler: MessageHandler {
    static let TAG = "HtmlHandler"
    
    ///
    func process(data: Dictionary<String, NSObject>) {
        let htmlData = data["html"] as? String
        if htmlData == nil {
            Logger.sharedLogger().debug(HtmlHandler.TAG, message: "Not exist 'html' key in notification data!")
            return
        }
        
        let orientationStr = data["orientation"] as? String
        if orientationStr == nil {
            Logger.sharedLogger().debug(HtmlHandler.TAG, message: "Not exist 'orientation' key in notification data!")
            return
        }
        
        let percentageStr = data["percentage"] as? String
        if percentageStr == nil {
            Logger.sharedLogger().debug(HtmlHandler.TAG, message: "Not exist 'percentage' key in notification data!")
            return
        }
        
        let percentage = Int(percentageStr!)
        if percentage == nil {
            Logger.sharedLogger().debug(HtmlHandler.TAG, message: "Incorrect value for 'percentage': \(percentageStr)")
            return
        }
        
        var ratio: Int?
        let ratioStr = data["ratio"] as? String
        if ratioStr == nil {
            ratio = 100
        } else {
            ratio = Int(ratioStr!)
            if ratio == nil {
                ratio = 100
            }
        }
    
        var vertical: Int?
        let verticalStr = data["vertical"] as? String
        if verticalStr == nil {
            vertical = 0
        } else {
            vertical = Int(verticalStr!)
            if vertical == nil {
                vertical = 0
            }
        }
        
        let currentController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController!
    
        var orientation: HtmlViewOrientation?
        if let orientationInt = Int(orientationStr!) {
            orientation = HtmlViewOrientation(rawValue: orientationInt)
        }
        
   

        
        let htmlView = HtmlView(htmlData: htmlData!,
                                percentage: percentage!,
                                ratio: ratio!,
                                vertical: vertical!,
                                orientation: orientation)
        
        if let previousView = MessageHandlerFactory.getCurrentView() {
            previousView.removeFromSuperview()
        }
        MessageHandlerFactory.setCurrentView(htmlView)
        
        htmlView.translatesAutoresizingMaskIntoConstraints = false
        currentController?.view.addSubview(htmlView)
        
        let widthConstraint = NSLayoutConstraint(item: htmlView, attribute: NSLayoutAttribute.Width,
                                                 relatedBy: NSLayoutRelation.Equal,
                                                 toItem: currentController?.view, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: htmlView, attribute: NSLayoutAttribute.Height,
                                                  relatedBy: NSLayoutRelation.Equal,
                                                  toItem: currentController?.view, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)
        
        NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint])
    }
}
