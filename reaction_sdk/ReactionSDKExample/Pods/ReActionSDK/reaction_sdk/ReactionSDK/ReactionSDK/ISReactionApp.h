//
//  ISReactionApp.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Google.CloudMessaging;

@interface ISReactionApp : NSObject
/* UIResponder <UIApplicationDelegate, GCMReceiverDelegate>

@property (strong, nonatomic) UIWindow *window; */
NS_ASSUME_NONNULL_BEGIN
+(void)registerGCMServiceWithApplication: (UIApplication*)application
                             deviceToken: (NSData*)deviceToken;

+(void)applicationDidBecomeActive: (UIApplication*)application;

+(void)applicationDidEnterBackground: (UIApplication*)application;

+(void)receiveRemoteNotificationWithApplication: (UIApplication*)application
                                       userInfo: (NSDictionary*)userInfo;

+(void)receiveRemoteNotificationWithApplication: (UIApplication*)application
                                       userInfo: (NSDictionary*)userInfo
                         fetchCompletionHandler: (void (^)(UIBackgroundFetchResult))completionHandler;

+(void)receiveLocalNotificationWithApplication: (UIApplication*)application
                                  notification: (nonnull UILocalNotification*)notification;
NS_ASSUME_NONNULL_END
@end
