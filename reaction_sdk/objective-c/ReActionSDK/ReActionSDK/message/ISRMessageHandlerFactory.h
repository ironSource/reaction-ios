//
//  ISReactionMessageHandlerFactory.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ISRMessageHandler.h"

@interface ISRMessageHandlerFactory : NSObject

+(id<ISRMessageHandler>)createMessageHandler: (NSString*)type;

+(void)setCurrentView: (UIView*)view;

+(UIView*)getCurrentView;

@end
