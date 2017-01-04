//
//  Reaction.m
//  ReactionSDKExample
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ISReaction.h"

#import <UIKit/UIKit.h>

#import "helper/ISRUtils.h"
#import "helper/ISRConfig.h"
#import "helper/ISRLogger.h"
#import "helper/ISRAtomController.h"

#import "message/ISRMessageHandler.h"
#import "message/ISRMessageHandlerFactory.h"

#import "http/ISRResponse.h"
#import "http/ISRRequest.h"

@interface ISReaction()

-(id)initWithSenderID: (NSString*)senderID applicationKey: (NSString*)applicationKey
              isDebug: (BOOL)isDebug;

-(void)initNotificationCallbacks;

-(void)registerError: (NSNotification*)notification;

-(void)registerSuccess: (NSNotification*)notification;

-(void)registrationHandlerWithToken: (NSString*)token error: (NSError*)error;

-(BOOL)isNewUser;

-(NSString*)getAdvertisingID;

-(void)showReceivedMessage: (NSNotification*)notification;

-(void)sendAddUser;

@end

static NSString* TAG_ = @"ISReaction";

@implementation ISReaction

+(ISReaction*)createWithSenderID: (NSString*)senderID applicationKey: (NSString*)applicationKey
                         isDebug: (BOOL)isDebug {
    static ISReaction *sharedReaction = nil;
    @synchronized(self) {
        if (sharedReaction == nil)
            sharedReaction = [[self alloc] initWithSenderID:senderID applicationKey:applicationKey isDebug:isDebug];
    }
    [sharedReaction enableDebug:isDebug];
    
    return sharedReaction;
}

-(id)initWithSenderID: (NSString*)senderID applicationKey: (NSString*)applicationKey
              isDebug: (BOOL)isDebug {
    self = [super init];
    
    if (self) {
        self->senderID_ =  senderID;
        self->applicationKey_ = applicationKey;
        
        self->registrationGCMRetryTimeout_ = 10;
        
        [ISRUtils setSharedPreferenceWithKey:[ISRConfig APP_KEY]
                                              value:applicationKey];
        
        NSError* configureError;
        [[GGLContext sharedInstance] configureWithError:&configureError];
        
        [[ISRLogger sharedLogger] debugWithTag:TAG_
            message:[NSString stringWithFormat:@"Error configuring Google serivecs %@",
                     [configureError localizedDescription]]];
        
        [self initNotificationCallbacks];
        
        // register for remote notification
        if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
            UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        } else {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        }
        
        [self enableDebug:isDebug];
    }
    return self;
}

-(void)enableDebug: (BOOL)isDebug {
    self->isDebug_ = isDebug;
}

-(void)initNotificationCallbacks {
    [[NSNotificationCenter defaultCenter]
     addObserverForName:[ISRConfig REGISTER_ERROR_CALLBACK]
     object:nil queue:nil usingBlock: ^(NSNotification* notification) {
        [self registerError:notification];
    }];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:[ISRConfig REGISTER_SUCCESS_CALLBACK]
     object:nil queue:nil usingBlock: ^(NSNotification* notification) {
         [self registerSuccess:notification];
    }];
    
    [[NSNotificationCenter defaultCenter]
     addObserverForName:[ISRConfig RECEIVE_MESSAGE_CALLBACK]
     object:nil queue:nil usingBlock: ^(NSNotification* notification) {
         [self showReceivedMessage:notification];
    }];
}

-(void)registerError: (NSNotification*)notification {
    NSDictionary<NSString*, NSString*>* userInfo = [notification userInfo];
    
    NSString* errorStr = userInfo[@"error"];
    if (errorStr != nil) {
        [[ISRLogger sharedLogger] debugWithTag:TAG_ message:errorStr];
    }
}

-(void)registerSuccess: (NSNotification*)notification {
    NSDictionary<NSString*, NSString*>* userInfo = [notification userInfo];
    
    NSData* deviceToken = (NSData*)userInfo[@"deviceToken"];
    self->deviceID_ = [ISRUtils convertDeviceTokenToStr:deviceToken];
    
    [ISRUtils setSharedPreferenceWithKey:[ISRConfig DEVICE_ID_KEY]
                                   value:self->deviceID_];
    
    [[ISRLogger sharedLogger] debugWithTag:TAG_
            message:[NSString stringWithFormat:@"Device ID: %@",
                     self->deviceID_]];
    
    GGLInstanceIDConfig* idConfig = [GGLInstanceIDConfig defaultConfig];
    [idConfig setDelegate:self];

    // Start the GGLInstanceID shared instance with that config and request a registration
    // token to enable reception of notifications
    [[GGLInstanceID sharedInstance] startWithConfig:idConfig];
    
    NSDictionary* registrationOptions = @{kGGLInstanceIDRegisterAPNSOption:deviceToken,
                                          kGGLInstanceIDAPNSServerTypeSandboxOption:@YES};
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:self->senderID_
                                                        scope:kGGLInstanceIDScopeGCM
                                                      options:registrationOptions
                                                      handler:
     ^(NSString *registrationToken, NSError *error){
         [self registrationHandlerWithToken:registrationToken error:error];
     }];
}

