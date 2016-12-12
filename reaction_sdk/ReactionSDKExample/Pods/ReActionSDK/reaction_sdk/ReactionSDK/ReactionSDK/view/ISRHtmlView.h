//
//  ISReactionHtmlView.h
//  ReactionSDKExample
//
//  Created by g8y3e on 11/11/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    IS_ORIENTATION_PORTRAIT,
    IS_ORIENTATION_LANDSCAPE
} ISRViewOrientation;

@interface ISRHtmlView : UIView
{
    ISRViewOrientation orientation_;
    NSString* htmlData_;
    int percentage_;
}

-(id)initWithHtmlData: (NSString*)data percentage: (int)percentage
                ratio: (int)ratio vertical: (int)vertical
          orientation: (ISRViewOrientation)orientation;

@end
