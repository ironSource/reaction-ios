//
//  ISReactionApp.m
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ISReactionApp.h"

#import "helper/ISRLogger.h"
#import "helper/ISRConfig.h"

static NSString* TAG_ = @"ISReactionApp";

@implementation ISReactionApp

-(void)application: (UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:
        (NSData*)deviceToken {
    NSMutableDictionary<NSString*, NSObject*>* userInfo = [[NSMutableDictionary alloc] init];
    
    [userInfo setObject:deviceToken forKey:@"deviceToken"];
    
    GCMConfig* gcmConfig = [GCMConfig defaultConfig];
    [gcmConfig setReceiverDelegate:self];
    
    [[GCMService sharedInstance] startWithConfig:gcmConfig];
    
    [[GCMService sharedInstance] connectWithHandler: ^(NSError* error) {
        if (error != nil) {
            [[ISRLogger sharedLogger] debugWithTag:TAG_ message:
             [NSString stringWithFormat:@"Could not connect to GCM: %@",
              [error description]]];
        } else {
            [[ISRLogger sharedLogger] debugWithTag:TAG_ message:@"Connected to GCM!"];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:
     [ISRConfig REGISTER_SUCCESS_CALLBACK] object:nil userInfo:userInfo];
}

-(void)applicationDidBecomeActive: (UIApplication*)application {
    [[GCMService sharedInstance] connectWithHandler: ^ (NSError* error) {
        if (error != nil) {
            [[ISRLogger sharedLogger] debugWithTag:TAG_ message:
             [NSString stringWithFormat:@"Could not connect to GCM: %@",
              [error description]]];
        } else {
            [[ISRLogger sharedLogger] debugWithTag:TAG_ message:@"Connected to GCM!"];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:
     [ISRConfig APPLICATION_ACTIVE_CALLBACK] object:nil userInfo:nil];
}

-(void)applicationDidEnterBackground: (UIApplication*)application {
    [[GCMService sharedInstance] disconnect];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:
     [ISRConfig APPLICATION_BACKGROUND_CALLBACK] object:nil userInfo:nil];
}

-(void)application: (UIApplication*)application didReceiveRemoteNotification:
    (NSDictionary*)userInfo {
    [[ISRLogger sharedLogger] debugWithTag:TAG_ message:@"Notification received!"];
    
    //long number = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:++number];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:
     [ISRConfig RECEIVE_MESSAGE_CALLBACK] object:nil userInfo:userInfo];
}

-(void)application: (UIApplication*)application
    didReceiveRemoteNotification: (NSDictionary*)userInfo
    fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler {
    
    [[ISRLogger sharedLogger] debugWithTag:TAG_ message:@"Notification received! 1"];
    
    //long number = [application applicationIconBadgeNumber];
    
    //[application setApplicationIconBadgeNumber:++number];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:
     [ISRConfig RECEIVE_MESSAGE_CALLBACK] object:nil userInfo:userInfo];

    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application: (UIApplication *)application
    didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:
     [ISRConfig RECEIVE_MESSAGE_CALLBACK] object:nil userInfo:notification.userInfo];
}

@end
