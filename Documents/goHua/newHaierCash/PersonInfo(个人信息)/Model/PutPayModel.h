//
//  PutPayMentModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/5/6.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PutPayHead,PutPayBody;
@interface PutPayModel : NSObject

@property (nonatomic, strong) PutPayHead *head;

@property (nonatomic, strong) PutPayBody *body;

@end

@interface PutPayHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface PutPayBody : NSObject

@property (nonatomic, copy) NSString *applSeq;

@property (nonatomic, copy) NSString *outSts;

@end

