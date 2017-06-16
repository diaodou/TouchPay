//
//  HCOrderViewModel.h
//  newHaierCash
//
//  Created by Will on 2017/6/15.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HCOrderViewModel : NSObject

@property (nonatomic, copy) NSString *goodsName;    //名称
@property (nonatomic, copy) NSString *goodsCode;   //商品类型
@property (nonatomic, copy) NSString *goodsModel;  //型号
@property (nonatomic, copy) NSString *goodsKind;   //类型
@property (nonatomic, copy) NSString *goodsPrice;  //商品价格
@property (nonatomic, copy) NSString *kindCode;
@property (nonatomic, copy) NSString *goodsBrand;  //品牌
@property (nonatomic, copy) NSString *brandCode;
@property (nonatomic, copy) NSString *goodsNum;   //数量
@property (nonatomic, copy) NSString *goodsMenu;  //套餐
@property (nonatomic, copy) NSString *loanMoney; //借款金额
@property (nonatomic, copy) NSString *strLoanStyle;   //分期方式 或者 还款计划
@property (nonatomic, copy) NSString *goodsAddress;  //送货地址
@property (nonatomic, copy) NSString *goodsAddressTyp;  //送货地址类型
@property (nonatomic, copy) NSString *addressStyle;  //取货方式
@property (nonatomic, copy) NSString *storeName; //门店
@property (nonatomic, copy) NSString *repayCardNum; //还款卡号
@property (nonatomic, copy) NSString *repayCardBankName; //还款银行

@end
