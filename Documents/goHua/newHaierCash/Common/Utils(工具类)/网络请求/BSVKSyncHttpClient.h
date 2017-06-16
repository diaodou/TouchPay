//
//  BSVKSyncHttpClient.h
//  HaiercashMerchantsAPP
//
//  Created by xuxie on 16/4/27.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, httpMethods) {
    getMothed,
    postMethod,
    putMethod
};

@interface BSVKSyncHttpClient : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>


- (NSDictionary *)sendPutRequest:(NSString *)strUrl postData:(NSDictionary *)dictParam httpMethod:(httpMethods)method;

@end
