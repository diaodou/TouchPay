//
//  HCMerchModel.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/8.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class HCMerchHead,HCMerchBody;
@interface HCMerchModel : NSObject

@property (nonatomic, strong) HCMerchHead *head;

@property (nonatomic, strong) NSArray<HCMerchBody *> *body;

@end

@interface HCMerchHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end


@interface HCMerchBody : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *option;

@end
