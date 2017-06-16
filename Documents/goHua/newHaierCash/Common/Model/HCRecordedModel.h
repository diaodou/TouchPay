//
//  HCRecordedModel.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 额度申请，提额，现金贷，商品贷信息model
 */
@interface HCRecordedModel : NSObject

@property(nonatomic,copy)NSString *bankPayMaxMoney;//银行卡单笔最大还款金额

@property (nonatomic, copy) NSString * cashMinLoanMoneyNoLimit;  //没有申请额度用户最低借款金额

@property (nonatomic, copy) NSString * cashMaxLoanMoneyNoLimit;  //没有申请额度用户最高借款金额

@property (nonatomic, copy) NSString * goodsMinLoanMoney;        // 商品最低借款金额

@property (nonatomic, copy) NSString * goodsMaxLoanMoneyNoLimit; //没有申请额度用户商品最高借款金额

@property (nonatomic, copy) NSString * goodsDefaultNum;          //商品默认的可选个数

@property (nonatomic, copy) NSString * iosupdateaddresscustomer; //ios个人版更新地址

@property (nonatomic, copy) NSString * shopOnlineMaxNum;         //线上商城商品最大数量

@property (nonatomic, copy) NSString *marryStatues;              //婚姻状况

@property (nonatomic, assign) BOOL needBackCheck;  //后台5分钟需要验证。




@end
