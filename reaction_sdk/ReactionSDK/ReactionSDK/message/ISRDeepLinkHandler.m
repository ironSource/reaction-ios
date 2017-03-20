//
//  ISRDeepLinkHandler.m
//  ReActionSDK
//
//  Created by Valentine.Pavchuk on 1/4/17.
//  Copyright © 2017 IronSource. All rights reserved.
//

#import "ISRDeepLinkHandler.h"

#import "../helper/ISRLogger.h"
#import "../helper/ISRUtils.h"

static NSString* TAG_ = @"ISRUrlHandler";

@implementation ISRDeepLinkHandler

-(void)process: (NSDictionary<NSString*,NSObject*>*)data {
    NSString* deepLink = (NSString*)data[@"deepLink"];
    
    if (deepLink != nil) {
        NSURL* url = [NSURL URLWithString:deepLink];
        if ([ISRUtils canOpenURLInView:url]) {
           [ISRUtils openURLInView:url];
        }
    }else {
        [[ISRLogger sharedLogger] debugWithTag:TAG_
                                       message:@"Not exist 'deepLink' key in notification data!"];
    }
}

@end
