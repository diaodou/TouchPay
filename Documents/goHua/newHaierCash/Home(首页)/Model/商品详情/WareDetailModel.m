//
//  WareDetailModel.m
//  personMerchants
//
//  Created by 史长硕 on 2017/4/24.
//  Copyright © 2017年 海尔金融. All rights reserved.
//


#import "WareDetailModel.h"


@implementation WareDetailModel

@end

@implementation WareDetailBody

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
            @"stores":[WareDetailStores class],
            @"pics":[WareDetailPics class],
            @"menus":[WareDetailMenus class],
            @"loans":[WareDetailLoan class],
            };
}

@end

@implementation WareDetailHead


@end

@implementation WareDetailStores


@end

@implementation WareDetailMenus

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id",
            };
}


@end

@implementation WareDetailPerNo



@end

@implementation WareDetailLoan

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"psPerdNo":[WareDetailPerNo class],
             };
}

@end

@implementation WareDetailGood

@end

@implementation WareDetailPics


@end
