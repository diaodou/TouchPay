//
//  ContractShowViewController.m
//  personMerchants
//
//  Created by 张久健 on 16/6/4.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "ContractShowViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import <IMYWebView.h>
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
//#import "ContractConfirmModel.h"
#import "RMUniversalAlert.h"
#import <MJExtension.h>
//#import "ContractFailModel.h"
#import <MBProgressHUD.h>
#import "UIButton+UnifiedStyle.h"
//#import "BSVKMutiltClient.h"
//#import "NSMutableURLRequest+HeadAddNSURLRequest.h"
@interface ContractShowViewController ()<IMYWebViewDelegate,BSVKHttpClientDelegate>
{
    IMYWebView *OnLineWebView;
}
@end

@implementation ContractShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    [self setUI];
    if ([_showState isEqualToString:@"show"]) {
        
    }else{
        //    创建提交按钮
        [self createBtnCommit];
    }
    [self loadWebInfo];
}


- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [OnLineWebView stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Methods
- (void)setUI {
    if (_transitionType == modelType) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(8, 25, 46, 30)];
        [btn setTitle:@"返回_黑" forState:0];
        [btn setTitleColor:[UIColor whiteColor] forState:0];
        btn.titleLabel.font = [UIFont appFontRegularOfSize:15];
        [btn addTarget:self action:@selector(closeViewA) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.view addSubview:btn];
    }else {
        [self setNavi];
    }
    BOOL useUIWeb;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        useUIWeb = NO;
    }else {
        useUIWeb = YES;
    }
    if ([_showState isEqualToString:@"show"]) {
        OnLineWebView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) usingUIWebView:useUIWeb];
    }else {
        OnLineWebView = [[IMYWebView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 119) usingUIWebView:useUIWeb];
    }
    OnLineWebView.delegate = self;
    [self.view addSubview:OnLineWebView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)btn {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//创建提交按钮
- (void)createBtnCommit{
    
    UIButton *commit = [UIButton buttonWithType:(UIButtonTypeSystem)];
    commit.frame = CGRectMake(30, DeviceHeight - 119, DeviceWidth - 60, 45);
    [commit setButtonTitle:@"同意并继续" titleFont:14 buttonHeight:45];
    [commit addTarget:self action:@selector(commitAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.view addSubview:commit];
}
-(void)commitAction{
    
    if (_quote == zhanshi) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"agreeSign" object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
}

- (void)loadWebInfo {
    if ([_showState isEqualToString:@"show"]) {
        NSData *dataSource = [NSData dataWithContentsOfURL:_path];
        [OnLineWebView loadData:dataSource MIMEType:@"application/pdf" characterEncodingName:@"UTF-8" baseURL:_path];
    }else{
        NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",baseUrl,_strOnLineUrl]]];
        request.timeoutInterval = 30;
//        [request addchannelHead];
        [OnLineWebView loadRequest:request];
    }
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
- (void)webView:(IMYWebView*)webView didFailLoadWithError:(NSError*)error {

}
/*    此界面的调用
 ContractShowViewController *vc = [[ContractShowViewController alloc]init];
 CustomNavigationController *navi = [[CustomNavigationController alloc]initWithRootViewController:vc];
 vc.title = @"合同展示";
 [self.navigationController presentViewController:navi animated:YES completion:nil];
 */
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
