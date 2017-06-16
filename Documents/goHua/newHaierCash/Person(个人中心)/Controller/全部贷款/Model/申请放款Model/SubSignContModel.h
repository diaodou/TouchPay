//
//  SubSignContModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/17.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SubSignContHead,SubSignContBody;

@interface SubSignContModel : NSObject

@property (nonatomic, strong) SubSignContHead *head;

@property (nonatomic, strong) SubSignContBody *body;

@end

@interface SubSignContHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface SubSignContBody : NSObject

@property (nonatomic, copy) NSString *outSts;

@end

