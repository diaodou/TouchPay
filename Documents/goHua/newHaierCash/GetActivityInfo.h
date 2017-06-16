//
//  GetActivityInfo.h
//  newHaierCash
//
//  Created by xuxie on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdvertSelectModel.h"
@class HCUserModel;



@interface GetActivityInfo : NSObject
- ( AdvertSelectModel * _Nullable )getLanchActivityInfo;

//返回是否具备自动登录条件
- (BOOL)searchGestureInfo:(HCUserModel *_Nonnull)userInfo;
@end
