//
//  ISReactionNotificationHandler.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ISRMessageHandler.h"

@interface ISRNotificationHandler : NSObject <ISRMessageHandler>

-(void)process: (NSDictionary<NSString*,NSObject*>*)data;

@end
