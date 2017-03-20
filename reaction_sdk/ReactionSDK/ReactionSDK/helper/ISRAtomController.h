//
//  AtomController.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISRAtomController : NSObject

+(ISRAtomController*)sharedController;

-(id)init;

-(void)sendLog: (NSString*)message;

-(void)sendUser: (BOOL)isNewUser;

-(void)sendClickWithCampaignID: (NSString*)compaignID variantID: (NSString*)variantID
              variantLanguange: (NSString*)variantLanguage;

-(void)sendImpressionsWithCampaignID: (NSString*)compaignID variantID: (NSString*)variantID
                    variantLanguange: (NSString*)variantLanguage;

-(void)sendErrorWithName: (NSString*)name message: (NSString*)message
              stackTrace: (NSString*)stackTrace code: (double)code
              isInternal: (BOOL)isInternal;

-(void)sendAdvertisingID: (NSString*)adID;

-(void)sendReportWithName: (NSString*)name value: (NSObject*)value
                  keyName: (NSString*)keyName;

-(void)sendReportStringWithName: (NSString*)name value: (NSString*)value;

-(void)sendReportNumberWithName: (NSString*)name value: (float)value;

-(void)sendReportBooleanWithName: (NSString*)name value: (BOOL)value;

-(void)sendReportPurchase: (float)purchase;

-(void)sendReportRevenue: (float)revenue;

@end
