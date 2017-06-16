//
//  HCHomeHeaderView.m
//  newHaierCash
//
//  Created by Will on 2017/5/31.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import "HCHomeUserModel.h"

#import "HCHomeHeaderView.h"

@interface HCNumberInfoView : UIView {
    UILabel *_titleLbl;
    UILabel *_infoLbl;
    UILabel *_numLbl;
    
    CGFloat _viewScale;
}

- (void)generateViewWithTitle:(NSString *)title andInfo:(NSString *)info andNum:(NSString *)number andNumberColor:(NSString *)colorStr;
@end

@implementation HCNumberInfoView

- (void)generateViewWithTitle:(NSString *)title andInfo:(NSString *)info andNum:(NSString *)number andNumberColor:(NSString *)colorStr{
    _titleLbl.text = title;
    _infoLbl.text = info;
    _numLbl.text = number;
    _numLbl.textColor = [UIColor UIColorWithHexColorString:colorStr AndAlpha:1.0];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        _titleLbl = [self _generateLblWithFont:[UIFont appFontRegularOfSize:15 * _viewScale] andTextColor:[UIColor blackColor]];
        
        _infoLbl = [self _generateLblWithFont:[UIFont appFontRegularOfSize:10 * _viewScale] andTextColor:[UIColor UIColorWithHexColorString:@"#a7a7a7" AndAlpha:1]];
        
        _numLbl = [self _generateLblWithFont:[UIFont appFontRegularOfSize:14 * _viewScale] andTextColor:[UIColor blackColor]];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (iphone6P) {
        _titleLbl.frame = CGRectMake(0, 22, Width(self), 16);
        
        _infoLbl.frame =  CGRectMake(0, 55, Width(self), 11);
        
        _numLbl.frame =  CGRectMake(0, 73, Width(self), 15);
        
    } else {
        _titleLbl.frame = CGRectMake(0, 20 * _viewScale, Width(self), 16 * _viewScale);
        
        _infoLbl.frame =  CGRectMake(0, 49 * _viewScale, Width(self), 11 * _viewScale);
        
        _numLbl.frame =  CGRectMake(0, 65 * _viewScale, Width(self), 15 * _viewScale);
        
    }
    
}

- (UILabel *)_generateLblWithFont:(UIFont *)font andTextColor:(UIColor *)color {
    UILabel *lbl = [UILabel new];
    lbl.numberOfLines = 1;
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.font = font;
    lbl.textColor = color;
    
    [self addSubview:lbl];
    return lbl;
}

@end


@interface HCHomeHeaderView() {
    UIView *_headerView;
    UIImageView *_groundImgView;
    UIView *_groundView;
    UIButton *_messageBtn;
    UIButton *_scanBtn;
    UILabel *_titleLbl;
    
    UILabel *_firstInfoLbl;  //第一个信息的Lbl(海尔消费金融倾力打造/额度审批中/额度申请失败/额度退回/可用总额度（元）)
    UILabel *_secondInfoLbl;  //第二个信息的Lbl(请稍后再试/可用额度)
    
    UIButton *_logAmtBtn;    //都具有
    
    HCNumberInfoView *_moneyLeftView;
    HCNumberInfoView *_moneyPayView;
    HCNumberInfoView *_scoreNumView;
    
    UIView *_line1View;
    UIView *_line2View;
    UIView *_lineView;

    CGFloat _viewScale;
    NSString *_mark;
}


@property (nonatomic, strong) UILabel *amountAllLbl;   //第三个信息的Lbl 有额度专有(总额度)

@property (nonatomic, strong) UIButton *commitBtn;    //申请退回 特有



@end

@implementation HCHomeHeaderView

