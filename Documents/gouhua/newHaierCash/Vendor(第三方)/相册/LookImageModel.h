//
//  LookImageModel.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/6/2.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class LookImageHead,LookImageBody;
@interface LookImageModel : NSObject

@property (nonatomic, strong) LookImageHead *head;

@property (nonatomic, strong) NSArray<LookImageBody *> *body;

@end
@interface LookImageHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface LookImageBody : NSObject

@property (nonatomic, copy) NSString *md5;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, copy) NSString *attachType;

@property (nonatomic, copy) NSString *attachName;

@end

