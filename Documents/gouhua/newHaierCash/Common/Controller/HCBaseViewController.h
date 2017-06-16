//
//  HCBaseViewController.h
//  newHaierCash
//
//  Created by Will on 2017/6/1.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

// 用于没有tabbar，且有navigationbar的页面
@interface HCBaseViewController : UIViewController

- (void)OnBackBtn:(UIButton *)btn;
/*
 添加UITextFieldframe即将变化的通知
 */
- (void)addKeyBoardFrameAndTextField:(UITextField *)field;
/*
 去除UITextFieldframe即将变化的通知
 */
- (void)colseKeyBoardFrameAndTextField:(UITextField *)field;

@end
