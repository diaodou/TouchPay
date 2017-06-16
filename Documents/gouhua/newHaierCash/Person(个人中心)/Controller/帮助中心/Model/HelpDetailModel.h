//
//  HelpDetailModel.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/5/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HelpDetailHead,HelpDetailBody;
@interface HelpDetailModel : NSObject

@property (nonatomic, strong) HelpDetailHead *head;

@property (nonatomic, strong) HelpDetailBody *body;

@end
@interface HelpDetailHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface HelpDetailBody : NSObject

@property (nonatomic, copy) NSString *helpId;

@property (nonatomic, copy) NSString *helpContent;

@property (nonatomic, assign) long long manageTime;

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *userAlias;

@property (nonatomic, copy) NSString *helpType;

@property (nonatomic, copy) NSString *helpLabel;

@property (nonatomic, copy) NSString *visitTimes;

@property (nonatomic, copy) NSString *helpTitle;

@property (nonatomic, copy) NSString *state;

@end

