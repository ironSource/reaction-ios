//
//  Reaction.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@import Google.CloudMessaging;

@interface ISReaction : NSObject <GGLInstanceIDDelegate>
{
    BOOL isDebug_;
    BOOL isSendedUserData_;
    
    NSString* senderID_;
    NSString* applicationKey_;
    NSString* deviceID_;
    
    NSMutableDictionary<NSString*, NSObject*>* registrationOptions_;
    
    NSString* registrationToken_;
}

-(id)initWithSenderID: (NSString*)senderID applicationKey: (NSString*)applicationKey
              isDebug: (BOOL)isDebug;

-(void)enableDebug: (BOOL)isDebug;

-(void)registerDemoDeviceWithAppKey: (NSString*)appKey;

-(void)onTokenRefresh;

-(NSString*)getDeviceID;

-(void)reportNumberWithName: (NSString*)name value: (float)value;

-(void)reportBooleanWithName: (NSString*)name value: (BOOL)value;

-(void)reportStringWithName: (NSString*)name value: (NSString*)value;

-(void)reportPurchase: (float)value;

-(void)reportRevenue: (float)value;

@end
