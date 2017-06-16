//
//  IntegralModel.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class IntegralHead,IntegralBody;
@interface IntegralModel : NSObject

@property(nonatomic,strong)IntegralHead *head;

@property(nonatomic,strong)NSArray <IntegralBody *> *body;

@end

@interface IntegralHead : NSObject

@property(nonatomic,copy)NSString *retFlag;

@property(nonatomic,copy)NSString *retMsg;

@end

@interface IntegralBody : NSObject

@property (nonatomic,copy)NSString *imgUrl;//优惠券图片

@property (nonatomic,copy)NSString *name;//优惠券名称

@property (nonatomic,copy)NSString *secne;//优惠券使用条件

@property (nonatomic,copy)NSString *money;//所需要的积分

@end
