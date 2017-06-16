//
//  LoanTopView.h
//  personMerchants
//
//  Created by 百思为科 on 16/3/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
// 注意  6 尺寸  是115   需要比例适配

#import <UIKit/UIKit.h>

@interface LoanTopView : UIView
@property (nonatomic, strong) UILabel *labelTime; //时间
@property (nonatomic, strong) UILabel *labelState; //状态
@property (nonatomic, strong) UIImageView *viewIcon;  //图标
@property (nonatomic, strong) UILabel *labelMidContent;  //中间文字 默认隐藏
@property (nonatomic, strong) UILabel *labelTopContent; //左上 默认隐藏
@property (nonatomic, strong) UILabel *labelBottomContent; //左下 默认隐藏
@property (nonatomic, strong) UIImageView *viewArrow;  //箭头 默认隐藏
@property (nonatomic, strong) UILabel *labelRight;  //单行右侧文字 默认隐藏
@property (nonatomic,copy) NSString *orderNo;//订单号

//    CGFloat scale;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat xSpace;
@property (nonatomic, strong) UIFont *twelfthFont;

//订单类型
@property (nonatomic, copy) NSString *formTyp;
/*
 使用举例
 WEAKSELF
 loanView.arrowJump = ^(){
 STRONGSELF
 if (strongSelf) {
 
 }
 };
 
 */
- (UIView *)returnBgView;

+ (CGFloat)heightTopView;

@end
