//
//  AtomController.m
//  ReactionSDKExample
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ISRAtomController.h"

#import <AtomSDK/ISAtom.h>

#import "ISRLogger.h"
#import "ISRUtils.h"
#import "ISRConfig.h"

@interface ISRAtomController()
{
    ISAtom* atomSDK_;
}

-(void)sendEventWithStream: (NSString*)stream
                      data: (NSDictionary<NSString*, NSObject*>*)data
             isForceReport: (BOOL)isForceReport;

@end

static NSString* TAG_ = @"ISAtomController";

static NSString* END_POINT = @"https://track.atom-data.io/";
static NSString* AUTH_KEY = @"p2gw4V3hVwgYCzGFmcy2EGTV6DdKtj";

static NSString* STREAM_USERS = @"ironlabs.gcm.users";
static NSString* STREAM_CLICK = @"ironlabs.gcm.clicks";
static NSString* STREAM_EVENTS = @"ironlabs.gcm.events";
static NSString* STREAM_ERRORS = @"ironlabs.gcm.errors";
static NSString* STREAM_INTERNAL_ERRORS = @"ironlabs.gcm.errors_internal";
static NSString* STREAM_IMPRESSIONS = @"ironlabs.gcm.impressions";
static NSString* STREAM_LOGS = @"ironlabs.gcm.logs";
static NSString* STREAM_AD_ID = @"ironlabs.gcm.adid";

@implementation ISRAtomController

+(ISRAtomController*)sharedController {
    static ISRAtomController* sharedController;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^() {
        sharedController = [[ISRAtomController alloc] init];
    });
    
    return sharedController;
}

-(id)init {
    self = [super init];
    
    if (self) {
        self->atomSDK_ = [[ISAtom alloc] init];
        
        [self->atomSDK_ enableDebug:true];
        [self->atomSDK_ setAuth:AUTH_KEY];
        [self->atomSDK_ setEndPoint:END_POINT];
        
        [[ISRLogger sharedLogger]
         debugWithTag:TAG_ message:@"Atom Controller created!"];
        
    }
    return self;
}

-(void)sendEventWithStream: (NSString*)stream
                      data: (NSDictionary<NSString*,NSObject*>*)data
             isForceReport: (BOOL)isForceReport {
    NSString* registrationToken = [ISRUtils
                                   getSharedPreference:[ISRConfig TOKEN_KEY]];
    
    // empty need to clear
    NSString* sessionID = @"";
    NSString* deviceID = [ISRUtils
                          getSharedPreference: [ISRConfig DEVICE_ID_KEY]];
    
    NSString* applicationKey = [ISRUtils getSharedPreference:
                                [ISRConfig APP_KEY]];

    if ((registrationToken != nil && ![registrationToken isEqualToString:@""] &&
        applicationKey != nil && ![applicationKey isEqualToString:@""]) ||
        isForceReport) {
        
        [[ISRLogger sharedLogger]
         debugWithTag:TAG_
         message:[NSString stringWithFormat:@"Send event: %@; %@; %@;",
                  registrationToken, deviceID, applicationKey]];
        
        NSMutableDictionary<NSString*, NSObject*>* sendData = [NSMutableDictionary
                                                               dictionaryWithDictionary:data];
        
        [sendData setObject:sessionID forKey:@"session_id"];
        [sendData setObject:registrationToken forKey:@"reg_id"];
        //[sendData setObject:deviceID forKey:@"ios_id"];
        [sendData setObject:deviceID forKey:@"android_id"];
        [sendData setObject:applicationKey forKey:@"app_key"];
        [sendData setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"package"];
        [sendData setObject:[ISRUtils getCurrentAppVersion] forKey:@"app_version"];
        [sendData setObject:[ISRConfig SDK_VERSION] forKey:@"sdk_version"];
        [sendData setObject:[ISRUtils getCurrentDatetime] forKey:@"datetime"];
        
        [[ISRLogger sharedLogger]
         debugWithTag:TAG_ message:[NSString stringWithFormat:@"Add event: %@", sendData]];
        
        [self->atomSDK_ putEventWithStream:stream
                                      data:[ISRUtils objectToJsonStr:sendData]];
    }
}

-(void)sendLog: (NSString*)message {
    NSMutableDictionary<NSString*, NSObject*>* eventObject = [[NSMutableDictionary
                                                               alloc] init];
    [eventObject setObject:message forKey:@"message"];
    
    [self sendEventWithStream:STREAM_LOGS data:eventObject isForceReport:false];
}

