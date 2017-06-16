//
//  CheckListModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/9/24.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CheckListHead,CheckListBody;
@interface CheckListModel : NSObject


@property (nonatomic, strong) CheckListHead *head;

@property (nonatomic, strong) CheckListBody *body;


@end
@interface CheckListHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface CheckListBody : NSObject

@property (nonatomic, copy) NSString *custNo;

@property (nonatomic, copy) NSString *crdNorAvailAmt;

@property (nonatomic, copy) NSString *crdSts;

@property (nonatomic, copy) NSString *crdComAvailAnt;

@property (nonatomic, copy) NSString *bankCode;

@property (nonatomic, copy) NSString *bdMobile;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *idNo;

@property (nonatomic, copy) NSString *custName;

@property (nonatomic, copy) NSString *crdSeq;//额度申请流水号

@property (nonatomic, copy) NSString *outSts;//额度申请状态
@end

