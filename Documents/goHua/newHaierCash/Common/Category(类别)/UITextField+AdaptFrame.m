//
//  UITextField+AdaptFrame.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "UITextField+AdaptFrame.h"
#import "AppDelegate.h"
#import "HCMacro.h"
@implementation UITextField (AdaptFrame)

//添加frame通知
-(void)addKeyBoardFrame{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buildChangeKeyBoardFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
}

//去除frame通知
-(void)closeKeyBoardFrame{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

//frame通知变化所调用的方法
-(void)buildChangeKeyBoardFrame:(NSNotification *)tion{
    
    NSDictionary *dic = [tion userInfo];

    //键盘停止后的frame
    CGRect keyboardEndFrame = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //获得当前视图的view
    
    NSArray *array = [AppDelegate delegate].window.subviews;
    
    UIView *view = [array lastObject];
    
    //获得当前textField相对于视图的
    CGRect selfFrameFromUIWindow = [self convertRect:self.bounds toView:[AppDelegate delegate].window];
    
    //获得当前textField到屏幕底部的距离
    
    if (keyboardEndFrame.origin.y < (selfFrameFromUIWindow.origin.y+selfFrameFromUIWindow.size.height)) {
        
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(0, keyboardEndFrame.origin.y-(selfFrameFromUIWindow.origin.y+selfFrameFromUIWindow.size.height), DeviceWidth, DeviceHeight);
        }];
        
    }else{
       
        [UIView animateWithDuration:0.5 animations:^{
            view.frame = CGRectMake(0,0, DeviceWidth, DeviceHeight);
        }];
  
        
    }
    
}

@end
