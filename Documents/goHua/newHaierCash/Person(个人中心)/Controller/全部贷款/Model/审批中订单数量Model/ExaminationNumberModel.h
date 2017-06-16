//
//  ExaminationNumberModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/8.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExaminationNumberHead,ExaminationNumberBody;
@interface ExaminationNumberModel : NSObject


@property (nonatomic, strong) ExaminationNumberHead *head;

@property (nonatomic, strong) ExaminationNumberBody *body;


@end
@interface ExaminationNumberHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface ExaminationNumberBody : NSObject

@property (nonatomic, assign) NSInteger odCount;  //逾期

@property (nonatomic, assign) NSInteger sendCount; //待发货

@property (nonatomic, assign) NSInteger backCount; //被退回

@property (nonatomic, assign) NSInteger applCount; //审批

@property (nonatomic, assign) NSInteger rejectCount; //被拒绝

@property (nonatomic, assign) NSInteger contCount;  //合同签订中

@property (nonatomic, assign) NSInteger repayCount; //待还款
@end

