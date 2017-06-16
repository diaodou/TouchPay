//
//  PMWebViewController.m
//  personMerchants
//
//  Created by Will on 17/4/1.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "PMWebViewController.h"

#import <IMYWebView.h>
#import "MBProgressHUD.h"
#import "RMUniversalAlert.h"
#import "HCMacro.h"
//#import "NSMutableURLRequest+HeadAddNSURLRequest.h"
@interface PMWebViewController ()<IMYWebViewDelegate> {
    IMYWebView *_webView;
}

@end

@implementation PMWebViewController

#pragma mark - Life Cycle
- (void)loadView {
    [super loadView]; //创建空白View
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self _setNavi];
    [self _loadWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.webUrlStr]];
    request.timeoutInterval = 30;
//    [request addchannelHead];
    [_webView loadRequest:request];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.webType == PMWebVeiwControllerTypeForgotPassword || self.webType == PMWebVeiwControllerTypeChangedPassword) {
        //改变海尔会员修改密码Web页面的frame
        _webView.frame = CGRectMake(0, -50, DeviceWidth, DeviceHeight);
    } else {
        _webView.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods
#pragma mark 绘制UI
//设置导航
- (void)_setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(_backBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

//加载WebView
- (void)_loadWebView {
    _webView = [[IMYWebView alloc]initWithFrame:CGRectZero usingUIWebView:YES];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

#pragma mark 私有方法
-(void)_showInfoView:(NSString *)error{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

#pragma mark - Button Response
- (void)_backBtnDidClick:(UIButton *)btn {
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark - IMYWebViewDelegate 第三方WebView 代理方法
- (BOOL)webView:(IMYWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    // 海尔会员修改密码后要跳转到网站首页时，返回到登陆页面
    if (self.webType == PMWebVeiwControllerTypeForgotPassword && [[request.URL absoluteString] isEqualToString:self.returnUrlStr]) {
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    } else if (self.webType == PMWebVeiwControllerTypeChangedPassword && [[request.URL absoluteString] isEqualToString:self.returnUrlStr]) {
        [self.navigationController popViewControllerAnimated:YES];
        if ([self.webConDelegate respondsToSelector:@selector(PMWebViewControllerResetPasswordWithSuccess:)]) {
            [self.webConDelegate PMWebViewControllerResetPasswordWithSuccess:YES];
        }

    }
    
    // 遮挡海尔会员修改密码Web页面的下部分
    if (self.webType == PMWebVeiwControllerTypeForgotPassword || self.webType == PMWebVeiwControllerTypeChangedPassword) {
        UIView *bottomWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 350, DeviceWidth, 400)];
        bottomWhiteView.backgroundColor = [UIColor whiteColor];
        [_webView.scrollView addSubview:bottomWhiteView];
        [_webView bringSubviewToFront:bottomWhiteView];
    }
    
    //当页面上没有加载提示时，显示加载提示
    if (![MBProgressHUD HUDForView:self.view]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    return YES;
}

- (void)webViewDidFinishLoad:(IMYWebView *)webView {

    // 遮挡海尔会员修改密码Web页面的上部分
    if (self.webType == PMWebVeiwControllerTypeForgotPassword || self.webType == PMWebVeiwControllerTypeChangedPassword) {
        UIView *topWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
        topWhiteView.backgroundColor = [UIColor whiteColor];
        [_webView.scrollView addSubview:topWhiteView];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(IMYWebView *)webView didFailLoadWithError:(NSError *)error {

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self _showInfoView:@"网络环境异常，请检查网络并重试"];
}
@end
