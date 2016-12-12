//
//  ISReactionUrlHandler.h
//  ReactionSDKExample
//
//  Created by Valentine.Pavchuk on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ISRMessageHandler.h"

@interface ISRUrlHandler : NSObject <ISRMessageHandler>

-(void)process: (NSDictionary<NSString*, NSObject*>*)data;

@end
