//
//  AllReimbursementModel.h
//  personMerchants
//
//  Created by 王晓栋 on 16/5/29.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AllReimbursementHead,AllReimbursementBody,AllReimbursementBodyItem;

@interface AllReimbursementModel : NSObject

@property (nonatomic, strong) AllReimbursementHead *head;

@property (nonatomic, strong) AllReimbursementBody *body;

@end

@interface AllReimbursementHead : NSObject

@property (nonatomic, copy) NSString *retFlag;
@property (nonatomic, copy) NSString *retMsg;

@end
@interface AllReimbursementBody : NSObject

@property (nonatomic,strong)NSArray<AllReimbursementBodyItem *> *orders;

@end

@interface AllReimbursementBodyItem : NSObject

@property (nonatomic, copy) NSString *applSeq;
@property (nonatomic, copy) NSString *loanNo;
@property (nonatomic, copy) NSString *typGrp;
@property (nonatomic, copy) NSString *applyDt;

@property (nonatomic, assign) float sybj;

@property (nonatomic, copy) NSString *goodsName;
@property (nonatomic, copy) NSString *applyTnr;
@property (nonatomic, copy) NSString *applyTnrTyp;
@property (nonatomic, copy) NSString *psDueDt;
@property (nonatomic, copy) NSString *remainDays;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *formTyp;

@end

