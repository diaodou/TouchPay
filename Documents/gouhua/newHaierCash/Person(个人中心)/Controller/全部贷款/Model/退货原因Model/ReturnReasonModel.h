//
//  ReturnReasonModel.h
//  personMerchants
//
//  Created by 百思为科 on 2017/4/28.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class ReturnReasonHead,ReturnReasonBody;
@interface ReturnReasonModel : NSObject

@property (nonatomic, strong) ReturnReasonHead *head;

@property (nonatomic, strong) NSArray<ReturnReasonBody *> *body;

@end

@interface ReturnReasonHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface ReturnReasonBody : NSObject

@property (nonatomic, copy) NSString *flag;

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *reason;

@end
