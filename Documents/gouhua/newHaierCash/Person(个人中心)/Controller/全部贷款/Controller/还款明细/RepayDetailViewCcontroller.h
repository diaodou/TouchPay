//
//  RepayDetailViewCcontroller.h
//  personMerchants
//
//  Created by LLM on 16/11/16.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RepayDetailViewCcontroller : UIViewController

@property (nonatomic,copy) NSString *payMode;    //还款方式

@property (nonatomic,copy) NSString *loanNo;     //借据号

@property (nonatomic,copy) NSString *totalAmt;   //总额

@property (nonatomic,copy) NSString *principal;  //本金

@property (nonatomic,copy) NSString *counterFee; //手续费

@property (nonatomic,copy) NSString *interest;   //利息

@property (nonatomic,assign) BOOL isOverdue;     //是否逾期

@end
