//
//  ISReactionConfig.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISRConfig : NSObject

+(NSString*)ADD_USER_URL;
+(NSString*)ADD_DEMO_USER;

+(NSString*)PULL_CAMPAIGN_URL;

+(NSString*)SDK_VERSION;

+(NSString*)TOKEN_KEY;
+(NSString*)DEVICE_ID_KEY;
+(NSString*)APP_KEY;

+(NSString*)FIRST_LAUNCH;

+(int64_t)REQUEST_RETRY_TIMEOUT;

+(NSString*)REGISTER_SUCCESS_CALLBACK;
+(NSString*)REGISTER_ERROR_CALLBACK;

+(NSString*)RECEIVE_MESSAGE_CALLBACK;

+(NSString*)APPLICATION_ACTIVE_CALLBACK;
+(NSString*)APPLICATION_BACKGROUND_CALLBACK;

@end
