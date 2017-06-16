//
//  LoanBottomView.h
//  personMerchants
//
//  Created by Apple on 16/4/1.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoanBottomView : UIView

@property(nonatomic,strong)UILabel *bottomLabel;//合计
@property(nonatomic,strong)UIView *lineView;//虚线
@property(nonatomic,strong)UIButton *leftBottomButton;//左按钮
@property(nonatomic,strong)UIButton *centerBottomButton;//中按钮
@property(nonatomic,strong)UIButton *rightBottomButton;//右按钮
@property(nonatomic,strong)UIView *bottomView;//下面阴影

//    CGFloat scale;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat xSpace;
@property (nonatomic, strong) UIFont *twelfthFont;

@end
