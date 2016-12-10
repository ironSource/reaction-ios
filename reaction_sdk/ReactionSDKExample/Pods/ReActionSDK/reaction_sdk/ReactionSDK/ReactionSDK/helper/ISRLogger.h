//
//  Logger.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISRLogger : NSObject

+(ISRLogger*)sharedLogger;

-(void)debugWithTag: (NSString*)tag message: (NSString*)message;

@end