- (void)generateViewWithModel:(HCHomeUserModel *)userModel andIsRealName:(BOOL)isRealName {
    for (UIView *subview in _headerView.subviews) {
        [subview removeFromSuperview];
    }
    
    [_headerView addSubview:_groundImgView];
    [_headerView addSubview:_groundView];
    [_headerView addSubview:_messageBtn];
    [_headerView addSubview:_scanBtn];
    [_headerView addSubview:_titleLbl];
    [_headerView addSubview:_firstInfoLbl];
    if (!userModel && isRealName) {
        //未登录 isRealName = Yes 只是作为与登录未实名的用户做区别
        _firstInfoLbl.textAlignment = NSTextAlignmentCenter;
        _firstInfoLbl.font = [UIFont appFontBoldOfSizePx:20 * _viewScale];
        _firstInfoLbl.text = @"海尔消费金融倾力打造";
        
        [_logAmtBtn setTitle:@"登录" forState:UIControlStateNormal];
        _logAmtBtn.tag = buttonTypeLogin;
        _logAmtBtn.titleLabel.font = [UIFont appFontRegularOfSize:13 * _viewScale];
        [_headerView addSubview:_logAmtBtn];
        
        _firstInfoLbl.frame = CGRectMake(20 * _viewScale, 98 * _viewScale, DeviceWidth - 40 * _viewScale, 21 * _viewScale);
        
        _logAmtBtn.frame = CGRectMake((DeviceWidth - 143 * _viewScale) / 2, 130 * _viewScale, 143 * _viewScale, 32 * _viewScale);
        
        [_moneyLeftView generateViewWithTitle:@"取现" andInfo:@"可借的钱" andNum:@"暂无" andNumberColor:nil];
        [_moneyPayView generateViewWithTitle:@"还款" andInfo:@"近7日应还" andNum:@"暂无"  andNumberColor:nil];
        [_scoreNumView generateViewWithTitle:@"积分" andInfo:@"可用积分" andNum:@"暂无" andNumberColor:nil];
    } else if (!userModel && !isRealName){
        //登录未实名
        [_groundView removeFromSuperview];

        _firstInfoLbl.textAlignment = NSTextAlignmentCenter;
        _firstInfoLbl.font = [UIFont appFontBoldOfSizePxSys:24 * _viewScale];
        _firstInfoLbl.text = @"海尔消费金融倾力打造";
        
        [_logAmtBtn setTitle:@"激活额度" forState:UIControlStateNormal];
        _logAmtBtn.tag = buttonTypeActiveAmount;
        _logAmtBtn.titleLabel.font = [UIFont appFontRegularOfSizePx:18 * _viewScale];
        [_headerView addSubview:_logAmtBtn];
        
        _firstInfoLbl.frame = CGRectMake(20 * _viewScale, 90 * _viewScale, DeviceWidth - 40 * _viewScale, 25 * _viewScale);
        
        _logAmtBtn.frame = CGRectMake((DeviceWidth - 143 * _viewScale) / 2, 130 * _viewScale, 143 * _viewScale, 32 * _viewScale);
        [_moneyLeftView generateViewWithTitle:@"取现" andInfo:@"可借的钱" andNum:@"暂无" andNumberColor:nil];
        [_moneyPayView generateViewWithTitle:@"还款" andInfo:@"近7日应还" andNum:@"暂无"  andNumberColor:nil];
        [_scoreNumView generateViewWithTitle:@"积分" andInfo:@"可用积分" andNum:@"暂无" andNumberColor:nil];
    } else{
        if ([userModel.body.outSts isEqualToString:@"01"]) {
            //审批中
            _firstInfoLbl.textAlignment = NSTextAlignmentCenter;
            _firstInfoLbl.font = [UIFont appFontBoldOfSizePxSys:30 * _viewScale];
            _firstInfoLbl.text = @"额度审批中。。。";
            
            [_logAmtBtn setTitle:@"审批进度" forState:UIControlStateNormal];
            _logAmtBtn.tag = buttonTypeAmountProgress;
            _logAmtBtn.titleLabel.font = [UIFont appFontRegularOfSizePx:18 * _viewScale];
            [_headerView addSubview:_logAmtBtn];
            
            _firstInfoLbl.frame = CGRectMake(20 * _viewScale, 90 * _viewScale, DeviceWidth - 40 * _viewScale, 30 * _viewScale);
            
            _logAmtBtn.frame = CGRectMake((DeviceWidth - 143 * _viewScale) / 2, 135 * _viewScale, 143 * _viewScale, 32 * _viewScale);
            
        } else if ([userModel.body.outSts isEqualToString:@"25"]) {
            //申请被拒
            _firstInfoLbl.textAlignment = NSTextAlignmentCenter;
            _firstInfoLbl.font = [UIFont appFontBoldOfSizePxSys:30 * _viewScale];
            _firstInfoLbl.text = @"额度申请失败";
            
            _secondInfoLbl.textAlignment = NSTextAlignmentCenter;
            _secondInfoLbl.font = [UIFont appFontRegularOfSizePx:18 * _viewScale];
            _secondInfoLbl.text = @"请稍后再试";
            [_headerView addSubview:_secondInfoLbl];
            
            _firstInfoLbl.frame = CGRectMake(20 * _viewScale, 90 * _viewScale, DeviceWidth - 40 * _viewScale, 30 * _viewScale);
            
            _secondInfoLbl.frame = CGRectMake(20 * _viewScale, 130 * _viewScale, DeviceWidth - 40 * _viewScale, 18 * _viewScale);
            
        } else if ([userModel.body.outSts isEqualToString:@"22"]) {
            //审批退回
            _firstInfoLbl.textAlignment = NSTextAlignmentCenter;
            _firstInfoLbl.font = [UIFont appFontBoldOfSizePxSys:30 * _viewScale];
            _firstInfoLbl.text = @"额度退回";
            
            [_logAmtBtn setTitle:@"审批进度" forState:UIControlStateNormal];
            _logAmtBtn.tag = buttonTypeActiveAmount;
            _logAmtBtn.titleLabel.font = [UIFont appFontRegularOfSizePx:18 * _viewScale];
            [_headerView addSubview:_logAmtBtn];
            
            [_headerView addSubview:self.commitBtn];
            
            CGFloat buttonWidth = (DeviceWidth - 80 *_viewScale) / 2;
            
            _firstInfoLbl.frame = CGRectMake(20 * _viewScale, 90 * _viewScale, DeviceWidth - 40 * _viewScale, 30 * _viewScale);
            
            _logAmtBtn.frame = CGRectMake(30 * _viewScale, 135 * _viewScale, buttonWidth, 32 * _viewScale);
            
            self.commitBtn.frame = CGRectMake(50 * _viewScale + buttonWidth, 135 * _viewScale, buttonWidth, 32 * _viewScale);
            
        } else if ([userModel.body.outSts isEqualToString:@"27"]) {
            //已通过
            _firstInfoLbl.font = [UIFont appFontRegularOfSizePx:17 * _viewScale];
            _firstInfoLbl.textAlignment = NSTextAlignmentLeft;
            _firstInfoLbl.text = @"可用总额度（元）";
            
            _secondInfoLbl.font = [UIFont appFontBoldOfSizePxSys:61 * _viewScale];
            _secondInfoLbl.textAlignment = NSTextAlignmentLeft;
            _secondInfoLbl.text = @"150,000";
            [_headerView addSubview:_secondInfoLbl];
            
            [_logAmtBtn setTitle:@"提升额度" forState:UIControlStateNormal];
            _logAmtBtn.titleLabel.font = [UIFont appFontRegularOfSizePx:18 * _viewScale];
            _logAmtBtn.tag = buttonTypeIncreaseAmount;
            [_headerView addSubview:_logAmtBtn];
            
            self.amountAllLbl.text = @"总额度 20,000 元";
            [_headerView addSubview:self.amountAllLbl];
            
            _firstInfoLbl.frame = CGRectMake(42 * _viewScale, 68 * _viewScale, DeviceWidth - 120 * _viewScale, 17 * _viewScale);
            
            _secondInfoLbl.frame = CGRectMake(42 * _viewScale, 93 * _viewScale, DeviceWidth - 120 * _viewScale, 62 * _viewScale);
            [self addSubview:_secondInfoLbl];
            
            self.amountAllLbl.frame = CGRectMake(42 * _viewScale, 182 * _viewScale, DeviceWidth - 180 * _viewScale, 17 * _viewScale);
            
            _logAmtBtn.frame = CGRectMake(DeviceWidth - 130 * _viewScale, 175 * _viewScale,  88 * _viewScale, 31 * _viewScale);
            
        }
        //还有待提交状态 + 已取消 + 退回仿老界面 + 新的需审批
        
        
        
        [_moneyLeftView generateViewWithTitle:@"取现" andInfo:@"可借的钱" andNum:@"￥10,000.00" andNumberColor:@"#32cb97"];
        [_moneyPayView generateViewWithTitle:@"还款" andInfo:@"近7日应还" andNum:@"￥512.00" andNumberColor:@"#fba85b"];
        [_scoreNumView generateViewWithTitle:@"积分" andInfo:@"可用积分" andNum:@"600" andNumberColor:@"#29a8fd"];
    }
    
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
        
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 240 * _viewScale)];
        _headerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_headerView];
        
        _groundImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 240 * _viewScale)];
        _groundImgView.contentMode = UIViewContentModeScaleToFill;
        [_groundImgView setImage:[UIImage imageNamed:@"首页_渐变背景"]];
        [_headerView addSubview:_groundImgView];
        
        _groundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 240 * _viewScale)];
        _groundView.backgroundColor = [UIColor blackColor];
        _groundView.alpha = 0.5;
        
        _messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _messageBtn.tag = buttonTypeMessage;
        [_messageBtn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_messageBtn setImage:[UIImage imageNamed:@"导航栏_左"] forState:UIControlStateNormal];

        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.tag = buttonTypeScan;
        [_scanBtn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scanBtn setImage:[UIImage imageNamed:@"导航栏_右"] forState:UIControlStateNormal];
        
        _titleLbl = [self _generateLblWithFont:[UIFont appFontRegularOfSize:15]];
        _titleLbl.text = @"嗨付";
        _titleLbl.textAlignment = NSTextAlignmentCenter;

        _firstInfoLbl = [self _generateLblWithFont:[UIFont appFontBoldOfSizePx:20 * _viewScale]];
        _firstInfoLbl.textAlignment = NSTextAlignmentCenter;
        _firstInfoLbl.text = @"海尔消费金融倾力打造";
        
        _logAmtBtn = [self _generateBtnWithTitle:@"登录" andTag:buttonTypeLogin andFont:[UIFont appFontRegularOfSize:13 * _viewScale]];
        [self addSubview:_logAmtBtn];
        
        _secondInfoLbl = [self _generateLblWithFont:[UIFont appFontRegularOfSizePx:20 * _viewScale]];
        _secondInfoLbl.textAlignment = NSTextAlignmentCenter;
        _secondInfoLbl.text = @"请稍后再试";
        
        _moneyLeftView = [HCNumberInfoView new];
        [self addSubview:_moneyLeftView];
        
        _line1View = [UIView new];
        _line1View.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];
        [self addSubview:_line1View];
        
        _moneyPayView = [HCNumberInfoView new];
        [self addSubview:_moneyPayView];
        
        _line2View = [UIView new];
        _line2View.backgroundColor = [UIColor UIColorWithHexColorString:@"#ebebeb" AndAlpha:1];        [self addSubview:_line2View];
        
        _scoreNumView = [HCNumberInfoView new];
        [self addSubview:_scoreNumView];
        
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor UIColorWithHexColorString:@"#dddddd" AndAlpha:1];
        [self addSubview:_lineView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _messageBtn.frame = CGRectMake(15 * _viewScale, 26 * _viewScale, 24 * _viewScale, 24 * _viewScale);
    _scanBtn.frame = CGRectMake(DeviceWidth - 39 * _viewScale, 26 * _viewScale, 24 * _viewScale, 24 * _viewScale);
    _titleLbl.frame = CGRectMake(70 * _viewScale, 32 * _viewScale, DeviceWidth - 140 * _viewScale, 16 * _viewScale);
    
    if (iphone6P) {
        CGFloat viewWidth = (DeviceWidth - 22) / 3;
        _moneyLeftView.frame = CGRectMake(10, 240, viewWidth, 110);
        _line1View.frame = CGRectMake(viewWidth + 10, 261, 1, 66);
        _moneyPayView.frame = CGRectMake(viewWidth + 11, 240, viewWidth, 110);
        _line2View.frame = CGRectMake(viewWidth * 2 + 11, 261, 1, 66);
        _scoreNumView.frame = CGRectMake(DeviceWidth - viewWidth - 10, 240, viewWidth, 110);
        
        _lineView.frame = CGRectMake(0, 350 - thinLineHeight, DeviceWidth, thinLineHeight);
    } else {
        CGFloat viewWidth = (DeviceWidth - 22 * _viewScale) / 3;
        _moneyLeftView.frame = CGRectMake(10 * _viewScale, 240 * _viewScale, viewWidth, 100 * _viewScale);
        _line1View.frame = CGRectMake(viewWidth + 10 * _viewScale, 261 * _viewScale, 1 * _viewScale, 61 * _viewScale);
        _moneyPayView.frame = CGRectMake(viewWidth + 11 * _viewScale, 240 * _viewScale, viewWidth, 100 * _viewScale);
        _line2View.frame = CGRectMake(viewWidth * 2 + 11 * _viewScale, 261 * _viewScale, 1 * _viewScale, 61 * _viewScale);
        _scoreNumView.frame = CGRectMake(DeviceWidth - viewWidth - 10 * _viewScale, 240 * _viewScale, viewWidth, 100 * _viewScale);
        
        _lineView.frame = CGRectMake(0, 350 * _viewScale - thinLineHeight, DeviceWidth, thinLineHeight);
    }

}

