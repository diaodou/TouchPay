//
//  contectModel.m
//  personMerchants
//
//  Created by 张久健 on 16/5/7.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "contectModel.h"
#import <MJExtension.h>

@implementation contectModel
MJCodingImplementation

@end
@implementation ContactHead
MJCodingImplementation
@end

@implementation ContactBody
MJCodingImplementation
+ (NSDictionary *)objectClassInArray{
    return @{@"lxrList" : [ContactInfo class]};
}
@end

@implementation ContactInfo
MJCodingImplementation
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"Id":@"id"};
    
}
@end


