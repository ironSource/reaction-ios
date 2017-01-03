//
//  ISReactionUtils.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISRUtils : NSObject

+(void)setSharedPreferenceWithKey: (NSString*)key value: (NSString*)value;

+(NSString*)getSharedPreference: (NSString*)key;

+(NSString*)convertDeviceTokenToStr: (NSData*)deviceToken;

+(NSString*)getCurrentAppVersion;

+(NSString*)getGMTOffset;

+(NSString*)objectToJsonStr: (NSObject*)data;

+(NSDictionary*)jsonStrToDictionary: (NSString*)jsonStr;

+(void)openURLInView: (NSURL*)url;

+(BOOL)validateUrl: (NSString*)url;

+(void)scheduleTimerTaskWithTIme: (int64_t)time callback: (void (^)())callback;

+(NSString*)getTypeFromNotificationData: (NSDictionary<NSString*, NSObject*>*)data;

+(NSString*)getUserAgentName;

@end
