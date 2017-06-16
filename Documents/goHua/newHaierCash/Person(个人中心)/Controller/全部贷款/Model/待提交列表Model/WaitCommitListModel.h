//
//  WaitCommitListModel.h
//  personMerchants
//
//  Created by xuxie on 16/5/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WaitCommitListHead,WaitCommitListBoby,WaitCommitListOrders;
@interface WaitCommitListModel : NSObject

@property (nonatomic, strong) WaitCommitListHead *head;

@property (nonatomic, strong) WaitCommitListBoby *body;

@end
@interface WaitCommitListHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface WaitCommitListBoby : NSObject

@property (nonatomic, strong) NSArray<WaitCommitListOrders *> *orders;

@end

@interface WaitCommitListOrders : NSObject

@property (nonatomic, copy) NSString *applyAmt;

@property (nonatomic, copy) NSString *applyTnr;

@property (nonatomic, copy) NSString *applyTnrTyp;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *mthAmt;

@property (nonatomic, copy) NSString * applyDt;

@property (nonatomic, copy) NSString * applSeq;

@property (nonatomic, copy) NSString * typGrp;

@property (nonatomic, copy) NSString * goodsCount;

@property (nonatomic, copy) NSString * fee;

@property (nonatomic, copy) NSString * idNo;

@property (nonatomic, copy) NSString * cooprCde;

@property (nonatomic, copy) NSString * formTyp;
@end