-(void)registrationHandlerWithToken: (NSString*)token error: (NSError*)error {
    if (token != nil) {
        self->registrationToken_ = token;
        
        [[ISRLogger sharedLogger]
         debugWithTag:TAG_
         message:[NSString stringWithFormat:@"Registration token: %@", token]];
        
        BOOL isNewUSer = [self isNewUser];
        [[ISRLogger sharedLogger] debugWithTag:TAG_
            message:[NSString stringWithFormat:@"Is new user: %@",
                     (isNewUSer ? @"true" : @"false")]];
        
        NSString* prevRegistrationToken = [ISRUtils getSharedPreference:
                                           [ISRConfig TOKEN_KEY]];
        
        if (![self->registrationToken_ isEqualToString:prevRegistrationToken]) {
            [ISRUtils setSharedPreferenceWithKey:[ISRConfig TOKEN_KEY]
                                           value:self->registrationToken_];
        
            [self sendAddUser];
        }
        
        if (!self->isSendedUserData_) {
            self->isSendedUserData_ = true;
            [[ISRAtomController sharedController] sendUser:isNewUSer];
            [[ISRAtomController sharedController] sendAdvertisingID:
             [self getAdvertisingID]];
        }
    } else {
        [[ISRLogger sharedLogger] debugWithTag:TAG_ message:
         [NSString stringWithFormat:@"Registration to GCM failed with error: %@",
          [error description]]];
        
        int gmcTimeout = self->registrationGCMRetryTimeout_;
        
        if (gmcTimeout <= 1024 * 10) {
            self->registrationGCMRetryTimeout_ = self->registrationGCMRetryTimeout_ * 2;
            
            
            [ISRUtils scheduleTimerTaskWithTIme:gmcTimeout callback: ^() {
                [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:self->senderID_
                    scope:kGGLInstanceIDScopeGCM options:self->registrationOptions_
                    handler:^(NSString* registrationToken, NSError* error) {
                        [self registrationHandlerWithToken:registrationToken error:error];
                }];
            }];
 
        }
    }
}

-(BOOL)isNewUser {
    NSString* firstLaunch = [ISRUtils getSharedPreference:[ISRConfig FIRST_LAUNCH]];
    
    if (firstLaunch == nil || (firstLaunch != nil && ([firstLaunch length] == 0))) {
        [ISRUtils setSharedPreferenceWithKey:[ISRConfig FIRST_LAUNCH] value:@"NO"];
        return true;
    }
    return false;
}

