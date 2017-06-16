//
//  HelpCustModel.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/5/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@class HelpHead,HelpBody,HelpData;
@interface HelpCustModel : NSObject

@property (nonatomic, strong) HelpHead *head;

@property (nonatomic, strong) HelpBody *body;

@end
@interface HelpHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface HelpBody : NSObject

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray<HelpData *> *data;

@property (nonatomic, copy) NSString *sum;

@end

@interface HelpData : NSObject

@property (nonatomic, copy) NSString *helpId;

@property (nonatomic, copy) NSString *helpTitle;

@property (nonatomic, copy) NSString *rownum;

@end

