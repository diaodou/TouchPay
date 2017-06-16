//
//  LoanTypeModel.m
//  personMerchants
//
//  Created by 百思为科 on 16/6/1.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "LoanTypeModel.h"
#import "LoanVariety.h"

@implementation LoanTypeModel

@end
@implementation LoanTypeHead

@end


@implementation LoanTypeBody

+ (NSDictionary *)objectClassInArray{
    return @{@"info" : [LoanTypeInfo class]};
}

@end


@implementation LoanTypeInfo

+ (LoanTypeInfo *)initFrom:(LoanVariety *)model {
    LoanTypeInfo *loan = [[LoanTypeInfo alloc] init];
    loan.typCde = model.body.typCde;
    loan.mtdCde = model.body.payMtd;
    loan.maxAmt = [NSString stringWithFormat:@"%ld",(long)model.body.maxAmt];
    loan.typSeq = [NSString stringWithFormat:@"%ld",(long)model.body.typSeq];
    loan.minAmt = [NSString stringWithFormat:@"%@",model.body.minAmt];
    loan.tnrOpt = model.body.tnrOpt;
    loan.tnrMaxDays = model.body.tnrMaxDays; //最大天数
    loan.mtdDesc = model.body.payMtdDesc;
    loan.typLvlCde = model.body.levelTwo;//小类代码
    
    return loan;
}

@end


