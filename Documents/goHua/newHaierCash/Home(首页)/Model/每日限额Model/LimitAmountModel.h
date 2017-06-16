//
//  LimitAmountModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/1.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LimitAmountHead,LimitAmountBody;
@interface LimitAmountModel : NSObject


@property (nonatomic, strong) LimitAmountHead *head;

@property (nonatomic, strong) LimitAmountBody *body;


@end
@interface LimitAmountHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface LimitAmountBody : NSObject

@property (nonatomic, copy) NSString *flag;

@end

