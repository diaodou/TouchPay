//
//  PickUpCodeViewController.m
//  personMerchants
//
//  Created by 张久健 on 16/3/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "PickUpCodeViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "MBProgressHUD.h"
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import <MBProgressHUD.h>
#import "EnterAES.h"
#import <MJExtension.h>
@interface PickUpCodeViewController ()<BSVKHttpClientDelegate>
@property(nonatomic,strong) NSString * telStr;
@end

@implementation PickUpCodeViewController
#pragma mark - left cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"取货码";
    [self setNavi];
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self getRequest];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}
#pragma mark - request Methods
- (void)getRequest{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/apporder/getTradeCode" requestArgument:@{@"applSeq":[AppDelegate delegate].userInfo.applSeq} requestTag:20 requestClass:NSStringFromClass([self class])];
    
}
#pragma mark - private Methods
//拨打电话
- (void)btnTelClick {
    NSString *originalPhone =  [self.telStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *phoneStr = [NSString stringWithFormat:@"tel:%@", originalPhone];
    UIWebView *callWebview = [[UIWebView alloc] init];
    NSURL *telURL = [[NSURL alloc] initWithString:phoneStr];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [[[UIApplication sharedApplication] keyWindow] addSubview:callWebview];
    
}
#pragma mark - setting and getting
- (void)createView{

//取货码
    UIImageView *CodeimageView = [[UIImageView alloc]initWithFrame:(CGRectMake((DeviceWidth - 289)/2, IPHONE4 ? 60 : 100 * DeviceWidth / 375, 289, 250))];
    CodeimageView.image = [UIImage imageNamed:@"取货码"];
//    贷款编号
    UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 33, 216, 16)];
    numLabel.font = [UIFont appFontRegularOfSize:12];
    numLabel.textColor = UIColorFromRGB(0xffffff, 1.0);
    [CodeimageView addSubview:numLabel];
//线条
    UIImageView *line = [[UIImageView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(numLabel.frame)+ 13, CodeimageView.frame.size.width, 1))];
    line.image = [UIImage imageNamed:@""];
//提示信息
    UILabel *prompt = [[UILabel alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(line.frame) + 20, 289, 16))];
    prompt.textAlignment = NSTextAlignmentCenter;
    prompt.textColor = UIColorFromRGB(0xffffff, 1.0);
    prompt.font = [UIFont appFontRegularOfSize:12];

//取货码
    UILabel * code = [[UILabel alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(prompt.frame) + 30, CGRectGetWidth(CodeimageView.frame), 132 - CGRectGetMaxY(prompt.frame)))];
    code.textColor = [UIColor colorWithRed:253/255.0 green:245/255.0 blue:115/255.0 alpha:1.0];
    code.textAlignment = NSTextAlignmentCenter;
    code.font = [UIFont systemFontOfSize:40];
    [CodeimageView addSubview:code];
    [CodeimageView addSubview:prompt];
    [self.view addSubview:CodeimageView];
//线条
    UIImageView *lineBouttom = [[UIImageView alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(code.frame), CodeimageView.frame.size.width, 1))];
    line.image = [UIImage imageNamed:@""];
    [CodeimageView addSubview:lineBouttom];
//有效期
    UILabel * ValidityPeriod = [[UILabel alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(lineBouttom.frame) + 50, CGRectGetWidth(CodeimageView.frame), 18))];
    ValidityPeriod.font = [UIFont systemFontOfSize:12];
    ValidityPeriod.textColor = UIColorFromRGB(0xffffff, 1.0);
    ValidityPeriod.textAlignment = NSTextAlignmentCenter;
    [CodeimageView addSubview:ValidityPeriod];
//帮助
    UILabel *help = [[UILabel alloc]initWithFrame:(CGRectMake(0, CGRectGetMaxY(CodeimageView.frame) + 26, DeviceWidth, 30))];
    help.textAlignment = NSTextAlignmentCenter;
    help.numberOfLines = 2;
    help.lineBreakMode = NSLineBreakByCharWrapping;
    NSString *url = @"400-018-7777";
    help.text = [NSString stringWithFormat:@"有任何疑问请拨打%@咨询客服",url];
    help.textColor = UIColorFromRGB(0x333333, 1.0);
    help.font = [UIFont appFontRegularOfSize:14];
    [self.view addSubview:help];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"有任何疑问，请拨打400-018-7777咨询客服"];
    self.telStr = @"400-018-7777";
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x028de5, 1.0) range:NSMakeRange(9, 12)];
    help.attributedText = str;
    UIButton * btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btn.frame = CGRectMake(0, CGRectGetMinY(help.frame), DeviceWidth, 40);
    [btn addTarget:self action:@selector(btnTelClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:btn];
//    取货码解密
        code.text = [EnterAES simpleDecrypt:_tradeCodeModel.body.tradeCode];
        code.textColor = UIColorFromRGB(0xfdf571, 1.0);
        prompt.text = @"请将下方取货码告知商家，确认收货";
        ValidityPeriod.text = [NSString stringWithFormat:@"取货码有效期至%@",_tradeCodeModel.body.expireTime];
        CodeimageView.image = [UIImage imageNamed:@"取货码"];
        numLabel.text = [NSString stringWithFormat:@"贷款编号:%@",_codeStr];
}
// 设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - BSVK Delegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 20) {
            
            _tradeCodeModel = [TradeCodeModel mj_objectWithKeyValues:responseObject];
            
            [self analySisTradeCodeModel];
        }
    }
}
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
//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                
            }
        }
    }];
    
    
}

#pragma mark - Model 解析
- (void)analySisTradeCodeModel{
    if ([_tradeCodeModel.head.retFlag isEqualToString:SucessCode]) {
        
        [self createView];
    }else{
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:_tradeCodeModel.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                    [strongSelf.navigationController popViewControllerAnimated:YES];
                    
                }
            }
        }];
    }
}
@end
