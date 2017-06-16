//
//  OrderCommitModel.h
//  personMerchants
//
//  Created by 张久健 on 16/6/5.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderCommitHead,OrderCommitBody;
@interface OrderCommitModel : NSObject

@property (nonatomic, strong) OrderCommitHead *head;

@property (nonatomic, strong) OrderCommitBody *body;

@end
@interface OrderCommitHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface OrderCommitBody : NSObject

@property (nonatomic, copy) NSString *applSeq;

@property (nonatomic, copy) NSString *applCde;

@end



