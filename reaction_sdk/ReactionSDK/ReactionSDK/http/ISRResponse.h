//
//  ISResponse.h
//  AtomSDKExample
//
//  Created by g8y3e on 11/1/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISRResponse : NSObject
{
    NSString* error_;
    NSString* data_;
    long status_;
}
/**
 *  Description of error
 */
@property NSString* error;

/**
 *  Response data from server
 */
@property NSString* data;

/**
 *  Response code from server
 */
@property long status;

/**
 *  Response constructor
 *
 *  @param data   Description of error
 *  @param error  Response data from server
 *  @param status Code from server
 *
 *  @return ISResponse
 */
-(id)initWithData: (NSString*) data error: (NSString*)error
           status: (long) status;

@end
