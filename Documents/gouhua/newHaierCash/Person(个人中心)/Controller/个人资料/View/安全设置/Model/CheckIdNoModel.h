//
//  CheckIdNoModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/8/18.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class CheckIdNoHead,CheckIdNoBody;
@interface CheckIdNoModel : NSObject


@property (nonatomic, strong) CheckIdNoHead *head;

@property (nonatomic, strong) CheckIdNoBody *body;


@end
@interface CheckIdNoHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface CheckIdNoBody : NSObject

@property (nonatomic, copy) NSString *flag;

@end

