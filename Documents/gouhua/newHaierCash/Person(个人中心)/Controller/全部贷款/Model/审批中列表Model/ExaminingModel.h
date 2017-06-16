//
//  ExaminingModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/5/26.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class ExaminingHead,ExaminingBody;
@interface ExaminingModel : NSObject


@property (nonatomic, strong) ExaminingHead *head;

@property (nonatomic, strong) NSArray<ExaminingBody *> *body;


@end
@interface ExaminingHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface ExaminingBody : NSObject

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *applyDt;

@property (nonatomic, copy) NSString *applyAmt;

@property (nonatomic, copy) NSString *applSeq;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *applyTnr;

@property (nonatomic, copy) NSString *typGrp;

@property (nonatomic, copy) NSString * mthAmt;

@property (nonatomic, copy) NSString * typLevelTwo;

@property (nonatomic, copy) NSString * applyTnrTyp;

@property (nonatomic, copy) NSString * apprvAmt;

@property (nonatomic, copy) NSString * fee;

@property (nonatomic, copy) NSString * goodsCount;

@property (nonatomic, copy) NSString * mtdDesc;

@property (nonatomic, copy) NSString * mtdCde;

@property (nonatomic, copy) NSString * custId;

@property (nonatomic, copy) NSString * status;

@property (nonatomic, copy) NSString * formTyp;
@end

