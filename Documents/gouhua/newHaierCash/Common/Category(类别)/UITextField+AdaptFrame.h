//
//  UITextField+AdaptFrame.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (AdaptFrame)
/*
 添加frame即将变化的通知
 */
-(void)addKeyBoardFrame;

/*
 去除framr变化通知
 */

-(void)closeKeyBoardFrame;

@end
