//
//  ChangDefaultBankView.h
//  personMerchants
//
//  Created by 百思为科 on 16/11/15.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ChangDefaultBankView : UIView

@property (nonatomic,strong)UILabel *stateLabel;//状态

@property (nonatomic,strong)UILabel *defaultBankLabel;//银行名

@property (nonatomic,strong)UILabel *bankNumberLabel;//银行卡号

@property (nonatomic,strong)UIImageView *arrow;//箭头

@property (nonatomic,strong)UIView *bottomView;//底部view

@property (nonatomic,strong)UIView *thirdView;

@property (nonatomic,strong)UIImageView *stateImage;

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)UIImageView *bottomImage;
@end
