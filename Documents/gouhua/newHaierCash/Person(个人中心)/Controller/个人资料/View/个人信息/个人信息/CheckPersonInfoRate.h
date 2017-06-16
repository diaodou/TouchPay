//
//  CheckPersonInfoRate.h
//  personMerchants
//
//  Created by 张久健 on 16/6/3.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyModel.h"
#import "PersonalMessageModel.h"
#import "contectModel.h"
#import "HouseModel.h"
#import "LoanTypeModel.h"
#import "InquiryModel.h"
#import "CityRangeModel.h"

@class PeopleViewController;

@interface CheckPersonInfoRate : NSObject

@property(nonatomic,assign)BOOL ifFromTE;//是否来自提额

//判断单位信息是否完善
- (BOOL)isCompanyCompeleteWithModel:(CompanyModel *)model;
//判断个人信息是否完善
- (BOOL)isPersonCopeleteWithModel:(PersonalMessageModel *)model;

//判断联系人信息是否完善
- (BOOL)isContactCompeleteWithModel:(contectModel *)model;
//判断房产信息是否完善
-(BOOL)isHouseCompeleteWithModel:(HouseModel *)model;

//
- (LoanTypeInfo *)selectWithD:(int) dTime withData:(LoanTypeModel *)model;

//天数 还款方式  确定贷款品种
- (LoanTypeInfo *)selectWithDWithType:(int) dTime with:(NSString *)strType withData:(LoanTypeModel *)model withTypCde:(NSString *)TypCde;

- (NSArray *)selectType:(int )dTime withData:(LoanTypeModel *)model;

- (NSArray *)selectTypeCde:(int )dTime withData:(LoanTypeModel *)model;


- (LoanTypeInfo *)selectWithM:(int) mTime withData:(LoanTypeModel *)model;

//月数 还款方式  确定贷款品种
- (LoanTypeInfo *)selectWithMWithType:(int) mTime with:(NSString *)strType withData:(LoanTypeModel *)model withTypCde:(NSString *)TypCde;

- (NSArray *)selectMType:(int )mTime withData:(LoanTypeModel *)model;

- (NSArray *)selectMTypeCde:(int )mTime withData:(LoanTypeModel *)model;

/*
 扫码分期  //LoanTypeInfo           商品    InquiryLoan
 */

- (NSArray *)arrCanLoan:(NSArray *)soureLoans shoppingLoans:(NSArray *)shoppingLoans;


- (NSArray *)arrSynalize:(NSArray *)loanModel;

- (BOOL)checkAllowCity:(NSString *)strCityCode provinceCity:(NSString *)strProvinceCode arrowInfo:(CityRangeModel *)model;

//根据贷款品种
- (NSArray *)arrSynalizeSomeLoan:(NSArray *)loanModel loanType:(LoanTypeInfo *)someLoan;

@end
