//
//  BankNumberViewController.h
//  personMerchants
//
//  Created by 百思为科 on 16/5/19.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
typedef NS_ENUM(NSInteger ,FromType) {
    
    FromEdit = 1,       //编辑银行卡
};
@interface BankNumberViewController : HCBaseViewController

@property(nonatomic,copy)NSString *nameText;//姓名

@property(nonatomic,copy)NSString *idText;//身份证

@property(nonatomic,copy)NSString *cardText;//卡号

@property(nonatomic,copy)NSString *bankName;//银行卡名

@property(nonatomic,copy)NSString *bankType;//银行卡类型

@property(nonatomic,copy)NSString *bankNo;

@property(nonatomic,copy)NSString *provinceCode;//省 代码

@property(nonatomic,copy)NSString *cityCode;//市  代码

@property(nonatomic,copy)NSString *areaCode;//区  代码

@property(nonatomic,copy)NSString *mobile;//手机号

@property (nonatomic,assign)FromType fromType;
@end
