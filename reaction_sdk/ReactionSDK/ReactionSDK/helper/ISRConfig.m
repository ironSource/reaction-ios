//
//  ISReactionConfig.m
//  ReactionSDKExample
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ISRConfig.h"

@implementation ISRConfig

+(NSString*)ADD_USER_URL {
    return @"https://rct-upopa.com/user/addUser";
}

+(NSString*)ADD_DEMO_USER {
    return @"https://rct-upopa.com/user/addDebugDevice";
}

+(NSString*)PULL_CAMPAIGN_URL {
    return @"https://rct-upopa.com/pull";
}

+(NSString*)SDK_VERSION {
    return @"1.0.0";
}

+(NSString*)TOKEN_KEY {
    return @"com.reaction.sdk.registration_token";
}

+(NSString*)DEVICE_ID_KEY {
    return @"com.reaction.sdk.device_id";
}

+(NSString*)APP_KEY {
    return @"com.reaction.sdk.app_key";
}

+(NSString*)FIRST_LAUNCH {
    return @"com.reaction.sdk.first_launch";
}

+(int64_t)REQUEST_RETRY_TIMEOUT {
    return 10 * 60;
}

+(NSString*)REGISTER_SUCCESS_CALLBACK {
    return @"reactionRegisterSuccess";
}

+(NSString*)REGISTER_ERROR_CALLBACK {
    return @"reactionRegisterError";
}

+(NSString*)RECEIVE_MESSAGE_CALLBACK {
    return @"reactionReceiveMessage";
}

+(NSString*)APPLICATION_ACTIVE_CALLBACK {
    return @"applicationActive";
}

+(NSString*)APPLICATION_BACKGROUND_CALLBACK {
    return @"applicationBackground";
}

@end
