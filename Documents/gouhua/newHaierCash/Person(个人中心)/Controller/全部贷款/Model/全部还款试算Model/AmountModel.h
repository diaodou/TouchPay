//
//  AmountModel.h
//  personMerchants
//
//  Created by 张久健 on 16/7/25.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AmountModelHead,AmountModelBody;
@interface AmountModel : NSObject

@property (nonatomic, strong) AmountModelHead *head;

@property (nonatomic, strong) AmountModelBody *body;

@end
@interface AmountModelHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface AmountModelBody : NSObject

@property (nonatomic, copy) NSString *zdhkFee;

@property (nonatomic, copy) NSString *ze;

@property (nonatomic, copy) NSString *bj;

@property (nonatomic, copy) NSString *sxf;

@property (nonatomic, copy) NSString *xf;

@property (nonatomic, copy) NSString *zdhkXf;

@end
