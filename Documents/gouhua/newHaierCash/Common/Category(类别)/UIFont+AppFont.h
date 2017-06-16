//
//  UIFont+AppFont.h
//  personMerchants
//
//  Created by Will on 16/3/24.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (AppFont)

//传入字体大小获取自定制字体
+ (UIFont *)appFontRegularOfSize:(CGFloat)fontSize;
+ (UIFont *)appFontBoldOfSize:(CGFloat)fontSize;

//根据像素大小获取自定制字体
+ (UIFont *)appFontRegularOfSizePx:(CGFloat)fontSize;
+ (UIFont *)appFontBoldOfSizePx:(CGFloat)fontSize;

//根据像素大小获取系统字体
+ (UIFont *)appFontRegularOfSizePxSys:(CGFloat)fontSize;
+ (UIFont *)appFontBoldOfSizePxSys:(CGFloat)fontSize;
@end
