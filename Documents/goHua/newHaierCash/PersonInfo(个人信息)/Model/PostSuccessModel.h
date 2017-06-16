//
//  PostSuccessModel.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/6/1.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class PostSuccessHead,PostSuccessBody;
@interface PostSuccessModel : NSObject

@property(nonatomic,strong)PostSuccessHead *head;

@property(nonatomic,strong)PostSuccessBody *body;

@end


@interface PostSuccessHead : NSObject

@property(nonatomic,copy)NSString *retMsg;

@property(nonatomic,copy)NSString *retFlag;

@end

@interface PostSuccessBody : NSObject

@property(nonatomic,copy)NSString *ID;

@end