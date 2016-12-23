//
//  ISReactionWebInterface.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>

#import "ISRHtmlView.h"

@interface ISRWebInterface : NSObject <WKScriptMessageHandler>
{
    ISRHtmlView* view_;
    WKUserContentController* contentController_;
}

-(id)init: (ISRHtmlView*)view;

-(void)initController;

-(WKUserContentController*)getContentController;

@end
