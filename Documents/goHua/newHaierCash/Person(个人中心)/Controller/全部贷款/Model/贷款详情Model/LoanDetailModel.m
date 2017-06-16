//
//  LoanDetailModel.m
//  personMerchants
//
//  Created by 张久健 on 16/6/1.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "LoanDetailModel.h"

@implementation LoanDetailModel

@end

@implementation LoanDetailHead

@end


@implementation LoanDetailBody

+ (NSDictionary *)objectClassInArray{
    return @{@"goods" : [LoanGoods class]};
}

@end


@implementation LoanGoods

@end
