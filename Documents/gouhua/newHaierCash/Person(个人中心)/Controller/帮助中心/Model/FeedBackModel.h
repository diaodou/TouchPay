//
//  FeedBackModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/25.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FeedBackHead;
@interface FeedBackModel : NSObject

@property (nonatomic, strong) FeedBackHead *head;

@end
@interface FeedBackHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

