//
//  CouponModel.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/12.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class CouponHead,CouponBody;
@interface CouponModel : NSObject

@property(nonatomic,strong)CouponHead *head;

@property(nonatomic,strong)NSArray <CouponBody *>* body;

@end

@interface CouponHead : NSObject

@property(nonatomic,copy)NSString *retFlag;

@property(nonatomic,copy)NSString *retMsg;

@end

@interface CouponBody : NSObject

@property(nonatomic,copy)NSString *imgType;//优惠券图片类型

@property(nonatomic,copy)NSString *type;//优惠券类型

@property(nonatomic,copy)NSString *name;//优惠券名称

@property(nonatomic,copy)NSString *condition;//优惠券使用条件

@property(nonatomic,copy)NSString *scene;//使用用途

@property(nonatomic,copy)NSString *money;//优惠券金额

@property(nonatomic,copy)NSString *time;

@end
