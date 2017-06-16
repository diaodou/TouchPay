//
//  OrdeDetailsModel.m
//  personMerchants
//
//  Created by 百思为科 on 16/6/5.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "OrdeDetailsModel.h"

@implementation OrdeDetailsModel

@end
@implementation OrderDetailsHead

@end


@implementation OrderDetailsBody

+ (NSDictionary *)objectClassInArray{
    return @{@"goods" : [OrderDetailsGoods class]};
}

@end


@implementation OrderDetailsGoods

@end


