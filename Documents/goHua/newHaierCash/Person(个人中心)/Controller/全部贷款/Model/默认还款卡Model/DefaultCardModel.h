//
//  DefaultCardModel.h
//  personMerchants
//
//  Created by 张久健 on 16/7/1.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DefaultCardHead,DefaultCardBody;
@interface DefaultCardModel : NSObject

@property (nonatomic, strong) DefaultCardHead *head;

@property (nonatomic, strong) DefaultCardBody *body;

@end
@interface DefaultCardHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface DefaultCardBody : NSObject

@property (nonatomic, copy) NSString *isRealnameCard;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *isDefaultCard;

@property (nonatomic, copy) NSString *bankCode;

@property (nonatomic, copy) NSString *cardTypeName;

@property (nonatomic, copy) NSString *cardNo;

@property (nonatomic, copy) NSString *custName;

@property (nonatomic, copy) NSString *acctProvince;

@property (nonatomic, copy) NSString *acctCity;

@property (nonatomic, copy) NSString *acctArea;

@property (nonatomic, copy) NSString *mobile;
@end

