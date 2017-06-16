//
//  BindBankCardViewController.h
//  personMerchants
//
//  Created by 百思为科 on 16/4/6.
//  Copyright © 2016年 海尔金融. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BankLIstMode.h"
#import "HCBaseViewController.h"
@protocol SendBankNumberDelegate <NSObject>

-(void)sendBankNumber:(BOOL)number;

@end



@protocol CancelBankBindingDelegate <NSObject>

-(void)cancelBankBinding:(BOOL)number  ;

@end
@interface BindBankCardViewController : HCBaseViewController

@property(nonatomic,weak)id<SendBankNumberDelegate>delegate;

@property(nonatomic,weak)id<CancelBankBindingDelegate>cancelDelegate;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property(nonatomic,copy)NSString * cardType;

@property(nonatomic,copy)NSString * cardNumber;

@property(nonatomic,copy)NSString *provinceCode;//省 代码

@property(nonatomic,copy)NSString *cityCode;//市  代码

@property(nonatomic,copy)NSString *areaCode;//区  代码

@property(nonatomic,copy)NSString *mobie;//手机号

@end