#pragma Button Event
- (void)buttonDidClick:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(HCHomeHeaderViewDidClickButton:)]) {
        [self.delegate HCHomeHeaderViewDidClickButton:button];
    }
}

#pragma mark - Get Set
- (UILabel *)amountAllLbl {
    if (!_amountAllLbl) {
        _amountAllLbl = [self _generateLblWithFont:[UIFont appFontRegularOfSizePx:17 * _viewScale]];
        _amountAllLbl.textAlignment = NSTextAlignmentLeft;
    }
    return _amountAllLbl;
}

- (UIButton *)commitBtn {
    if (!_commitBtn) {
        _commitBtn = [self _generateBtnWithTitle:@"修改提交" andTag:buttonTypeCommitAmount andFont:[UIFont appFontRegularOfSizePx:18 * _viewScale]];
    }
    return _commitBtn;
}



#pragma mark - Private Method
- (UILabel *)_generateLblWithFont:(UIFont *)font{
    UILabel *lbl = [UILabel new];
    lbl.numberOfLines = 1;
    lbl.font = font;
    lbl.textColor = [UIColor whiteColor];
    
    return lbl;
}

- (UIButton *)_generateBtnWithTitle:(NSString *)title andTag:(NSInteger)tag andFont:(UIFont *)font{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.layer.cornerRadius = 16 * _viewScale;
    button.layer.masksToBounds = YES;
    button.tag = tag;
    [button.titleLabel setFont:font];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor UIColorWithHexColorString:App_MainColor AndAlpha:1]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
@end