-(void)sendUser: (BOOL)isNewUser {
    NSMutableDictionary<NSString*, NSObject*>* eventObject = [[NSMutableDictionary
                                                               alloc] init];
    [eventObject setObject:[NSNumber numberWithBool:isNewUser] forKey:@"new_user"];
    
    [self sendEventWithStream:STREAM_USERS data:eventObject isForceReport:false];
}

-(void)sendClickWithCampaignID: (NSString*)compaignID variantID: (NSString*)variantID
              variantLanguange: (NSString*)variantLanguage {
    NSMutableDictionary<NSString*, NSObject*>* eventObject = [[NSMutableDictionary
                                                               alloc] init];
    [eventObject setObject:compaignID forKey:@"campaign_id"];
    [eventObject setObject:variantID forKey:@"variant_id"];
    [eventObject setObject:variantLanguage forKey:@"variant_language"];
    
    [self sendEventWithStream:STREAM_CLICK data:eventObject isForceReport:false];
}

-(void)sendImpressionsWithCampaignID: (NSString*)compaignID variantID: (NSString*)variantID
                    variantLanguange: (NSString*)variantLanguage {
    NSMutableDictionary<NSString*, NSObject*>* eventObject = [[NSMutableDictionary
                                                               alloc] init];
    [eventObject setObject:compaignID forKey:@"campaign_id"];
    [eventObject setObject:variantID forKey:@"variant_id"];
    [eventObject setObject:variantLanguage forKey:@"variant_language"];
    
    [self sendEventWithStream:STREAM_IMPRESSIONS data:eventObject isForceReport:false];
}

-(void)sendErrorWithName: (NSString*)name message: (NSString*)message
              stackTrace: (NSString*)stackTrace code: (double)code
              isInternal: (BOOL)isInternal {
    NSMutableDictionary<NSString*, NSObject*>* eventObject = [[NSMutableDictionary
                                                               alloc] init];
    
    [eventObject setObject:name forKey:@"error_name"];
    [eventObject setObject:message forKey:@"error_message"];
    [eventObject setObject:stackTrace forKey:@"error_stack_trace"];
    [eventObject setObject:[NSNumber numberWithDouble:code] forKey:@"error_code"];
    
    if (isInternal) {
        [self sendEventWithStream:STREAM_INTERNAL_ERRORS data:eventObject
                    isForceReport:true];
    } else {
        [self sendEventWithStream:STREAM_ERRORS data:eventObject
                    isForceReport:false];
    }
}

-(void)sendAdvertisingID: (NSString*)adID {
    NSMutableDictionary<NSString*, NSObject*>* eventObject = [[NSMutableDictionary
                                                               alloc] init];
    
    [eventObject setObject:adID forKey:@"ad_id"];
    
    [self sendEventWithStream:STREAM_AD_ID data:eventObject isForceReport:false];
}

-(void)sendReportWithName: (NSString*)name value: (NSObject*)value
                      keyName: (NSString*)keyName {
    NSMutableDictionary<NSString*, NSObject*>* eventObject = [[NSMutableDictionary
                                                               alloc] init];
    
    [eventObject setObject:name forKey:@"event_name"];
    [eventObject setObject:value forKey:keyName];
    
    [self sendEventWithStream:STREAM_EVENTS data:eventObject isForceReport:false];
}

-(void)sendReportStringWithName: (NSString*)name value: (NSString*)value {
    [self sendReportWithName:name value:value keyName:@"string_value"];
}

-(void)sendReportNumberWithName: (NSString*)name value: (float)value {
    [self sendReportWithName:name value:[NSNumber numberWithFloat:value]
                     keyName:@"float_value"];
}

-(void)sendReportBooleanWithName: (NSString*)name value: (BOOL)value {
    [self sendReportWithName:name value:[NSNumber numberWithBool:value]
                     keyName:@"bool_value"];
}

-(void)sendReportPurchase: (float)purchase {
    [self sendReportWithName:@"Purchase" value:[NSNumber numberWithFloat:purchase]
                     keyName:@"float_value"];
}

-(void)sendReportRevenue: (float)purchase {
    [self sendReportWithName:@"Revenue" value:[NSNumber numberWithFloat:purchase]
                     keyName:@"float_value"];
}

@end
