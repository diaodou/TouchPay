//
//  HelpDetailViewController.m
//  personMerchants
//
//  Created by 王晓栋 on 16/6/2.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "HelpDetailViewController.h"
#import "UIFont+AppFont.h"
#import "HCMacro.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "HelpDetailModel.h"
@interface HelpDetailViewController ()<BSVKHttpClientDelegate>
{
    
    UIWebView *_helpWebView;//帮助网页
    
}

@end

@implementation HelpDetailViewController


#pragma mark --> life Cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];


}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> setting and getting

-(void)setDataModel:(HelpData *)dataModel{
    
    _dataModel = dataModel;
    
    self.navigationItem.title = _dataModel.helpTitle;
    
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = _dataModel.helpTitle;
    
    [self creatWeb];
    
    [self buildGetInfo];
    
}


#pragma mark --> privace Methods

//获取帮助的详情

-(void)buildGetInfo{
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    NSString *help = [NSString stringWithFormat:@"app/appmanage/help/%@",_dataModel.helpId];
    
    [client getInfo:help requestArgument:nil requestTag:10 requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

//创建WebView
-(void)creatWeb{
    
    _helpWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64)];
    _helpWebView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
    
    _helpWebView.scalesPageToFit = YES;
    
    [self.view addSubview:_helpWebView];
    
    
}

#pragma mark --> 网络代理协议

//请求成功
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 10) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            HelpDetailModel *model = [HelpDetailModel mj_objectWithKeyValues:responseObject];
            
            if ([model.head.retFlag isEqualToString:@"00000"]) {
                
                [self creatWebViewHttp:model.body.helpContent];
                
            }else{
                
                [self buildHeadError:model.head.retMsg];
                
            }
            
            
        }
        
    }
    
}

//请求失败
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if(httpCode != 0)
        {
            [self buildHeadError:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode]];
        }
        else
        {
            [self buildHeadError:@"网络环境异常，请检查网络并重试"];
        }        
    }
}


//返回的错误信息

//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                nil;
            }
        }
    }];
    
    
}



//创建网页视图
-(void)creatWebViewHttp:(NSString *)http{
    
    
    if (http && http.length > 0) {
        
        [_helpWebView loadHTMLString:http baseURL:[NSURL URLWithString:(NSString *)baseUrl]];
        
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
