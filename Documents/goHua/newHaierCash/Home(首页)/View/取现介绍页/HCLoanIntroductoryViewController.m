//
//  LoanIntroductoryViewController.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCLoanIntroductoryViewController.h"
#import <IMYWebView.h>
#import "HCMacro.h"
#import "RMUniversalAlert.h"

#import "HCCashLoanViewController.h"
@interface HCLoanIntroductoryViewController ()<IMYWebViewDelegate>

@property (nonatomic,strong)IMYWebView *webView;
@end

@implementation HCLoanIntroductoryViewController
#pragma mark - lift cycle
- (void)loadView{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setWebView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"现金分期";
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"www.baidu.com"]];
    request.timeoutInterval = 30;
    [_webView loadRequest:request];
}
#pragma mark - private Methods
- (void)setWebView{
    _webView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) usingUIWebView:YES];
    _webView.delegate = self;
    [self.view addSubview:_webView];
}

#pragma mark - IMYWebViewDelegate
- (BOOL)webView:(IMYWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    HCCashLoanViewController *vc = [[HCCashLoanViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
    return YES;
}
@end
