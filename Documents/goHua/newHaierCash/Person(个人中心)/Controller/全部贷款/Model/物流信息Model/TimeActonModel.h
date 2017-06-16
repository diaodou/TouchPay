//
//  TimeActonModel.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/6/3.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@class TimeActionHead,TimeActionBody,TimeActionDetail;
@interface TimeActonModel : NSObject

@property (nonatomic, strong) TimeActionHead *head;

@property (nonatomic, strong) TimeActionBody  *body;

@end


@interface TimeActionHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface TimeActionBody : NSObject

@property (nonatomic, copy) NSString *orderSn;

@property (nonatomic, strong) NSArray<TimeActionDetail*> *lesShippingInfosList;

@end


@interface TimeActionDetail : NSObject

@property (nonatomic, copy) NSString *Id;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *orderProductId;

@property (nonatomic, copy) NSString *cOrderSn;

@property (nonatomic, copy) NSString *nodeTime;

@property (nonatomic, copy) NSString *nodeCode;

@property (nonatomic, copy) NSString *nodeDesc;

@property (nonatomic, copy) NSString *addTime;

@property (nonatomic, copy) NSString *expressName;

@property (nonatomic, copy) NSString *invoiceNumber;

@end

