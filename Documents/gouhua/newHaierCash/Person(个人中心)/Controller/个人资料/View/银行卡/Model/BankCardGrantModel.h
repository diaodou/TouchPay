//
//  BankCardGrantModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/9/2.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GrantHead;
@interface BankCardGrantModel : NSObject


@property (nonatomic, strong) GrantHead *head;


@end
@interface GrantHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

