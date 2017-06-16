//
//  HCPayCodeViewController.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/8.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendSuccessDelegate.h"
@interface HCPayCodeViewController : UIViewController

@property (nonatomic,weak)id<SendSuccessDelegate> delegate;

@property (nonatomic,copy)NSString *passWord;

@property (nonatomic,assign)BOOL ifCommitOrder;//商品贷是否直接提交订单

@end