-(NSString*)getAdvertisingID {
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

-(void)showReceivedMessage: (NSNotification*)notification {
    NSDictionary<NSString*, NSObject*>* notificationData = (NSDictionary<NSString*,
                                                            NSObject*>*)[notification userInfo];

    [[GCMService sharedInstance] appDidReceiveMessage:notificationData];
    
    [[ISRLogger sharedLogger] debugWithTag:TAG_ message:[NSString stringWithFormat:
                            @"Notification received: %@", notificationData]];
    
    NSString* type = [ISRUtils getTypeFromNotificationData:notificationData];
    
    NSString* compaignID = (NSString*)notificationData[@"id"];
    if (compaignID != nil) {
        [[ISRAtomController sharedController] sendImpressions:compaignID];
    }
    
    id<ISRMessageHandler> messageHandler = [ISRMessageHandlerFactory createMessageHandler:type];
    if (messageHandler != nil) {
        [messageHandler process:notificationData];
    }
}

-(void)sendAddUser {
    NSMutableDictionary<NSString*, NSObject*>* userData = [[NSMutableDictionary alloc] init];
    
    [userData setObject:self->registrationToken_ forKey:@"token"];
    [userData setObject:self->applicationKey_ forKey:@"app_key"];
    [userData setObject:self->deviceID_ forKey:@"android_id"];
    [userData setObject:[ISRUtils getCurrentAppVersion] forKey:@"app_version"];
    [userData setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"package"];
    [userData setObject:[ISRConfig SDK_VERSION] forKey:@"sdk_version"];
    [userData setObject:[NSLocale preferredLanguages][0] forKey:@"locale"];
    [userData setObject:[ISRUtils getGMTOffset] forKey:@"gmt"];
    
    NSString* userDataJson = [ISRUtils objectToJsonStr:userData];
    
    [[ISRLogger sharedLogger] debugWithTag:TAG_ message:userDataJson];
    
    NSMutableDictionary<NSString*, NSString*>* headers = [[NSMutableDictionary alloc] init];
    [headers setObject:@"application/json" forKey:@"Content-type"];
    
    ISRRequest* request = [[ISRRequest alloc] initWithUrl:[ISRConfig ADD_USER_URL]
                                                     data:userDataJson
                                                  headers:headers
                                                 isDebug:self->isDebug_];
    
    ISRRequestCallback httpCallback = ^(ISRResponse* response) {
        [[ISRLogger sharedLogger] debugWithTag:TAG_ message:
         [NSString stringWithFormat:@"From callback - (data): %@\n(error): %@\n(status):%ld",
          [response data], [response error], [response status]]];
        
        if ([response status] != 200) {
            if ([[[response data] lowercaseString] containsString:@"exist"]) {
                [ISRUtils scheduleTimerTaskWithTIme:[ISRConfig REQUEST_RETRY_TIMEOUT]
                                           callback: ^() {
                                               [request post];
                                           }];
            }
        }
    };
    
    [request initListener:httpCallback];
    [request post];
}

-(void)registerDemoDeviceWithAppKey: (NSString*)appKey {
    NSMutableDictionary<NSString*, NSObject*>* userData = [[NSMutableDictionary alloc] init];
    
    [userData setObject:appKey forKey:@"app_key"];
    [userData setObject:self->deviceID_ forKey:@"android_id"];
    [userData setObject:[[NSBundle mainBundle] bundleIdentifier] forKey:@"package"];
    [userData setObject:[[UIDevice currentDevice] name] forKey:@"name"];
    
    NSString* userDataJson = [ISRUtils objectToJsonStr:userData];
    
    [[ISRLogger sharedLogger] debugWithTag:TAG_ message:userDataJson];
    
    NSMutableDictionary<NSString*, NSString*>* headers = [[NSMutableDictionary alloc] init];
    [headers setObject:@"application/json" forKey:@"Content-type"];
    
    ISRRequest* request = [[ISRRequest alloc] initWithUrl:[ISRConfig ADD_DEMO_USER]
                                                     data:userDataJson
                                                  headers:headers
                                                  isDebug:self->isDebug_];
    
    ISRRequestCallback httpCallback = ^(ISRResponse* response) {
        [[ISRLogger sharedLogger] debugWithTag:TAG_ message:
         [NSString stringWithFormat:@"From callback - (data): %@\n(error): %@\n(status):%ld",
          [response data], [response error], [response status]]];
    };
    
    [request initListener:httpCallback];
    [request post];
}

-(void)onTokenRefresh {
    [[ISRLogger sharedLogger] debugWithTag:TAG_ message:
     @"The GCM registration token needs to be changed!"];
    
    [[GGLInstanceID sharedInstance] tokenWithAuthorizedEntity:self->senderID_
              scope:kGGLInstanceIDScopeGCM options:self->registrationOptions_
              handler:^(NSString* registrationToken, NSError* error) {
                  [self registrationHandlerWithToken:registrationToken error:error];
              }];
}

-(NSString*)getDeviceID {
    return [ISRUtils getSharedPreference:[ISRConfig DEVICE_ID_KEY]];
}

-(void)reportNumberWithName: (NSString*)name value: (float)value {
    [[ISRAtomController sharedController] sendReportNumberWithName:name value:value];
}

-(void)reportBooleanWithName: (NSString*)name value:(BOOL)value {
    [[ISRAtomController sharedController] sendReportBooleanWithName:name value:value];
}

-(void)reportStringWithName: (NSString*)name value: (NSString*)value {
    [[ISRAtomController sharedController] sendReportStringWithName:name value:value];
}

-(void)reportPurchase: (float)value {
    [[ISRAtomController sharedController] sendReportPurchase:value];
}

-(void)reportRevenue: (float)value {
    [[ISRAtomController sharedController] sendReportRevenue:value];
}

-(void)pullCampaign {
    NSMutableDictionary<NSString*, NSObject*>* userData = [[NSMutableDictionary alloc] init];
    
    [userData setObject:self->registrationToken_ forKey:@"token"];
    [userData setObject:self->deviceID_ forKey:@"android_id"];
    
    NSString* userDataJson = [ISRUtils objectToJsonStr:userData];
    
    NSMutableDictionary<NSString*, NSString*>* headers = [[NSMutableDictionary alloc] init];
    [headers setObject:@"application/json" forKey:@"Content-type"];
    
    ISRRequest* request = [[ISRRequest alloc] initWithUrl:[ISRConfig PULL_CAMPAIGN_URL]
                                                     data:userDataJson
                                                  headers:headers
                                                  isDebug:self->isDebug_];
    
    ISRRequestCallback httpCallback = ^(ISRResponse* response) {
        [[ISRLogger sharedLogger] debugWithTag:TAG_ message:
         [NSString stringWithFormat:@"From callback - (data): %@\n(error): %@\n(status):%ld",
          [response data], [response error], [response status]]];
        
        NSDictionary* responseData = [ISRUtils jsonStrToDictionary:[response data]];
        
        NSString* type = responseData[@"type"];
        NSString* compaignID = (NSString*)responseData[@"id"];
        if (compaignID != nil) {
            [[ISRAtomController sharedController] sendImpressions:compaignID];
        }
        
        id<ISRMessageHandler> messageHandler = [ISRMessageHandlerFactory createMessageHandler:type];
        if (messageHandler != nil) {
            [messageHandler process:responseData];
        }

    };
    
    [request initListener:httpCallback];
    [request post];
}

@end
