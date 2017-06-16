//
//  EnterAES.m
//  TEST
//
//  Created by xuxie on 16/6/19.
//  Copyright © 2016年 xuxie. All rights reserved.
//

#import "EnterAES.h"

@implementation EnterAES
+ (NSString *)simpleEncrypt:(NSString *)strSource {
    NSData *dataSource = [strSource dataUsingEncoding:NSUTF8StringEncoding];
    Byte *testByte = (Byte*)[dataSource bytes];
    
    for (int i = 0; i < dataSource.length; ++i) {
        testByte[i] = (Byte)~testByte[i];
    }
    int half = (int)dataSource.length / 2;
    for (int i = 0; i < half; i ++) {
        if (i % 2 == 1) {
            //奇数位调换
            Byte b = testByte[i];
            testByte[i] = testByte[i + half];
            testByte[i + half] = b;
        }
    }
    NSData *dataDest = [[NSData alloc] initWithBytes:testByte length:dataSource.length];
    NSString *strDest = [dataDest base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    return strDest;
    
}
+ (NSString *)simpleDecrypt:(NSString *)strSource {
    NSData *dataSource = [[NSData alloc]
                          initWithBase64EncodedString:strSource options:0];
    Byte *testByte = (Byte*)[dataSource bytes];
    int half = (int)dataSource.length / 2;
    for (int i = 0; i < half; i ++) {
        if (i % 2 == 1) {
            //奇数位调换
            Byte b = testByte[i];
            testByte[i] = testByte[i + half];
            testByte[i + half] = b;
        }
    }
    //按位取反
    for (int i = 0; i < dataSource.length; i++) {
        testByte[i] = (Byte)~testByte[i];
    }
    
    NSString *strDest = [[NSString alloc]initWithBytes:testByte length:dataSource.length encoding:NSUTF8StringEncoding];
    return strDest;
}
@end
