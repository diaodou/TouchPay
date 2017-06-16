//
//  ConfirmPayViewController.h
//  personMerchants
//
//  Created by 陈相孔 on 16/3/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmPayViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *parmAray;

@property(nonatomic,copy) NSString *loanNo;//借据号
@property(nonatomic,copy) NSString*totalAmt;//总额
@property(nonatomic,copy) NSString *payMode;//还款模式
@property(nonatomic,copy) NSString *parmCard;//卡号
@property(nonatomic,copy) NSString *bankTyp;//卡类型
@property(nonatomic,copy) NSString *bankName;//卡名
@end
