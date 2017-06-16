//
//  RegSetPassNumViewController.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendSuccessDelegate.h"
@interface HCRegSetPassNumViewController : UIViewController

@property(nonatomic,weak)id<SendSuccessDelegate> delegate;

@property(nonatomic,copy)NSString *verifyNo;//注册页面的验证码

@end
