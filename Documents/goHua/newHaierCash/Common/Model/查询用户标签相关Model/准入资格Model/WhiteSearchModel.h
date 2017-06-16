//
//  WhiteSearchModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/4.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WhiteSearchHead,WhiteSearchBody;
@interface WhiteSearchModel : NSObject


@property (nonatomic, strong) WhiteSearchHead *head;

@property (nonatomic, strong) WhiteSearchBody *body;


@end
@interface WhiteSearchHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface WhiteSearchBody : NSObject

@property (nonatomic, copy) NSString *level;

@property (nonatomic, copy) NSString *isPass;

@property (nonatomic, copy) NSString *haierCredit;
@end

