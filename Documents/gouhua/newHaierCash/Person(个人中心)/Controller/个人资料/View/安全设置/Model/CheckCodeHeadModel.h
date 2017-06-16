//
//  CheckCodeHeadModel.h
//  personMerchants
//
//  Created by 张久健 on 16/6/12.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CheckCodeHead;
@interface CheckCodeHeadModel : NSObject

@property (nonatomic, strong) CheckCodeHead *head;

@end
@interface CheckCodeHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

