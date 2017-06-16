//
//  HCInputPaymentPSView.m
//  newHaierCash
//
//  Created by BSVK on 2017/6/15.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCInputPaymentPSView.h"
#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIButton+UnifiedStyle.h"

@implementation HCInputPaymentPSView
{
    UILabel *_titleLabel;
    UIButton *_closeBtn;
    UILabel *_moneyTipLbl;
    UILabel *_moneyLbl;
    UILabel *_bankNameLbl;
    UILabel *_bankNumberLbl;
    UIImageView *_arrowImg;
    UIButton *_transparentBtn;
    UITextField *_paymentPSTF;
    UIButton *_confirmBtn;
    UIButton *_forgetPSBtn;
    UIView *_firstLine;
    UIView *_secondLine;
    UIView *_thirdLine;
    UIView *_fourthLine;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatUI];
    }
    return self;
}

-(void)creatUI{
//    NSArray *viewArr = @[_titleLabel,_closeBtn,_moneyTipLbl,_moneyLbl,_bankNameLbl,_bankNumberLbl,_paymentPSTF,_confirmBtn,_forgetPSBtn,_firstLine,_secondLine,_thirdLine,_fourthLine];
    CGFloat x = iphone6P ? scale6PAdapter : scaleAdapter;
    if (iphone6P) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 16, 250  , 14)];
        _titleLabel.text = @"请输入支付密码";
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _closeBtn.frame = CGRectMake(310, 16, 14, 14);
        [_closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        
        _moneyTipLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 30, 14)];
        _moneyTipLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _moneyTipLbl.text= @"金额";
        _moneyTipLbl.font = [UIFont systemFontOfSize:13*x];
        [self addSubview:_moneyTipLbl];
        
        _moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 87, 374 , 28)];
        _moneyLbl.font = [UIFont systemFontOfSize:28];
        [self addSubview:_moneyLbl];
        
        _bankNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 145 , 220, 15)];
        _bankNameLbl.font  = [UIFont systemFontOfSize:15];
        [self addSubview:_bankNameLbl];
        
        _bankNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(263, 147, 50, 13)];
        _bankNumberLbl.font = [UIFont systemFontOfSize:13];
        _bankNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        [self addSubview:_bankNumberLbl];
        
        _arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(320, 320, 13, 13)];
        _arrowImg.image = [UIImage imageNamed:@""];
        [self addSubview:_arrowImg];
        
        _transparentBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 134, 310, 36)];
        [_transparentBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
        [_transparentBtn addTarget:self action:@selector(changeBankCard:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_transparentBtn];
        
        _paymentPSTF = [[UITextField alloc]initWithFrame:CGRectMake(20,186, 310, 34)];
        _paymentPSTF.placeholder = @"请输入支付密码";
        _paymentPSTF.secureTextEntry = YES;
        _paymentPSTF.font = [UIFont systemFontOfSize:12*x];
        [self addSubview:_paymentPSTF];
        
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 255, 270, 50)];
        [_confirmBtn setBackgroundColor:[UIColor UIColorWithHexColorString:@"#32beff" AndAlpha:1]];
        _confirmBtn.titleLabel.textColor = [UIColor whiteColor];
        [_confirmBtn setButtonTitle:@"确认" titleFont:14 buttonHeight:50];
        [self addSubview:_confirmBtn];
        
        _forgetPSBtn = [[UIButton alloc]initWithFrame:CGRectMake(145, 320, 60, 12)];
        _forgetPSBtn.titleLabel.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _forgetPSBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _forgetPSBtn.titleLabel.text = @"忘记密码?";
        [self addSubview:_forgetPSBtn];
        
        _firstLine = [[UIView alloc]initWithFrame:CGRectMake(0, 48, self.frame.size.width, 1)];
        _firstLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        [self addSubview:_firstLine];
        
        _secondLine = [[UIView alloc]initWithFrame:CGRectMake(0 , 128, self.frame.size.width, 1)];
        _secondLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        [self addSubview:_secondLine];
        
        _thirdLine = [[UIView alloc]initWithFrame:CGRectMake(20, 178, 310, 1)];
        _thirdLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        [self addSubview:_thirdLine];
        
        _fourthLine = [[UIView alloc]initWithFrame:CGRectMake(20, 228, 310, 1)];
        _fourthLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        [self addSubview:_fourthLine];
    }else{
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50*x, 15*x, 217*x, 13*x)];
        _titleLabel.text = @"请输入支付密码";
        _titleLabel.font = [UIFont systemFontOfSize:13*x];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        _closeBtn.frame = CGRectMake(282*x, 15*x, 13*x, 13*x);
        [_closeBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        
        _moneyTipLbl = [[UILabel alloc]initWithFrame:CGRectMake(17*x, 54*x, 30, 13*x)];
        _moneyTipLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _moneyTipLbl.text= @"金额";
        _moneyTipLbl.font = [UIFont systemFontOfSize:13*x];
        [self addSubview:_moneyTipLbl];
        
        _moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(17*x, 80*x, 283*x, 25*x)];
        _moneyLbl.font = [UIFont systemFontOfSize:25*x];
        [self addSubview:_moneyLbl];
        
        _bankNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(17*x, 132*x, 180*x, 14*x)];
        _bankNameLbl.font  = [UIFont systemFontOfSize:14*x];
        [self addSubview:_bankNameLbl];
        
        _bankNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(237*x, 133*x, 48*x, 12*x)];
        _bankNumberLbl.font = [UIFont systemFontOfSize:12*x];
        _bankNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        [self addSubview:_bankNumberLbl];
        
        _arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(292*x, 133*x, 12*x, 12*x)];
        _arrowImg.image = [UIImage imageNamed:@""];
        [self addSubview:_arrowImg];
        
        _transparentBtn = [[UIButton alloc]initWithFrame:CGRectMake(17*x, 116*x, 283*x, 45*x)];
        [_transparentBtn setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
        [_transparentBtn addTarget:self action:@selector(changeBankCard:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_transparentBtn];
        
        _paymentPSTF = [[UITextField alloc]initWithFrame:CGRectMake(17*x, 170*x, 283*x, 25*x)];
        _paymentPSTF.placeholder = @"请输入支付密码";
        _paymentPSTF.secureTextEntry = YES;
        _paymentPSTF.font = [UIFont systemFontOfSize:12*x];
        [self addSubview:_paymentPSTF];
        
        _confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(35*x, 230*x, 247*x, 45*x)];
        [_confirmBtn setBackgroundColor:[UIColor UIColorWithHexColorString:@"#32beff" AndAlpha:1]];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:13*x];
        _confirmBtn.titleLabel.textColor = [UIColor whiteColor];
        [_confirmBtn setButtonTitle:@"确认" titleFont:13*x buttonHeight:45*x];
        [self addSubview:_confirmBtn];
        
        _forgetPSBtn = [[UIButton alloc]initWithFrame:CGRectMake(132*x, 290*x, 52*x, 11*x)];
        _forgetPSBtn.titleLabel.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        _forgetPSBtn.titleLabel.font = [UIFont systemFontOfSize:12*x];
        _forgetPSBtn.titleLabel.text = @"忘记密码?";
        [self addSubview:_forgetPSBtn];
        
        _firstLine = [[UIView alloc]initWithFrame:CGRectMake(0, 43*x, self.frame.size.width, 1)];
        _firstLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        [self addSubview:_firstLine];
        
        _secondLine = [[UIView alloc]initWithFrame:CGRectMake(0 , 116*x, self.frame.size.width, 1)];
        _secondLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        [self addSubview:_secondLine];
        
        _thirdLine = [[UIView alloc]initWithFrame:CGRectMake(17*x, 160*x, 283*x, 1)];
        _thirdLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        [self addSubview:_thirdLine];
        
        _fourthLine = [[UIView alloc]initWithFrame:CGRectMake(17*x, 205*x, 283*x, 1)];
        _fourthLine.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        [self addSubview:_fourthLine];
    }
    
    
}

-(void)closeView:(UIButton *)sender{
    [self.superview removeFromSuperview];
}

-(void)changeBankCard:(UIButton *)sender{
    NSLog(@"更换银行卡");
}

-(void)setViewData{
    _moneyLbl.text = @"¥ 50000.00";
    _bankNameLbl.text = @"招商银行";
    _bankNumberLbl.text = @"**9870";
}

@end
