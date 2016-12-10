//
//  HtmlView.swift
//  ReactionSDK
//
//  Created by g8y3e on 10/3/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation
import WebKit

enum HtmlViewOrientation: Int {
    case Portrait = 0, Landscape = 1
}

class HtmlView: UIView {
    static let TAG = "HtmlView"
    
    var orientation_: HtmlViewOrientation?
    var htmlData_: String = ""
    var percentage_: Int = 100
    
    init(htmlData: String, percentage: Int,
         ratio: Int, vertical: Int,
         orientation: HtmlViewOrientation?) {
        
        
        if orientation != nil {
            var orientationUI: Int = -1
            switch orientation! {
            case HtmlViewOrientation.Portrait:
                orientationUI = UIInterfaceOrientation.Portrait.rawValue
            case HtmlViewOrientation.Landscape:
                orientationUI = UIInterfaceOrientation.LandscapeRight.rawValue
            }
            
            if orientationUI != -1 {
                UIDevice.currentDevice().setValue(orientationUI, forKey: "orientation")
            }
        }
        
        htmlData_ = htmlData
        orientation_ = orientation
        percentage_ = percentage > 100 ? 100 : percentage
        
        super.init(frame: CGRectZero)
        
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        let webView: WKWebView
        let webInterface = WebInterface(view: self)
        
        let config = WKWebViewConfiguration()
        config.userContentController = webInterface.getContentController()
        
        webView = WKWebView(frame: CGRectZero,
                            configuration: config)
        
        webView.loadHTMLString(htmlData_, baseURL: nil)
        webView.allowsBackForwardNavigationGestures = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        
        self.addSubview(webView)
        
        var widthMult = (CGFloat(percentage_) / 100.0)
        var heightMult = (CGFloat(percentage_) / 100.0)
        
        let ratioFloat = (CGFloat(ratio) / 100.0)
        
        if vertical == 1 {
            widthMult = ratioFloat * widthMult
        } else {
            heightMult = ratioFloat * heightMult
        }
        
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.Width,
                                                 relatedBy: NSLayoutRelation.Equal, toItem: self,
                                                 attribute: NSLayoutAttribute.Width,
                                                 multiplier: widthMult,
                                                 constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.Height,
                                                  relatedBy: NSLayoutRelation.Equal, toItem: self,
                                                  attribute: NSLayoutAttribute.Height,
                                                  multiplier: heightMult, constant: 0)
        
        let xConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.CenterX,
                                             relatedBy: NSLayoutRelation.Equal, toItem: self,
                                             attribute: NSLayoutAttribute.CenterX, multiplier: 1,
                                             constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.CenterY,
                                             relatedBy: NSLayoutRelation.Equal, toItem: self,
                                             attribute: NSLayoutAttribute.CenterY, multiplier: 1,
                                             constant: 0)
        
        NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint, xConstraint, yConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
