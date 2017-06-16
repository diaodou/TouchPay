//
//  SawtoothView.h
//  personMerchants
//
//  Created by 百思为科 on 16/11/18.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SawtoothView : UIView

/**
 *  设置波浪线背景颜色、波浪个数、波浪view的高度
 *
 *  @param color  颜色
 *  @param topColor 顶部颜色
 *  @param count  波浪个数
 *  @param height 波浪高度
 */
- (void)setColor:(UIColor *)color topColor:(UIColor *)topColor waveCount:(int)count waveHeight:(CGFloat)height;
@end
