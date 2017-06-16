//
//  UITypeClass.h
//  TestC
//
//  Created by xuxie on 17/1/3.
//  Copyright © 2017年 chinaredstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShowType.h"

@interface UITypeClass : NSObject
@property (nonatomic, copy) NSString *controlShowName;
@property (nonatomic, copy) NSString *controlClassName;
@property (nonatomic, assign) BOOL canEdit;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *regular;

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *errorTip;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSArray *codeArr;     //存放对应的code,地址字段不止一个
@property (nonatomic, assign) KeyBoardType keyBoardType; //键盘类型
@property (nonatomic, assign) ShowPickViewType showType; //选择器类型
@end
