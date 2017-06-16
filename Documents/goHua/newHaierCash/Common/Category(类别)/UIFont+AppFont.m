//
//  UIFont+AppFont.m
//  personMerchants
//
//  Created by Will on 16/3/24.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "HCMacro.h"

#import "UIFont+AppFont.h"

@implementation UIFont (AppFont)
//传入字体大小获取自定制字体
+ (UIFont *)appFontRegularOfSize:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:fontSize];
    return font;
}

+ (UIFont *)appFontBoldOfSize:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:@"FZLanTingHeiS-B-GB" size:fontSize];
    return font;
}

//根据像素大小获取自定制字体
+ (UIFont *)appFontRegularOfSizePx:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:@"FZLanTingHeiS-R-GB" size:[UIFont getFontSizeFromPx:fontSize]];
    return font;
}
+ (UIFont *)appFontBoldOfSizePx:(CGFloat)fontSize {
    UIFont *font = [UIFont fontWithName:@"FZLanTingHeiS-B-GB" size:[UIFont getFontSizeFromPx:fontSize]];
    return font;
}

//根据像素大小获取系统字体
+ (UIFont *)appFontRegularOfSizePxSys:(CGFloat)fontSize {
    UIFont *font = [UIFont systemFontOfSize:[UIFont getFontSizeFromPx:fontSize]];
    return font;
}

+ (UIFont *)appFontBoldOfSizePxSys:(CGFloat)fontSize {
    UIFont *font = [UIFont boldSystemFontOfSize:[UIFont getFontSizeFromPx:fontSize]];
    return font;
}


+ (CGFloat)getFontSizeFromPx:(CGFloat)px {
    if (px <= 0) {
        return 0;
    }
    CGFloat fontSize = (px / 96) * 72;
    if (IPHONE4 && fontSize > 2) {
        return fontSize - 2;
    }
    return fontSize;

}

@end
