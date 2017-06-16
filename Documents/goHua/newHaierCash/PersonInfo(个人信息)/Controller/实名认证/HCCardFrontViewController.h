//
//  HCCardFrontViewController.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/6.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendSuccessDelegate.h"
#import "HCBaseViewController.h"
@interface HCCardFrontViewController : UIViewController

@property(nonatomic,weak)id<SendSuccessDelegate> delegate;

@property(nonatomic,strong)NSMutableDictionary *cardDictionary;//身份证正面信息存储字典

@end
