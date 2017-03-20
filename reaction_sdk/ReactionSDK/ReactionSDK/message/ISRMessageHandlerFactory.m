//
//  ISReactionMessageHandlerFactory.m
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ISRMessageHandlerFactory.h"

#import "ISRHttpHandler.h"
#import "ISRUrlHandler.h"
#import "ISRDeepLinkHandler.h"
#import "ISRNotificationHandler.h"

static UIView* CURRENT_VIEW_;

static NSString* HTML_TYPE = @"html";
static NSString* URL_TYPE = @"url";
static NSString* DEEP_LINK_TYPE = @"deepLink";
static NSString* MESSAGE_TYPE = @"message";

@implementation ISRMessageHandlerFactory

+(id<ISRMessageHandler>)createMessageHandler: (NSString*)type {
    if ([type isEqualToString:HTML_TYPE]) {
        return [[ISRHttpHandler alloc] init];
    } else if ([type isEqualToString:URL_TYPE]) {
        return [[ISRUrlHandler alloc] init];
    } else if ([type isEqualToString:DEEP_LINK_TYPE]) {
        return [[ISRDeepLinkHandler alloc] init];
    } else if ([type isEqualToString:MESSAGE_TYPE]) {
        return [[ISRNotificationHandler alloc] init];
    } else {
        return nil;
    }
}

+(void)setCurrentView: (UIView*)view {
    CURRENT_VIEW_ = view;
}

+(UIView*)getCurrentView {
    return CURRENT_VIEW_;
}

@end
