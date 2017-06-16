//
//  UserSettingModel.h
//  personMerchants
//
//  Created by xuxie on 16/5/10.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class UserSettingHead,UserSettingBody;
@interface UserSettingModel : NSObject

@property (nonatomic, strong) UserSettingHead *head;

@property (nonatomic, strong) UserSettingBody *body;

@end
@interface UserSettingHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface UserSettingBody : NSObject

@property (nonatomic, copy) NSString *payPasswdFlag;

@property (nonatomic, copy) NSString *gestureFlag;

@end

