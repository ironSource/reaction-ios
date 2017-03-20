//
//  ISReactionUtils.m
//  ReactionSDKExample
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ISRUtils.h"

#import <UIKit/UIKit.h>

@implementation ISRUtils

+(void)setSharedPreferenceWithKey: (NSString*)key value: (NSString*)value {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}

+(NSString*)getSharedPreference: (NSString*)key {
    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

+(NSString*)convertDeviceTokenToStr: (NSData*)deviceToken {
    NSString* deviceTokenStr = [[deviceToken description] stringByReplacingOccurrencesOfString:@">" withString:@""];
    
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@"<"
                                                               withString:@""];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" "
                                                               withString:@""];
    return deviceTokenStr;
}

+(NSString*)getCurrentAppVersion {
    NSObject* nsObject = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    
    return (NSString*)nsObject;
}

+(NSString*)getGMTOffset {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"Z"];
    
    return [formatter stringFromDate:[[NSDate alloc] init]];
}

+(NSString*)objectToJsonStr: (NSObject*)data {
    NSError* jsonError = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data options:0
                                                         error:&jsonError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(NSDictionary*)jsonStrToDictionary: (NSString*)jsonStr {
    NSError* jsonError = nil;
    NSData* objectData = [@"{\"2\":\"3\"}" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:objectData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&jsonError];
    return json;
}

+(BOOL)canOpenURLInView: (NSURL*)url {
    return [[UIApplication sharedApplication] canOpenURL:url];
}

+(void)openURLInView: (NSURL*)url {
    [[UIApplication sharedApplication] openURL:url];
}

+(BOOL)validateUrl: (NSString*)url {
    if (url != nil) {
        NSURL* urlObject = [NSURL URLWithString:url];
        if (urlObject != nil) {
            return [[UIApplication sharedApplication] canOpenURL:urlObject];
        }
    }
    
    return false;
}

+(void)scheduleTimerTaskWithTIme: (int64_t)time callback: (void (^)())callback {
    int64_t seconds = time * (int64_t)NSEC_PER_SEC;
    
    dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, seconds);
    dispatch_after(dispatchTime, dispatch_get_main_queue(), callback);
}

+(NSString*)getTypeFromNotificationData:(NSDictionary<NSString *,NSObject *> *)data {
    NSString* type = (NSString*)data[@"type"];
    if (type == nil) {
        if (data[@"aps"] != nil) {
            type = @"notification";
        }
    }
    
    return type;
}

+(NSString*)getUserAgentName {
    UIWebView* view = [[UIWebView alloc] init];
    
    [view loadHTMLString:@"<html></html>" baseURL:nil];
    return [view stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}

+(NSString*)getCurrentDatetime {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
