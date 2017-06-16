//
//  ViewController.m
//  重置登录密码
//
//  Created by Apple on 16/4/7.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "InputTelFindPwdViewController.h"
#import "UIFont+AppFont.h"
#import "HCMacro.h"
#import "RMUniversalAlert.h"
#import "WriteVerificationViewController.h"
#import "NSString+CheckConvert.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import "EnterAES.h"
#import <MBProgressHUD.h>
#import "RegisterModel.h"
#import "AppDelegate.h"
@interface InputTelFindPwdViewController ()<BSVKHttpClientDelegate>

@property (nonatomic,strong)UITextField *numberTextField;
@end

@implementation InputTelFindPwdViewController

#pragma mark - life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff, 1);
    [self setLineView];
    [self creatView];//底部view
    [self creatButton];//底部按钮
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_numberTextField resignFirstResponder];
}

#pragma mark -- setting and getting
- (void)setLineView{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self.view addSubview:lineView];
}
-(void)creatView{
    UIView *bottomView = [[UIView alloc]init];
    _numberTextField = [[UITextField alloc]init];
    bottomView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self.view addSubview:bottomView];
    if (iphone6P) {
        
        bottomView.frame = CGRectMake(47,47, DeviceWidth - 94, 50);
        
        bottomView.layer.cornerRadius = 25;
        
        _numberTextField.frame = CGRectMake(20,0, bottomView.frame.size.width - 30, 50);
    }else{
        
        bottomView.frame = CGRectMake(42 *DeviceWidth/375,42*DeviceWidth/375, DeviceWidth - 82*DeviceWidth/375, 45*DeviceWidth/375);
        
        bottomView.layer.cornerRadius = 22.5*DeviceWidth/374;
        
        _numberTextField.frame = CGRectMake(16 *DeviceWidth/375,0, bottomView.frame.size.width - 16*DeviceWidth/375, 45*DeviceWidth/375);
    }

    _numberTextField.textColor = UIColorFromRGB(0x383838, 1);
    _numberTextField.font = [UIFont appFontRegularOfSize:14];
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _numberTextField.clearButtonMode = YES;
    _numberTextField.placeholder = @"请输入手机号码";
    if ([AppDelegate delegate].userInfo.bLoginOK) {
        
        _numberTextField.enabled = NO;
    }else{
    
        
        _numberTextField.text = StringOrNull(_strTel);

        _numberTextField.enabled = YES;
    }

    
    [bottomView addSubview:_numberTextField];
}
// setting 底部按钮
-(void)creatButton{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    if (iphone6P) {
        button.frame = CGRectMake(47 , 120, DeviceWidth - 94, 50);
        button.layer.cornerRadius = 25.f;
    } else {
        button.frame = CGRectMake(42 *DeviceWidth/375 , 110, DeviceWidth - 84 *DeviceWidth/375, 45*DeviceWidth/375);
        button.layer.cornerRadius = 22.5*DeviceWidth/374;
    }
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:UIColorFromRGB(0x32beff, 1)];
    [button addTarget:self action:@selector(judge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

#pragma mark - private Methods
-(void)judge{
    
    NSString * numberStr = [_numberTextField.text deleteSpeaceString];
    _numberTextField.text = numberStr;
    
    if (isEmptyString(_numberTextField.text)) {
        
        [self buildHeadError:@"请输入手机号"];
        
        return;
    }else{
        [self isRegister];
    }
}
- (void)toWriteVerificationViewController{
    WriteVerificationViewController *writeVC = [[WriteVerificationViewController alloc]init];
    if ([AppDelegate delegate].userInfo.bLoginOK) {
        
    }else{
        writeVC.strTel = _numberTextField.text;
    }
    [self.navigationController pushViewController:writeVC animated:YES];
}
#pragma  mark - request
- (void)isRegister{
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    [client getInfo:@"app/appserver/uauth/isRegister" requestArgument:@{@"mobile":[EnterAES simpleEncrypt:_numberTextField.text]} requestTag:111 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
#pragma  mark - BSVK Delegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {

        RegisterModel * model = [RegisterModel mj_objectWithKeyValues:responseObject];
            
        [self analySisRegisterModel:model];
    
    }
}
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
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
                nil;
            }
        }
    }];
}
#pragma mark - Model 解析
- (void)analySisRegisterModel:(RegisterModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        if ([model.body.isRegister isEqualToString:@"Y"] || [model.body.isRegister isEqualToString:@"C"]) {
            
            WEAKSELF
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:[NSString stringWithFormat:@"我们将发送短信验证码到这个手机号：%@",_numberTextField.text] cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                if (strongSelf) {
                    if (buttonIndex == 1) {
                        
                        [strongSelf toWriteVerificationViewController];
                    }else{
                        return ;
                    }
                }
            }];
        }else{
            
         [self buildHeadError:@"此手机号未注册！"];
        
        }
    }else{
        
         [self buildHeadError:model.head.retMsg];
    }
}
@end
