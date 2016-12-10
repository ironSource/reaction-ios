//
//  WebInterface.swift
//  Reaction
//
//  Created by g8y3e on 9/9/16.
//  Copyright © 2016 ReAction IS. All rights reserved.
//

import Foundation
import WebKit

class WebInterface: NSObject, WKScriptMessageHandler {
    let view_: HtmlView
    var contentController_: WKUserContentController?
    
    init(view: HtmlView) {
        view_ = view
        super.init()
        
        self.initController()
    }
    
    func initController() {
        contentController_ = WKUserContentController()
        contentController_!.addScriptMessageHandler(
            self, name: "closeView")
        
        contentController_!.addScriptMessageHandler(
            self, name: "openURL")
    }
    
    func getContentController() -> WKUserContentController {
        return self.contentController_!
    }
    
    func userContentController(userContentController: WKUserContentController,
                               didReceiveScriptMessage message: WKScriptMessage) {
        switch message.name {
        case "closeView":
            self.view_.removeFromSuperview()
            break
        case "openURL":
            let openLink = NSURL(string: message.body as! String)
            openUrlInView(openLink!)
            break
        default:
            break
        }
    }
}
