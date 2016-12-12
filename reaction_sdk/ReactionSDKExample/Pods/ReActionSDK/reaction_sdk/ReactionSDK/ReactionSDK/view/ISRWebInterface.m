//
//  ISReactionWebInterface.m
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ISRWebInterface.h"

#import "../helper/ISRUtils.h"

static NSString* CLOSE_EVENT = @"closeView";
static NSString* OPEN_URL_EVENT = @"openURL";

@implementation ISRWebInterface

-(id)init: (ISRHtmlView*)view {
    self = [super init];
    
    if (self) {
        self->view_ = view;
        
        [self initController];
    }
    return self;
}

-(void)initController {
    self->contentController_ = [[WKUserContentController alloc] init];
    
    [self->contentController_ addScriptMessageHandler:self name:CLOSE_EVENT];
    [self->contentController_ addScriptMessageHandler:self name:OPEN_URL_EVENT];
}

-(WKUserContentController*)getContentController {
    return self->contentController_;
}

-(void)userContentController: (WKUserContentController*)userContentController
     didReceiveScriptMessage: (WKScriptMessage*)message {
    if ([[message name] isEqualToString:CLOSE_EVENT]) {
        [self->view_ removeFromSuperview];
    } else if ([[message name] isEqualToString:OPEN_URL_EVENT]) {
        NSURL* openUrl = [NSURL URLWithString:[message name]];
        [ISRUtils openURLInView:openUrl];
    }
}

@end
