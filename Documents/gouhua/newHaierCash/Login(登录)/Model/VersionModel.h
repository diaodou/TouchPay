//
//  VersionModel.h
//  personMerchants
//
//  Created by xuxie on 16/6/8.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VersionModelHead,VersionModelBody;
@interface VersionModel : NSObject

@property (nonatomic, strong) VersionModelHead *head;

@property (nonatomic, strong) VersionModelBody *body;

@end
@interface VersionModelHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface VersionModelBody : NSObject

@property (nonatomic, assign) BOOL hasNewer;   //是否有更新版本

@property (nonatomic, copy) NSString *lastVersion; //最新版本号

@property (nonatomic, assign) BOOL isForcedUpdate; //是否强制更新

@property (nonatomic, copy) NSString *updateAddress; //更新地址

@property (nonatomic, copy) NSString *beginTime; //开始时间

@property (nonatomic, copy) NSString *endTime; //结束时间

@property (nonatomic, copy) NSString *isFix; //是否系统维护

@end

