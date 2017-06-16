//
//  DeleteModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/5/17.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DeleteHead,DeleteBody;
@interface DeleteModel : NSObject


@property (nonatomic, strong) DeleteHead *head;

@property (nonatomic, strong) DeleteBody *body;


@end
@interface DeleteHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface DeleteBody : NSObject

@property (nonatomic, copy) NSString *msg;

@end

