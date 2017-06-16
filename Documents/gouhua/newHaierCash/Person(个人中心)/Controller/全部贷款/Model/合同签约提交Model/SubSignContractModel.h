//
//  SubSignContractModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SubSignContractHead,SubSignContractBody;



@interface SubSignContractModel : NSObject

@property (nonatomic, strong) SubSignContractHead *head;

@property (nonatomic, strong) SubSignContractBody *body;

@end

@interface SubSignContractHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface SubSignContractBody : NSObject

@property (nonatomic, copy) NSString *outSts;

@end

