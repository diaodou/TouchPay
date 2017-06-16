//
//  ViewController.m
//  密码设置
//
//  Created by 百思为科iOS on 16/4/4.
//  Copyright © 2016年 百思为科iOS. All rights reserved.
//

#import "VerityPwdViewController.h"
#import "HCMacro.h"
#import "NSString+CheckConvert.h"
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import "SvUDIDTools.h"
#import "VerityPwdModel.h"
#import <MJExtension.h>
#import "RMUniversalAlert.h"
#import "RegisterModel.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "SvUDIDTools.h"
#import "SvUDIDTools.h"
#import "AppDelegate.h"
#import "EnterAES.h"
#import "SecurityViewController.h"
#import "UIFont+AppFont.h"
static CGFloat const updatePayPasswd = 100;
static CGFloat const custUpdatePwd = 10;
@interface VerityPwdViewController ()<UITextFieldDelegate,BSVKHttpClientDelegate,MBProgressHUDDelegate>
{
    float x;

}

@property(nonatomic,strong)UITextField *firstText;//第一次登录密码输入框

@property(nonatomic,strong)UITextField *sureText;//确认支付密码输入框
@end

@implementation VerityPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavi];
    
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    
    self.navigationItem.title  = @"密码设置";
    
    if ([AppDelegate delegate].userInfo.bLoginOK) {
        
        _telNum = [AppDelegate delegate].userInfo.userId;
    }
    
    [self createPassword];
}
#pragma mark - getting and setting

//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
- (void)OnBackBtn:(UIButton *)btn {

    if ([AppDelegate delegate].userInfo.bLoginOK) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(void)createPassword{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
        
    }
    
    // 97
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, .5)];
    
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [self.view addSubview:lineView];
    
    
    /*-------------------------设置登录密码-----------------------------*/
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(47*x, 58*x, DeviceWidth-94*x, 50*x)];
    
    firstView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    firstView.layer.cornerRadius = 25*x;
    
    [self.view addSubview:firstView];
    
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(24*x, 17*x, 16*x, 16*x)];
    
    leftImg.image = [UIImage imageNamed:@"密码设置"];
    
    leftImg.backgroundColor = [UIColor clearColor];
    
    [firstView addSubview:leftImg];
    
    _firstText = [[UITextField alloc]initWithFrame:CGRectMake(55*x, 15*x, DeviceWidth-150*x, 20*x)];
    
    _firstText.font = [UIFont appFontRegularOfSize:14*x];
    
    _firstText.textColor = UIColorFromRGB(0x999999, 1.0);
    
    _firstText.placeholder = @"输入新的支付密码";
    
    _firstText.secureTextEntry = YES;
    
    [firstView addSubview:_firstText];
    
    /*-------------------------确认登录密码-----------------------------*/
    
    UIView *sureView = [[UIView alloc]initWithFrame:CGRectMake(47*x, 128*x, DeviceWidth-94*x, 50*x)];
    
    sureView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    sureView.layer.cornerRadius = 25*x;
    
    [self.view addSubview:sureView];
    
    UIImageView *sureImg = [[UIImageView alloc]initWithFrame:CGRectMake(24*x, 17*x, 16*x, 16*x)];
    
    sureImg.image = [UIImage imageNamed:@"确认密码"];
    
    sureImg.backgroundColor = [UIColor clearColor];
    
    [sureView addSubview:sureImg];
    
    
    _sureText = [[UITextField alloc]initWithFrame:CGRectMake(55*x, 15*x, DeviceWidth-150*x, 20*x)];
    
    _sureText.font = [UIFont appFontRegularOfSize:14*x];
    
    _sureText.secureTextEntry = YES;
    
    _sureText.placeholder = @"确认密码";
    
    _sureText.textColor = UIColorFromRGB(0x999999, 1.0);
    
    [sureView addSubview:_sureText];
    
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(47*x, 221*x, DeviceWidth-94*x, 50*x)];
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    nextButton.layer.cornerRadius = 25*x;
    
    nextButton.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    nextButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextButton];
    
    
}

