//
//  ISReactionUrlHandler.m
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ISRUrlHandler.h"

#import "../helper/ISRLogger.h"
#import "../helper/ISRUtils.h"

static NSString* TAG_ = @"ISRUrlHandler";

@implementation ISRUrlHandler

-(void)process: (NSDictionary<NSString*,NSObject*>*)data {
    NSString* urlStr = (NSString*)data[@"url"];
    
    if (urlStr != nil) {
        if (![urlStr hasPrefix:@"http://"] && ![urlStr hasPrefix:@"https://"]) {
            urlStr = [NSString stringWithFormat:@"http://%@", urlStr];
        }
        
        if ([ISRUtils validateUrl:urlStr]) {
            NSURL* url = [NSURL URLWithString:urlStr];
            
            if (url != nil) {
                [ISRUtils openURLInView:url];
            } else {
                [[ISRLogger sharedLogger] debugWithTag:TAG_ message:
                 [NSString stringWithFormat:@"Can't convert 'url': %@ to NSURL object!", urlStr]];
            }
        } else {
            [[ISRLogger sharedLogger] debugWithTag:TAG_ message:
             [NSString stringWithFormat:@"Not valid 'url': %@", urlStr]];
        }
    } else {
        [[ISRLogger sharedLogger] debugWithTag:TAG_
                message:@"Not exist 'url' key in notification data!"];
    }
}

@end
