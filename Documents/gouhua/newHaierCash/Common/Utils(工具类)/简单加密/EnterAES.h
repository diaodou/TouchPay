//
//  EnterAES.h
//  TEST
//
//  Created by xuxie on 16/6/19.
//  Copyright © 2016年 xuxie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnterAES : NSObject
+ (NSString *)simpleEncrypt:(NSString *)strSource;  //加密

+ (NSString *)simpleDecrypt:(NSString *)strSource;
@end
