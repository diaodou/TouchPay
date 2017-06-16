//
//  HCHomeAdvertController.m
//  newHaierCash
//
//  Created by Will on 2017/6/1.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIFont+AppFont.h"

#import "HCHomeAdvertController.h"

@interface HCHomeAdvertController () {
    NSTimer *_countDownTimer;
    UILabel *_numLabel;//显示跳动数字的label
    UIImageView *_bgImageView;
    
    CGFloat _viewScale;

    NSInteger _countTime;
}



@end

@implementation HCHomeAdvertController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;

    self.view.backgroundColor = [UIColor colorWithRed:0.35 green:0.76 blue:0.99 alpha:1.00];
    
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;

    _countTime = 4;
    
    [self initContentView];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //页面消失的时候将背景图清除
    [_bgImageView removeFromSuperview];
    _bgImageView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
//加载页面内容视图
- (void)initContentView {
    _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    _bgImageView.image = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/启动页默认图.png",[[NSBundle mainBundle] resourcePath]]];
    _bgImageView.userInteractionEnabled = YES;
    
    //为背景图添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgImageClick)];
    [_bgImageView addGestureRecognizer:tap];
    
    [self.view addSubview:_bgImageView];

    //右上角背景图
    UIImageView *roundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"广告页－灰圆"]];
    roundImageView.frame = CGRectMake(330*_viewScale, 37*_viewScale, 43*_viewScale, 43*_viewScale);
    [self.view addSubview:roundImageView];
    
    //数字label
    _numLabel = [[UILabel alloc] init];
    _numLabel.frame = CGRectMake(6*_viewScale, 7*_viewScale, 31*_viewScale, 16*_viewScale);
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.text = [NSString stringWithFormat:@"%d",_countTime];
    /*if(_kpad.showTime && _kpad.showTime.length > 0)
    {
        _numLabel.text = _kpad.showTime;
        _count = _kpad.showTime.intValue;
    }*/
    _numLabel.textColor = [UIColor whiteColor];
    [roundImageView addSubview:_numLabel];
    
    //跳过label
    UILabel *skipLabel = [[UILabel alloc] init];
    skipLabel.frame = CGRectMake(6*_viewScale, 23*_viewScale, 31*_viewScale, 12*_viewScale);
    skipLabel.textAlignment = NSTextAlignmentCenter;
    skipLabel.text = @"跳过";
    skipLabel.textColor = [UIColor whiteColor];
    [roundImageView addSubview:skipLabel];
    
    if(iphone6P)
    {
        _numLabel.font = [UIFont appFontBoldOfSize:12];
        skipLabel.font = [UIFont appFontRegularOfSize:9];
    }else
    {
        _numLabel.font = [UIFont appFontBoldOfSize:11];
        skipLabel.font = [UIFont appFontRegularOfSize:8];
    }
    
    UIButton *skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.frame = CGRectMake(330*_viewScale, 37*_viewScale, 43*_viewScale, 43*_viewScale);
    [skipButton addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipButton];
    
    _countDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_countDownTimer forMode:NSRunLoopCommonModes];
}

- (void)countDown
{
    _countTime --;
    _numLabel.text = [NSString stringWithFormat:@"%d",_countTime];
    
    if(_countTime == 0)
    {
        [self skip];
    }
}

//点击背景图的事件
- (void)bgImageClick
{
    [self.view removeFromSuperview];
    
    self.clickReponder();
    
    if (_countDownTimer) {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
}

//跳过
- (void)skip
{
    [self.view removeFromSuperview];
    if (_countDownTimer) {
        [_countDownTimer invalidate];
        _countDownTimer = nil;
    }
}
@end
