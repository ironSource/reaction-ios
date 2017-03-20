//
//  ISRDeepLinkHandler.h
//  ReActionSDK
//
//  Created by g8y3e on 1/4/17.
//  Copyright © 2017 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ISRMessageHandler.h"

@interface ISRDeepLinkHandler : NSObject <ISRMessageHandler>

-(void)process: (NSDictionary<NSString*, NSObject*>*)data;

@end
