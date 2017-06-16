//
//  BankCodeViewController.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
typedef NS_ENUM(NSInteger, BankCodeType){

    BankEdit = 1, //编辑银行卡
};
@interface BankCodeViewController : HCBaseViewController


@property (nonatomic,assign)BankCodeType bankCodeType;

@property (nonatomic, copy)NSString *changeTel;// 手机号

@property(nonatomic,copy)NSString *bankName;//银行卡名

@property(nonatomic,copy)NSString *bankType;//银行卡类型

@property (nonatomic, copy)NSString *cardText;// 添加的银行卡号

@property (nonatomic, copy)NSString *bankNo;

@property(nonatomic,copy)NSString *provinceStr;//省

@property(nonatomic,copy)NSString *cityStr;//市

@property(nonatomic,copy)NSString *areaStr;//区
@end
