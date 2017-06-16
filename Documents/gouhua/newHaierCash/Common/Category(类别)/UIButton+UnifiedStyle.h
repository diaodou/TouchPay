//
//  UIButton+UnifiedStyle.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/14.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UnifiedStyle)

/*
 标题、字体大小、按钮高度（圆角）
 */
- (void)setButtonTitle:(NSString *)titleStr titleFont:(CGFloat)fontSize buttonHeight:(CGFloat)height;
@end
