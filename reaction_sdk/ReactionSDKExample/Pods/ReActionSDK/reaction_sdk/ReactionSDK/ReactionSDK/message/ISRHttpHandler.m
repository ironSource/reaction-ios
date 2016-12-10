//
//  ISReactionHttpHandler.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//


#import "ISRHttpHandler.h"

#import <UIKit/UIKit.h>

#import "../helper/ISRLogger.h"
#import "../view/ISRHtmlView.h"

#import "ISRMessageHandlerFactory.h"

static NSString* TAG_ = @"ISRHttpethod";

@implementation ISRHttpHandler

-(void)process: (NSDictionary<NSString*, NSObject*>*)data {
	NSString* htmlData = (NSString*)data[@"html"];
	if (htmlData == nil) {
		[[ISRLogger sharedLogger] debugWithTag:TAG_ message:
         @"Not exist 'html' key in notification data!"];
		return; 
	}

	NSString* orientationStr = (NSString*)data[@"orientation"];
	if (orientationStr == nil) {
		[[ISRLogger sharedLogger] debugWithTag:TAG_ message:
         @"Not exist 'orientation' key in notification data!"];
		return; 
	}

	NSString* percentageStr = (NSString*)data[@"percentage"];
	if (percentageStr == nil) {
		[[ISRLogger sharedLogger] debugWithTag:TAG_ message:
         @"Not exist 'percentage' key in notification data!"];
		return; 
	}

	NSInteger percentage = [percentageStr integerValue];
	if (percentage == 0) {
		[[ISRLogger sharedLogger] debugWithTag:TAG_ message:
         [NSString stringWithFormat:@"Incorrect value for 'percentage': %ld",
          (long)percentage]];
		return; 
	}

	NSInteger ratio;
	NSString* ratioStr = (NSString*)data[@"ratio"];
	if (ratioStr != nil) {
		ratio = [ratioStr integerValue];
		if (ratio == 0) {
			ratio = 100;
		}
	} else {
		ratio = 100;
	}

	NSInteger vertical;
	NSString* verticalStr = (NSString*)data[@"vertical"];
	if (verticalStr != nil) {
		vertical = [verticalStr integerValue];
	} else {
		vertical = 0;
	}

	UIViewController* currentController = [[[UIApplication sharedApplication]
                                            keyWindow] rootViewController];
    
    ISRViewOrientation orientation = (ISRViewOrientation)[orientationStr integerValue];
    
    ISRHtmlView* htmlView = [[ISRHtmlView alloc]
                             initWithHtmlData:htmlData percentage:(int)percentage
                             ratio:(int)ratio vertical:(int)vertical
                             orientation:orientation];
    
    UIView* previousView = [ISRMessageHandlerFactory getCurrentView];
    if (previousView != nil) {
        [previousView removeFromSuperview];
    }
    [ISRMessageHandlerFactory setCurrentView:htmlView];
    
    [htmlView setTranslatesAutoresizingMaskIntoConstraints:false];
    [[currentController view] addSubview:htmlView];
    
    NSLayoutConstraint* withConstraint = [NSLayoutConstraint
                                          constraintWithItem:htmlView attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual toItem:[currentController view]
                                          attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    
    NSLayoutConstraint* heightConstraint = [NSLayoutConstraint
                                            constraintWithItem:htmlView attribute:NSLayoutAttributeHeight
                                            relatedBy:NSLayoutRelationEqual toItem:[currentController view]
                                            attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    
    [NSLayoutConstraint activateConstraints:[[NSArray alloc] initWithObjects:
                                             withConstraint, heightConstraint,
                                             nil]];
}

@end
