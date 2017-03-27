//
//  ReactionNotificationService.h
//  ReactionExtension
//
//  Created by g8y3e on 11/9/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ReactionNotificationService.h"

@interface ReactionServiceExtension ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation ReactionServiceExtension

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];

    [self modificateRemoteNotificationWithCompletionHandler: ^(UNNotificationContent * _Nullable result) {
        self.contentHandler(result);
    }];
}

-(void)modificateRemoteNotificationWithCompletionHandler: (void (^)(UNNotificationContent* _Nullable result))completionHandler {
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    self.bestAttemptContent.subtitle = [[self.bestAttemptContent userInfo]
                                        objectForKey:@"subtitle"];
    
    NSString* imageURL = [[self.bestAttemptContent userInfo]
                          objectForKey:@"image"];
    
    if (imageURL != nil) {
        NSURL* urlObject = [NSURL URLWithString:imageURL];
        
        if (urlObject != nil) {
            [[NSURLSession sharedSession] downloadTaskWithURL:urlObject completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (location != nil) {
                    NSString* tmpDirectory = NSTemporaryDirectory();
                    NSString* tmpFile = [NSString
                                         stringWithFormat:@"file://%@%@", tmpDirectory,
                                         [NSString stringWithFormat:@"iron_source_reaction_%@",
                                          [urlObject lastPathComponent]]];
                    
                    NSURL* tmpURL = [NSURL URLWithString:tmpFile];
                    
                    NSError* errorMove;
                    [[NSFileManager defaultManager] moveItemAtURL:location
                                        toURL:tmpURL error: &errorMove];
                    
                    if (errorMove != nil) {
                        NSError* errorCreate;
                        UNNotificationAttachment* attachment = [UNNotificationAttachment
                                            attachmentWithIdentifier:@"" URL:tmpURL
                                            options: nil error: &errorCreate];
                        
                        [self.bestAttemptContent setAttachments:@[attachment]];
                        
                        completionHandler(self.bestAttemptContent);
                    }
                }
            }];
        }
    } else {
        completionHandler(self.bestAttemptContent);
    }
}

- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}

@end
