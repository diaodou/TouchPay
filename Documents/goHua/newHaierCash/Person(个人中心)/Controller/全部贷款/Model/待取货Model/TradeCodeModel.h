//
//  TradeCodeModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/18.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TradeCodeHead,TradeCodeBody;
@interface TradeCodeModel : NSObject


@property (nonatomic, strong) TradeCodeHead *head;

@property (nonatomic, strong) TradeCodeBody *body;


@end
@interface TradeCodeHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface TradeCodeBody : NSObject

@property (nonatomic, copy) NSString *tradeCode;

@property (nonatomic, copy) NSString *expireTime;

@end

