//
//  UIColor+DefineNew.h
//  newHaierCash
//
//  Created by Will on 2017/5/25.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (DefineNew)

+ (UIColor *)UIColorWithHexColorString:(NSString *)hexColorString AndAlpha:(CGFloat)alpha;

+ (UIColor *)UIColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;



@end
