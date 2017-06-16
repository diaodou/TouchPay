//
//  HCSetPayPassViewController.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/8.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendSuccessDelegate.h"
@interface HCSetPayPassViewController : UIViewController

@property (nonatomic,weak)id<SendSuccessDelegate> delegate;

@property (nonatomic,copy)NSString *passWord;

@end
