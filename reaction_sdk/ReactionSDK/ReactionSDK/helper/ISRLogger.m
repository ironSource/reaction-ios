//
//  Logger.m
//  ReactionSDKExample
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ISRLogger.h"

static NSString* DEBUG_TAG = @"DEBUG";

@implementation ISRLogger

+(ISRLogger*)sharedLogger {
    static ISRLogger* sharedLogger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^() {
        sharedLogger = [[ISRLogger alloc] init];
    });

    return sharedLogger;
}

-(void)debugWithTag:(NSString *)tag message:(NSString *)message {
    NSLog(@"%@", [NSString stringWithFormat:@"%@:%@: %@", DEBUG_TAG,
                  tag, message]);
}

@end
