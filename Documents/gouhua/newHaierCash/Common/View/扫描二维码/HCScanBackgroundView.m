//
//  HCScanBackgroundView.m
//  newHaierCash
//
//  Created by Will on 2017/6/3.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"

#import "HCScanBackgroundView.h"

@implementation HCScanBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;   //透明
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat viewWidth = DeviceHeight > DeviceWidth ? DeviceWidth :DeviceHeight;
    CGRect cleanRect = CGRectMake(viewWidth / 6, viewWidth / 6, 2 * viewWidth / 3, 2 * viewWidth / 3);
    
    [self addClearRect:cleanRect];
    [self addFourBorder:cleanRect];
    
}

//设置中间透明区域
- (void)addClearRect:(CGRect)cleanRect {
    [[UIColor colorWithWhite:0 alpha:0.1] setFill];
    CGRect mainRect = CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64);
    UIRectFill(mainRect);
    CGRect clearIntersection = CGRectIntersection(cleanRect, mainRect);
    [[UIColor clearColor] setFill];
    UIRectFill(clearIntersection);
}

//设置四个角线
- (void)addFourBorder:(CGRect)borderRect {
    CGFloat borderRectX = borderRect.origin.x;
    CGFloat borderRectY = borderRect.origin.y;
    CGFloat borderRectWidth = borderRect.size.width;

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 4);
    CGContextSetStrokeColorWithColor(ctx, [UIColor UIColorWithHexColorString:App_MainColor AndAlpha:1].CGColor);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGPoint upLeftPoints[] = {CGPointMake(borderRectX, borderRectY), CGPointMake(borderRectX + 20, borderRectY), CGPointMake(borderRectX, borderRectY), CGPointMake(borderRectX, borderRectY + 20)};
    CGPoint upRightPoints[] = {CGPointMake(5 * borderRectX - 20, borderRectY), CGPointMake(5 * borderRectX, borderRectY), CGPointMake(5 * borderRectX, borderRectY), CGPointMake(5 * borderRectX, borderRectY + 20)};
    CGPoint belowLeftPoints[] = {CGPointMake(borderRectX, borderRectY + borderRectWidth), CGPointMake(borderRectX, borderRectY + borderRectWidth - 20), CGPointMake(borderRectX, borderRectY + borderRectWidth), CGPointMake(borderRectX +20, borderRectY + borderRectWidth)};
    CGPoint belowRightPoints[] = {CGPointMake(5 * borderRectX, borderRectY + borderRectWidth), CGPointMake(5 * borderRectX - 20, borderRectY + borderRectWidth), CGPointMake(5 * borderRectX, borderRectY + borderRectWidth), CGPointMake(5 * borderRectX, borderRectY + borderRectWidth - 20)};
    CGContextStrokeLineSegments(ctx, upLeftPoints, 4);
    CGContextStrokeLineSegments(ctx, upRightPoints, 4);
    CGContextStrokeLineSegments(ctx, belowLeftPoints, 4);
    CGContextStrokeLineSegments(ctx, belowRightPoints, 4);
}
@end
