//
//  HouseModel.h
//  personMerchants
//
//  Created by 张久健 on 16/5/9.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HouseHead,HouseBody;
@interface HouseModel : NSObject

@property (nonatomic, strong) HouseHead *head;

@property (nonatomic, strong) HouseBody *body;

@end
@interface HouseHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface HouseBody : NSObject

@property (nonatomic, copy) NSString *custno;

@property (nonatomic, copy) NSString *liveInfo;

@property (nonatomic, copy) NSString *pptyProvince;

@property (nonatomic, copy) NSString *pptyLoanInd;

@property (nonatomic, copy) NSString *pptyLoanBank;

@property (nonatomic, copy) NSString *pptyCity;

@property (nonatomic, copy) NSString *pptyArea;

@property (nonatomic, copy) NSString *mortgagePartner;

@property (nonatomic, copy) NSString *pptyAddr;

@property (nonatomic, copy) NSString *pptyLiveInd;

@property (nonatomic, copy) NSString *pptyRighName;

@property(nonatomic, copy)  NSString *liveYear;

@property(nonatomic, copy)  NSString *pptyLoanYear;

@property(nonatomic, copy)  NSString *mortgageRatio;

@property(nonatomic, copy)  NSString *pptyAmt;


@end

