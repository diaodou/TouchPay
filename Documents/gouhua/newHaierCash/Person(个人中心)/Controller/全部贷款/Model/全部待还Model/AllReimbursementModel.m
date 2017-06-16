//
//  AllReimbursementModel.m
//  personMerchants
//
//  Created by 王晓栋 on 16/5/29.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "AllReimbursementModel.h"

@implementation AllReimbursementModel

@end


@implementation AllReimbursementHead

@end


@implementation AllReimbursementBody

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"orders" : [AllReimbursementBodyItem class]
             };
}

@end



@implementation AllReimbursementBodyItem

@end

