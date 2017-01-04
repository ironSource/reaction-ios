//
//  ISReactionNotificationHandler.m
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ISRNotificationHandler.h"

#import <UIKit/UIKit.h>

#import "ISRUrlHandler.h"

#import "../helper/ISRLogger.h"

static NSString* TAG_ = @"ISReactionNotificationHandler";

@implementation ISRNotificationHandler

-(void)process: (NSDictionary<NSString*,NSObject*>*)data {
    NSString* message = (NSString*)data[@"body"];
    NSString* title = (NSString*)data[@"title"];
    
    NSString* url = (NSString*)data[@"url"];
    NSString* deepLink = (NSString*)data[@"deepLink"];
    
    if (message == nil) {
        [[ISRLogger sharedLogger] debugWithTag:TAG_ message:
         @"Not exist 'body' key in notification data!"];
    }
    
    if (title == nil) {
        [[ISRLogger sharedLogger] debugWithTag:TAG_ message:
         @"Not exist 'title' key in notification data!"];
    }
    
    // do stuff's here
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    
    // for tests: current time plus 10 secs
    NSDate *now = [NSDate date];
    NSDate *dateToFire = [now dateByAddingTimeInterval:10];
    
    NSLog(@"now time: %@", now);
    NSLog(@"fire time: %@", dateToFire);
    
    localNotification.fireDate = dateToFire;
    localNotification.alertBody = message;
    
    if ([localNotification respondsToSelector:@selector(alertTitle)] ) {
        localNotification.alertTitle = title;
    }
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1; // increment
    
    // add specific data if needed
    
    NSMutableDictionary* dataMutable = [data mutableCopy];
    
    if (url != nil) {
        [dataMutable setValue:@"url" forKey:@"type"];

        localNotification.userInfo = dataMutable;
    } else if (deepLink != nil) {
        [dataMutable setValue:@"deepLink" forKey:@"type"];
        
        localNotification.userInfo = dataMutable;
    }
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


@end
