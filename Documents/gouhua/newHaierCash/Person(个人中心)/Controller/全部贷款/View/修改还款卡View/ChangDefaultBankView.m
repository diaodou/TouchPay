//
//  ChangDefaultBankView.m
//  personMerchants
//
//  Created by 百思为科 on 16/11/15.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "ChangDefaultBankView.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@implementation ChangDefaultBankView{
    int waveCount;
    UIColor *bgColor;
    UIColor *viewTopColor;
    CGFloat viewHeight;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    
    _topView = [[UIView alloc]init];
    
    _topView.frame = CGRectMake(0, 0, DeviceWidth, 40);
    
    _topView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_topView];
    
    _bottomImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 40)];
    
    _bottomImage.image = [UIImage imageNamed:@"订单页面_背景"];
    
    [_topView addSubview:_bottomImage];
    
    _stateImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 18,20)];
    
    if (iphone6P) {
        
        _stateImage.frame = CGRectMake(20, 10, 18,20);
    }
    
    _stateImage.image = [UIImage imageNamed:@"订单详情－图标"];

    [_topView addSubview:_stateImage];
    
    UILabel *fixedStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_stateImage.frame) + 5, 0, 100, 40)];
    
    fixedStateLabel.text = @"订单状态";
    
    fixedStateLabel.textColor = [UIColor whiteColor];
    
    fixedStateLabel.font = [UIFont appFontRegularOfSize:14];
    
    [_topView addSubview:fixedStateLabel];
    
    _stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth/2, 0, DeviceWidth/2 - 10, 40)];
    
    if (iphone6P) {
        
        _stateLabel.frame = CGRectMake(DeviceWidth/2, 0, DeviceWidth/2 - 20, 40);
    }
    
    _stateLabel.numberOfLines = 0;
    
    _stateLabel.textColor = [UIColor whiteColor];
    
    _stateLabel.textAlignment = NSTextAlignmentRight;
    
    _stateLabel.font = [UIFont appFontRegularOfSize:14];
    
    [_topView addSubview:_stateLabel];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), DeviceWidth, 54)];
    
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_bottomView];
    
    UILabel *fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0,50,54)];
    
    if (iphone6P) {
        
        fixedLabel.frame = CGRectMake(20,0,50,54);
    }
    
    fixedLabel.text = @"还款卡:";
    
    fixedLabel.font = [UIFont appFontRegularOfSize:14];
    
    [_bottomView addSubview:fixedLabel];
    
    _defaultBankLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fixedLabel.frame) +10, 0, 121 * scaleAdapter, 54)];
    
    _defaultBankLabel.font = [UIFont appFontRegularOfSize:14];
    
    _defaultBankLabel.textColor = UIColorFromRGB(0x999999, 1.0);
    
    [_bottomView addSubview:_defaultBankLabel];
    
    _bankNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth - 223 *scaleAdapter,0, 200 *scaleAdapter, 54)];

    if (iphone6P) {
        
        _bankNumberLabel.frame = CGRectMake(DeviceWidth - 230 *scaleAdapter,0, 200 *scaleAdapter, 54);
    }
    
    _bankNumberLabel.textAlignment = NSTextAlignmentRight;
    
    _bankNumberLabel.font = [UIFont appFontRegularOfSize:14];
    
    _bankNumberLabel.textColor = UIColorFromRGB(0x999999, 1.0);
    
    [_bottomView addSubview:_bankNumberLabel];
    //        箭头
    _arrow = [[UIImageView alloc]initWithFrame:(CGRectMake(DeviceWidth - 19, 21, 9, 12))];

    if (iphone6P) {
        
        _arrow.frame = CGRectMake(DeviceWidth - 29, 21, 9, 12);
    }
    _arrow.image = [UIImage imageNamed:@"右侧箭头"];
    
    [_bottomView addSubview:_arrow];
    
    _arrow.hidden = YES;
    
    _thirdView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bottomView.frame), DeviceWidth, 10)];
    
    _thirdView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [self addSubview:_thirdView];
}
@end
