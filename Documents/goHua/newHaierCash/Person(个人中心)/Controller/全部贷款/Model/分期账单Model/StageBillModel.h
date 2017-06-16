//
//  StageBillModel.h
//  personMerchants
//
//  Created by 张久健 on 16/6/11.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@class StageBillModelHead,StageBillModelBody;
@interface StageBillModel : NSObject

@property (nonatomic, strong) StageBillModelHead *head;

@property (nonatomic, strong) NSArray<StageBillModelBody *> *body;

@end
@interface StageBillModelHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface StageBillModelBody : NSObject

@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *setlInd;

@property (nonatomic, assign) float odAmt;

@property (nonatomic, assign) NSInteger psPerdNo;

@property (nonatomic, assign) NSInteger days;

@property(nonatomic,copy)   NSString *odInt;//是否逾期 Y 逾期  N 未逾期

@property(nonatomic,assign) BOOL selected;//记录model是否被点击

@end

