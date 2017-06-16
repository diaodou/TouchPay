//
//  SawtoothView.m
//  personMerchants
//
//  Created by 百思为科 on 16/11/18.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "SawtoothView.h"
#import "HCMacro.h"
@interface SawtoothView (){
    int waveCount;
    UIColor *bgColor;
    UIColor *viewTopColor;
    CGFloat viewHeight;
}
@end

@implementation SawtoothView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)drawRect:(CGRect)rect{
#pragma mark - 第一步：获取上下文
    //获取绘图上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
#pragma mark - 第二步：构建路径
//    if (waveCount <= 0) {
        waveCount = 60;//默认30个
//    }
    
    //单个波浪线的宽度
    CGFloat itemWidth = DeviceWidth/waveCount;
    //单个波浪线的高度
    CGFloat itemHeight = 5;
    //整个view的大小
    if (viewHeight <= 0) {
        viewHeight = 50;//默认50大小
    }
    
    //背景色
    if (bgColor == nil) {
        bgColor = [UIColor blackColor];
    }
    
    if (viewTopColor == nil) {
        viewTopColor = [UIColor orangeColor];
    }
    
    //移动到起始点,从左上画到右上
    CGContextMoveToPoint(ctx, 0, 0);
//    for (int i = 0; i<waveCount; i++) {
//        int nextX = (i+1)*itemWidth;
//        
//        CGContextAddLineToPoint(ctx, nextX - itemWidth*0.5, 0);
//        CGContextAddLineToPoint(ctx, nextX, itemHeight);
//    }
    CGContextAddLineToPoint(ctx, DeviceWidth, 0);
    //右上移动到右下角
    CGContextAddLineToPoint(ctx, DeviceWidth, viewHeight - itemHeight);
    
    //右下角画到左下角
    for(int i = waveCount+1;i > 0;i--){
        int preX = (i-1)*itemWidth;
        CGContextAddLineToPoint(ctx, preX - itemWidth*0.5, viewHeight);
        CGContextAddLineToPoint(ctx, preX - itemWidth, viewHeight - itemHeight);
    }
    
#pragma mark - 第三步：将路径画到view上
    //    CGContextSetRGBFillColor(ctx, 1, 0, 0, 1);
    CGContextSetFillColorWithColor(ctx, bgColor.CGColor);
    CGContextFillPath(ctx);
    
    
    //开始画顶部的填充图
    CGContextMoveToPoint(ctx, 0, itemHeight);
    for (int i = 0 ; i<waveCount; i++) {
        int nextX = (i+1)*itemWidth;
        CGContextAddLineToPoint(ctx, nextX - itemWidth*0.5, 0);
        CGContextAddLineToPoint(ctx, nextX, itemHeight);
    }
    CGContextSetFillColorWithColor(ctx, viewTopColor.CGColor);
    CGContextAddLineToPoint(ctx, DeviceWidth, 0);
    CGContextAddLineToPoint(ctx, 0, 0);
    CGContextFillPath(ctx);
}

/**
 *  设置波浪线背景颜色、波浪个数、波浪view的高度
 *
 *  @param color  颜色
 *  @param topColor 顶部颜色
 *  @param count  波浪个数
 *  @param height 波浪高度
 */
-(void)setColor:(UIColor *)color topColor:(UIColor *)topColor waveCount:(int)count waveHeight:(CGFloat)height{
    bgColor = color;
    waveCount = count;
    viewHeight = height;
    viewTopColor = topColor;
    
    [self setNeedsDisplay];
}

@end

