//
//  ISReactionApp.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <UIKit/UIKit.h>

@import Google.CloudMessaging;

@interface ISReactionApp : UIResponder <UIApplicationDelegate, GCMReceiverDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
