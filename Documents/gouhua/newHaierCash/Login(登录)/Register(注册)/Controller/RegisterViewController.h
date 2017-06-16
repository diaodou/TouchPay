//
//  RegisterViewController.h
//  newHaierCash
//
//  Created by 张久健 on 2017/6/1.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendSuccessDelegate.h"
@interface RegisterViewController : UIViewController
@property(nonatomic,weak)id<SendSuccessDelegate> delegate;



@end
