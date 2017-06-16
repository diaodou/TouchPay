//
//  BankChoiceModel.h
//  personMerchants
//
//  Created by 张久健 on 16/5/19.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BankChoiceHead,BankChoiceBody;
@interface BankChoiceModel : NSObject

@property (nonatomic, strong) BankChoiceHead *head;

@property (nonatomic, strong) NSArray<BankChoiceBody *> *body;

@end
@interface BankChoiceHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface BankChoiceBody : NSObject

@property (nonatomic, copy) NSString *bchName;

@property (nonatomic, copy) NSString *bchCde;

@end

