//
//  PayBackBottomView.h
//  personMerchants
//
//  Created by LLM on 16/11/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayBackBottomView : UIView

@property (nonatomic,strong) UILabel *moneyLabel;//金额label

@property (nonatomic,strong) UIButton *iconButton;//小对勾

@property (nonatomic,strong) UIButton *detailBtn;//还款明细按钮

- (void)createViewWithPayBackMoney:(NSAttributedString *)money andIconAction:(SEL)iconSEl andDetailAction:(SEL)detailSel andPayBackAction:(SEL)payBackSel andObject:(NSObject *)obj;

@end
