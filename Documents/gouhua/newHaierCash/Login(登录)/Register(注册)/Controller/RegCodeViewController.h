//
//  RegCodeViewController.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendSuccessDelegate.h"
@interface RegCodeViewController : UIViewController

@property(nonatomic,weak)id<SendSuccessDelegate> delegate;

@property(nonatomic,copy)NSString *verifyNo;//验证码

@property(nonatomic,copy)NSString *number;//注册手机号

@property(nonatomic,assign)BOOL ifJudgeAgainSend;//是否立即重新发送验证码

@end
