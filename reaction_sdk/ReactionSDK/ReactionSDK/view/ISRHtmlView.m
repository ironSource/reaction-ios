//
//  ISReactionHtmlView.m
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import "ISRHtmlView.h"

#import <WebKit/WebKit.h>

#import "ISRWebInterface.h"

@implementation ISRHtmlView

-(id)initWithHtmlData: (NSString*)data percentage: (int)percentage
                ratio: (int)ratio vertical: (int)vertical
          orientation: (ISRViewOrientation)orientation {
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        int orientationUI = -1;
        
        switch (orientation) {
            case IS_ORIENTATION_PORTRAIT:
                orientationUI = UIInterfaceOrientationPortrait;
                break;
                
            case IS_ORIENTATION_LANDSCAPE:
                orientationUI = UIInterfaceOrientationLandscapeRight;
                break;
        }
        
        if (orientationUI != -1) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientationUI]
                                        forKey:@"orientation"];
        }
        
        self->htmlData_ = data;
        self->orientation_ = orientation;
        self->percentage_ = percentage;
        
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
        
        
        ISRWebInterface* webInterface = [[ISRWebInterface alloc] init:self];
        
        WKWebViewConfiguration* config = [[WKWebViewConfiguration alloc] init];
        [config setUserContentController:[webInterface getContentController]];;
        
        WKWebView* webView = [[WKWebView alloc] initWithFrame:CGRectZero
                                                configuration:config];
        
        [webView loadHTMLString:self->htmlData_ baseURL:nil];
        [webView setAllowsBackForwardNavigationGestures:true];
        [webView setTranslatesAutoresizingMaskIntoConstraints:false];
        
        [webView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
        
        [self addSubview:webView];
        
        float widthMult = (float)self->percentage_ / 100.0;
        float heightMult = (float)self->percentage_ / 100.0;
        
        float ratioMult = (float)ratio / 100.0;
        
        if (vertical == 1) {
            widthMult = ratioMult * widthMult;
        } else {
            heightMult = ratioMult * heightMult;
        }
        
        NSLayoutConstraint* withConstraint = [NSLayoutConstraint
                                              constraintWithItem:webView attribute:NSLayoutAttributeWidth
                                              relatedBy:NSLayoutRelationEqual toItem:self
                                              attribute:NSLayoutAttributeWidth multiplier:widthMult constant:0];
        
        NSLayoutConstraint* heightConstraint = [NSLayoutConstraint
                                                constraintWithItem:webView attribute:NSLayoutAttributeHeight
                                                relatedBy:NSLayoutRelationEqual toItem:self
                                                attribute:NSLayoutAttributeHeight multiplier:heightMult constant:0];
        
        NSLayoutConstraint* xConstraint = [NSLayoutConstraint
                                           constraintWithItem:webView attribute:NSLayoutAttributeCenterX
                                           relatedBy:NSLayoutRelationEqual toItem:self
                                           attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
        
        NSLayoutConstraint* yConstraint = [NSLayoutConstraint
                                           constraintWithItem:webView attribute:NSLayoutAttributeCenterY
                                           relatedBy:NSLayoutRelationEqual toItem:self
                                           attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
        
        [NSLayoutConstraint activateConstraints:[[NSArray alloc] initWithObjects:
                                                 withConstraint, heightConstraint,
                                                 xConstraint, yConstraint, nil]];
    }
    return self;
}

-(id)initWithCoder: (NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    return self;
}

@end
