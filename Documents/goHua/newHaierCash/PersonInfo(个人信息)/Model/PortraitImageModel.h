//
//  PortraitImageModel.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/5/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class PortraitHead,PortraitBody;
@interface PortraitImageModel : NSObject

@property (nonatomic, strong) PortraitHead *head;

@property (nonatomic, strong) NSArray<PortraitBody *> *body;

@end
@interface PortraitHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface PortraitBody : NSObject

@property (nonatomic, copy) NSString *md5;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *attachType;

@property (nonatomic, copy) NSString *attachName;

@property(nonatomic,assign)NSInteger count;

@end

