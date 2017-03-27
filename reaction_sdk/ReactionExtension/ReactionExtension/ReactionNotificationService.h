//
//  ReactionServiceExtension.h
//  ReactionExtension
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2017 IronSource. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>

@interface ReactionServiceExtension : UNNotificationServiceExtension

-(void)modificateRemoteNotificationWithCompletionHandler: (void (^)(UNNotificationContent* _Nullable result))completionHandler;

@end
