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
            NSURLSessionDownloadTask* downloadTask = [[NSURLSession sharedSession] downloadTaskWithURL:urlObject completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (location != nil) {
                    NSString* tmpDirectory = NSTemporaryDirectory();
                    
                    NSDateFormatter *formatter;
                    NSString        *dateString;
                    
                    formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd_MM_yyyy_HH_mm_ss_SSS"];
                    
                    dateString = [formatter stringFromDate:[NSDate date]];
                    
                    NSString* tmpFile = [NSString
                                         stringWithFormat:@"file://%@%@", tmpDirectory,
                                         [NSString stringWithFormat:@"isr_%@%@", dateString,
                                          [urlObject lastPathComponent]]];
                    
                    NSURL* tmpURL = [NSURL URLWithString:tmpFile];
                    
                    NSError* errorMove;
                    BOOL fileExist = [[NSFileManager defaultManager] fileExistsAtPath:tmpFile isDirectory:false];
                    if (fileExist) {
                        [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
                    } else {
                        [[NSFileManager defaultManager] removeItemAtPath:tmpFile error:nil];
                    }
                    BOOL success = [[NSFileManager defaultManager] copyItemAtURL:location
                                                                      toURL:tmpURL error: &errorMove];
                    
                    NSString* errorStr = [errorMove localizedDescription];
                    if (success == YES) {
                        NSError* errorCreate;
                        UNNotificationAttachment* attachment = [UNNotificationAttachment
                                            attachmentWithIdentifier:@"" URL:tmpURL
                                            options: nil error: &errorCreate];
                        
                        [self.bestAttemptContent setAttachments:@[attachment]];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reactionReceiveMessage"
                                                                        object:nil userInfo:[self.bestAttemptContent userInfo]];
                    
                    completionHandler(self.bestAttemptContent);
                }
            }];
            
            [downloadTask resume];
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reactionReceiveMessage"
                                                            object:nil userInfo:[self.bestAttemptContent userInfo]];
        
        completionHandler(self.bestAttemptContent);
    }
    
    
}

- (void)serviceExtensionTimeWillExpire {
    self.contentHandler(self.bestAttemptContent);
}

@end
