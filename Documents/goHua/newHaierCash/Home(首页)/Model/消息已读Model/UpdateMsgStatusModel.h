//
//  UpdateMsgStatusModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/26.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class MsgStatusHead;
@interface UpdateMsgStatusModel : NSObject


@property (nonatomic, strong) MsgStatusHead *head;

@end
@interface MsgStatusHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

