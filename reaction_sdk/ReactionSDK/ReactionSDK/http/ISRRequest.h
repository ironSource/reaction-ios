//
//  ISRequest.h
//  AtomSDKExample
//
//  Created by g8y3e on 11/1/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ISRResponse.h"

typedef void (^ISRRequestCallback)(ISRResponse*);

@interface ISRRequest : NSObject <NSURLSessionDelegate>
{
    NSString* url_;
    NSString* data_;
    
    BOOL isDebug_;
    
    NSMutableDictionary<NSString*, NSString*>* headers_;
    
    ISRRequestCallback callback_;
}

/**
 *  Constructor for Request
 *
 *  @param url      For server address.
 *  @param data     For sending data.
 *  @param headers  For sending headers.
 *  @param callback For get response data.
 *  @param isDebug  For print debug info.
 *
 *  @return ISRequest
 */
-(id)initWithUrl: (NSString*)url data: (NSString*)data
         headers: (NSMutableDictionary<NSString*, NSString*>*) headers
        callback: (ISRRequestCallback)callback
         isDebug: (BOOL)isDebug;

/**
 *  Constructor for Request
 *
 *  @param url     For server address.
 *  @param data    For sending data.
 *  @param headers For sending headers.
 *  @param isDebug For print debug info.
 *
 *  @return ISRequest
 */
-(id)initWithUrl:(NSString *)url data:(NSString *)data
         headers:(NSMutableDictionary<NSString *,NSString *> *)headers
         isDebug:(BOOL)isDebug;
/**
 *  GET request to server
 */
-(void)get;

/**
 *  POST request to server
 */
-(void)post;

/**
 *  Init listener callback
 *
 *  @param callback For get response data.
 *
 */
-(void)initListener: (ISRRequestCallback)callback;

@end
