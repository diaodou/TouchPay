//
//  AllLoanModel.m
//  personMerchants
//
//  Created by 百思为科 on 16/5/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "AllLoanModel.h"

@implementation AllLoanModel

@end
@implementation AllLoanHead

@end


@implementation AllLoanBody

+ (NSDictionary *)objectClassInArray{
    return @{@"orders" : [AllLoanOrders class]};
}

@end


@implementation AllLoanOrders

@end


