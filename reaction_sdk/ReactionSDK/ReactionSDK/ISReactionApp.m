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

+(void)registerGCMServiceWithApplication: (UIApplication*)application
                             deviceToken:(NSData*)deviceToken {
    NSMutableDictionary<NSString*, NSObject*>* userInfo = [[NSMutableDictionary alloc] init];
    
    [userInfo setObject:deviceToken forKey:@"deviceToken"];
    
    GCMConfig* gcmConfig = [GCMConfig defaultConfig];
    [gcmConfig setReceiverDelegate: (NSObject<GCMReceiverDelegate>*)application];
    
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

+(void)applicationDidBecomeActive:(UIApplication *)application {
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

+(void)applicationDidEnterBackground: (UIApplication*)application {
    [[GCMService sharedInstance] disconnect];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:
     [ISRConfig APPLICATION_BACKGROUND_CALLBACK] object:nil userInfo:nil];
}

+(void)receiveRemoteNotificationWithApplication: (UIApplication*)application
                                       userInfo: (NSDictionary*)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:
     [ISRConfig RECEIVE_MESSAGE_CALLBACK] object:nil userInfo:userInfo];
}

+(void)receiveRemoteNotificationWithApplication:(UIApplication *)application
                                       userInfo:(NSDictionary *)userInfo
                         fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [[NSNotificationCenter defaultCenter] postNotificationName:
     [ISRConfig RECEIVE_MESSAGE_CALLBACK] object:nil userInfo:userInfo];
    
    completionHandler(UIBackgroundFetchResultNoData);
}

+(void)receiveLocalNotificationWithApplication:(UIApplication *)application
                                  notification:(UILocalNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:
     [ISRConfig RECEIVE_MESSAGE_CALLBACK] object:nil userInfo:notification.userInfo];
}

/*
 -(void)application: (UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:
 (NSData*)deviceToken {
 [ISReactionApp registerGCMServiceWithApplication:application
 deviceToken:deviceToken];
 }
 
 -(void)applicationDidBecomeActive: (UIApplication*)application {
 [ISReactionApp applicationDidBecomeActive:application];
 }
 
 -(void)applicationDidEnterBackground: (UIApplication*)application {
 [ISReactionApp applicationDidEnterBackground:application];
 }
 
 -(void)application: (UIApplication*)application didReceiveRemoteNotification:
 (NSDictionary*)userInfo {
 [ISReactionApp receiveRemoteNotificationWithApplication:application
 userInfo:userInfo];
 }
 
 -(void)application: (UIApplication*)application
 didReceiveRemoteNotification: (NSDictionary*)userInfo
 fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler {
 [ISReactionApp receiveRemoteNotificationWithApplication:application
 userInfo:userInfo
 fetchCompletionHandler:completionHandler];
 }
 
 - (void)application: (UIApplication *)application
 didReceiveLocalNotification:(nonnull UILocalNotification *)notification {
 [ISReactionApp receiveLocalNotificationWithApplication:application
 notification:notification];
 }
 */

@end
