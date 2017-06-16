//
//  BankAgreementViewController.m
//  personMerchants
//
//  Created by 百思为科 on 16/7/28.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "BankAgreementViewController.h"
#import <IMYWebView.h>
#import "BSVKHttpClient.h"
#import "HCMacro.h"
//#import "NSMutableURLRequest+HeadAddNSURLRequest.h"
@interface BankAgreementViewController ()<IMYWebViewDelegate,BSVKHttpClientDelegate>{
    IMYWebView *OnLineWebView;

}

@end

@implementation BankAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡授权协议";
    self.view.backgroundColor = [UIColor whiteColor];
    OnLineWebView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64)];
    OnLineWebView.delegate = self;
    [self.view addSubview:OnLineWebView];
    [self loadWebInfo];
}

- (void)loadWebInfo {
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",baseUrl,_strOnLineUrl]]];
    request.timeoutInterval = 30;
//    [request addchannelHead];
    [OnLineWebView loadRequest:request];
}

- (void)closeViewA {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [OnLineWebView sizeToFit];
    //    OnLineWebView.scalesPageToFit = YES;
}


@end
