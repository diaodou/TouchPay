//
//  WaitComNumberModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/8.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WaitComNumberHead,WaitComNumberBody;
@interface WaitComNumberModel : NSObject


@property (nonatomic, strong) WaitComNumberHead *head;

@property (nonatomic, strong) WaitComNumberBody *body;


@end
@interface WaitComNumberHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface WaitComNumberBody : NSObject

@property (nonatomic, assign) NSInteger orderSize;

@end

