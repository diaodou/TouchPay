//
//  ChangeDefaultBankModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/11/15.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChangeDefaultBankHead;

@interface ChangeDefaultBankModel : NSObject

@property (nonatomic, strong) ChangeDefaultBankHead *head;

@end


@interface ChangeDefaultBankHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end



