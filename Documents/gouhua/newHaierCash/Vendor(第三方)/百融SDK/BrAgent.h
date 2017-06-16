//
//  BrAgent.h
//  BrMobileSDK
//
//  Created by dd on 15/6/17.
//  Copyright (c) 2015年 dd. All rights reserved.
//



#import <Foundation/Foundation.h>

//
//
//
typedef void (^actionBlock)(NSError* error, id feedback);
//typedef void (^actionBlock)(id feedback);



@interface BrAgent : NSObject {
    
}

//
//  v1.0
//


+ (NSError*) onFraud: (NSMutableDictionary*)fraudInfo completion: (actionBlock) block;

+ (void) setTimeoutInterval:(double) timeoutInterval;

+ (void) brInit:(NSString*) cid;
@end
