//
//  CompanyModel.m
//  personMerchants
//
//  Created by 张久健 on 16/5/7.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "CompanyModel.h"
#import <MJExtension.h>

@implementation CompanyModel
MJCodingImplementation
@end
@implementation CompanyHead
MJCodingImplementation
@end


@implementation CompanyBody
MJCodingImplementation
- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property {
    if ([property.name isEqualToString:@"officeTel"]) {
        if (oldValue == nil) {
            return @"";
        }else {
            NSString *strOld = (NSString *)oldValue;
            NSString *strNew = [strOld stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSString *strLast = [strNew stringByReplacingOccurrencesOfString:@" " withString:@""];
            return strLast;
        }
    }
    return oldValue;
}
@end


