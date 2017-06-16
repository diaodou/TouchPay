//
//  ApprovalProcessModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/7.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApprovalProcessHead,ApprovalProcessBody;
@interface ApprovalProcessModel : NSObject


@property (nonatomic, strong) ApprovalProcessHead *head;

@property (nonatomic, strong) NSArray<ApprovalProcessBody *> *body;

@end
@interface ApprovalProcessHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface ApprovalProcessBody : NSObject

@property (nonatomic, copy) NSString *appConclusion;

@property (nonatomic, copy) NSString *appOutAdvice;

@property (nonatomic, copy) NSString *appConclusionDesc;

@property (nonatomic, copy) NSString *wfiNodeName;

@property (nonatomic, copy) NSString *operateTime;

@end

