//
//  ShowPersonInfoViewController.h
//  HaiFu
//
//  Created by 史长硕 on 17/2/8.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendSuccessDelegate.h"
#import "HCBaseViewController.h"
#import "CheckMsgModel.h"


@interface HCShowPersonInfoViewController : UIViewController

@property(nonatomic,weak)id<SendSuccessDelegate> delegate;

@property(nonatomic,copy)NSString *certFlag;//身份证有效性

@property(nonatomic,strong)CheckMsgModel *checkMsgModel;

@property(nonatomic,copy)NSString *typCde;//贷款品种代码

-(void)sendPhoneNumBack;

@end