#pragma mark - event response

-(void)nextAction:(UIButton *)sender{
    [_firstText resignFirstResponder];
    [_sureText resignFirstResponder];
    if(_firstText.text.length == 0 || _sureText.text.length == 0){
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"密码不能为空" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    nil ;
                }
            }
        }];
        return;
        
    }else if((![_firstText.text isValidateInput])||(![_sureText.text isValidateInput])) {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请输入6-20位组合字母、数字" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    nil ;
                }
            }
        }];
        return;
        
    }else if([_firstText.text isEqualToString:_sureText.text]&&_firstText.text.length != 0) {
        [BSVKHttpClient shareInstance].delegate = self;
        if (self.verityPwdType == VerityPwdChangeDealPwdByRemeber) {
            [[BSVKHttpClient shareInstance] putInfo:@"app/appserver/uauth/updatePayPasswd" requestArgument:@{@"userId":[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId],@"newPayPasswd":[EnterAES simpleEncrypt:_firstText.text],@"payPasswd":[EnterAES simpleEncrypt:_oldPayPassWord] } requestTag:updatePayPasswd requestClass:NSStringFromClass([self class])];
            NSLog(@"userId = %@",[AppDelegate delegate].userInfo.userId);
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }else{
        //把密码传给后台
        
            [[BSVKHttpClient shareInstance] putInfo:@"app/appserver/uauth/custUpdatePwd"  requestArgument:@{@"userId":StringOrNull([EnterAES simpleEncrypt:self.telNum]),@"verifyNo":StringOrNull(self.verifyNo),@"newPassword":[EnterAES simpleEncrypt:_firstText.text],@"deviceId":[EnterAES simpleEncrypt:[SvUDIDTools UDID]]} requestTag:custUpdatePwd requestClass:NSStringFromClass([self class])];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];   //菊花
        }
    }else if(_firstText.text.length == 0 || _sureText.text.length == 0){
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请输入密码" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    nil;
                }
            }
        }];
    }else if (![_firstText.text isEqualToString:_sureText.text]){
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"两次密码输入不相同" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    nil;
                }
            }
        }];
    }
}
#pragma mark --- Put Delegate Method -----
//失败
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *errorStr;
        if(httpCode != 0)
        {
            errorStr = [NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode];
        }
        else
        {
            errorStr = @"网络环境异常，请检查网络并重试";
        }
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:errorStr cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                }
            }
        }];
    }
    
}
//成功
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
         if (requestTag == custUpdatePwd){
            // 通过短信验证修改登录密码
            VerityPwdModel * model = [VerityPwdModel mj_objectWithKeyValues:responseObject];
            if ([model.head.retFlag isEqualToString:@"00000"]) {
                WEAKSELF
                [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"密码修改成功！" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    STRONGSELF
                    if (strongSelf) {
                        if (buttonIndex == 0) {
                            //        处理成功再跳转
                            [AppDelegate delegate].userInfo.userId =  model.body.userId;
                            if ([AppDelegate delegate].userInfo.bLoginOK) {
                                
                            }else{
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            }
                            
                        }
                    }
                    
                }];
                
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                WEAKSELF
                [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    STRONGSELF
                    if (strongSelf) {
                        if (buttonIndex == 0) {
                            nil;
                        }
                    }
                }];
            }
         }else if (requestTag == updatePayPasswd){
             VerityPwdModel * model = [VerityPwdModel mj_objectWithKeyValues:responseObject];
             
             [self analySisVerityPwdModel:model];
             
         }
    }
}
#pragma mark - Model 解析
- (void)analySisVerityPwdModel:(VerityPwdModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"密码修改成功！" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    //                处理成功之后调回安全设置界面
                    NSArray *controllers = [self.tabBarController.selectedViewController childViewControllers];
                    [strongSelf.navigationController popToViewController:controllers[2] animated:YES];
                }
            }
            
        }];
        
    }else{
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    nil;
                }
            }
        }];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_firstText resignFirstResponder];
    [_sureText resignFirstResponder];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

@end

