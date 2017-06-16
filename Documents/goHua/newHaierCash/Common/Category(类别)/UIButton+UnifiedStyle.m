//
//  UIButton+UnifiedStyle.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/14.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "UIButton+UnifiedStyle.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation UIButton (UnifiedStyle)

- (void)setButtonTitle:(NSString *)titleStr titleFont:(CGFloat)fontSize buttonHeight:(CGFloat)height{
    
    self.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    [self setTitle:titleStr forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont appFontRegularOfSize:fontSize];
    self.layer.cornerRadius = height/2;
    
}

@end
