//
//  AddNewBankViewController.h
//  personMerchants
//
//  Created by 百思为科 on 16/4/13.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
typedef NS_ENUM(NSInteger ,BankType) {
    
    FromEditBank = 1,       //编辑银行卡
};
@protocol SendBankDelegate <NSObject>

-(void)sendBank:(NSString *)number;

@end

@interface AddNewBankViewController : HCBaseViewController

@property(nonatomic,weak)id<SendBankDelegate> bankDelegate;

@property(nonatomic,copy)NSString *bankCard;//银行卡号

@property(nonatomic,assign)BankType bankType;

@property(nonatomic,copy)NSString *provinceCode;//省 代码

@property(nonatomic,copy)NSString *cityCode;//市  代码

@property(nonatomic,copy)NSString *areaCode;//区  代码

@property(nonatomic,copy)NSString *mobile;//手机号
@end
