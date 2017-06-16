//
//  TimeActonModel.m
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/6/3.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "TimeActonModel.h"

@implementation TimeActonModel

@end


@implementation TimeActionHead

@end


@implementation TimeActionBody

+ (NSDictionary *)objectClassInArray{
    return @{@"lesShippingInfosList" : [TimeActionDetail class]};
}

@end

@implementation TimeActionDetail

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id",
             };
}

@end



