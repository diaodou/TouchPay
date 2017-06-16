//
//  RegisterViewController.m
//  newHaierCash
//
//  Created by 张久健 on 2017/6/1.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "RegisterViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import "NSString+CheckConvert.h"
#import <MBProgressHUD.h>
#import "EnterAES.h"
#import "RegisterModel.h"
#import "RegCodeViewController.h"
static CGFloat const JudgeNumber = 110;//判断该手机号是否已注册
@interface RegisterViewController ()<BSVKHttpClientDelegate,UITextFieldDelegate>

{
    
    
    
    float x;//缩放比例
    
}

@property(nonatomic,strong)UITextField *phoneText;//手机号输入框

@end

@implementation RegisterViewController


#pragma mark --> life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self creatBaseUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> private Methods

//创建基础视图
-(void)creatBaseUI{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
    
    }else{
        
        x = scaleAdapter;
        
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 97*x, DeviceWidth, 10*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:lineView];
    
    UIView *phoneView = [[UIView alloc]initWithFrame:CGRectMake(47*x, 155*x, DeviceWidth-94*x, 50*x)];
    
    phoneView.layer.cornerRadius = 25*x;
    
    phoneView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:phoneView];
    
    UIImageView *leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(25*x, 17*x, 16*x, 16*x)];
    
    leftImg.image = [UIImage imageNamed:@"注册_手机"];
    
    leftImg.backgroundColor = [UIColor clearColor];
    
    [phoneView addSubview:leftImg];
    
    _phoneText = [[UITextField alloc]initWithFrame:CGRectMake(54*x, 15*x, DeviceWidth-148*x, 20*x)];
    
    _phoneText.font = [UIFont appFontRegularOfSize:13*x];
    
    _phoneText.placeholder = @"请输入手机号";
    
    _phoneText.backgroundColor = [UIColor clearColor];
    
    _phoneText.returnKeyType = UIReturnKeyDone;
    
    _phoneText.delegate = self;
    
    [phoneView addSubview:_phoneText];
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(47*x, 225*x, DeviceWidth-94*x, 50*x)];
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    nextButton.layer.cornerRadius = 25*x;
    
    nextButton.titleLabel.font = [UIFont appFontRegularOfSize:13*x];
    
    nextButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [nextButton addTarget:self action:@selector(buildToNextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextButton];
    
}


#pragma mark --> event Methods

-(void)buildToNextAction:(UIButton *)sender{
    
    [_phoneText resignFirstResponder];
    
    if (_phoneText.text.length == 0) {
        
        [self buildHeadError:@"请输入手机号码"];
        
    }else if (![_phoneText.text isValidateMobileNum]){
        
        [self buildHeadError:@"请输入11位的手机号码"];
        
    }else{
        
        [self buildIsJudgeMobile];
        
//        if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
//            
//            [AppDelegate delegate].userInfo.userId = _phoneText.text;
//            
//            [_delegate sendSaveInfoViewType:MobileType];
//            
//        }
        
    }
    
    
}

#pragma mark --> 网络请求

-(void)buildIsJudgeMobile{
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    NSString *mobile =  [EnterAES simpleEncrypt:_phoneText.text];//加密字段
    
    [[BSVKHttpClient shareInstance] getInfo:@"app/appserver/uauth/isRegister" requestArgument:@{@"mobile":mobile} requestTag:JudgeNumber requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

#pragma mark --> 网络代理协议

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == JudgeNumber) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            RegisterModel *model = [RegisterModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleJudgeNumber:model];
            
        }
        
    }
    
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *errorStr;
        
        if(httpCode  != 0)
        {
            errorStr = [NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode ];
        }
        else
        {
            errorStr = @"网络环境异常，请检查网络并重试";
        }
        
        [self buildHeadError:errorStr];
        
    }
    
}

//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                return;
            }
        }
    }];
    
}

#pragma mark --> 处理网络请求后的model
//处理注册请求
-(void)buildHandleJudgeNumber:(RegisterModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if ([model.body.isRegister isEqualToString:@"Y"]) {
            //已注册
            if ([model.body.provider isEqualToString:HAIERUAC]) {
                WEAKSELF
                [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"您已经是海尔会员啦，请直接登录" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    
                    STRONGSELF
                    
                    if (strongSelf) {
                        
                        if (buttonIndex == 0) {
                            
                            [strongSelf.navigationController popViewControllerAnimated:YES];
                        }
                        
                    }
                    
                   
                }];
                
            }else{
                
                [self buildHeadError:@"该手机号码已注册"];
                
            }
            
        }else if ([model.body.isRegister isEqualToString:@"C"]){
            
            if ([model.body.provider isEqualToString:HAIERUAC]) {
                WEAKSELF
                [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"您已经是海尔会员啦，请直接登录" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    
                    STRONGSELF
                    
                    if (strongSelf) {
                        
                        if (buttonIndex == 0) {
                            
                            [strongSelf.navigationController popViewControllerAnimated:YES];
                        }
                        
                    }
                    
                    
                }];
                
            }else{
                
                [self buildHeadError:@"该手机号码已注册"];
                
            }
            
        }else{
            
            NSString *title = NSLocalizedString(@"确认手机号码", nil);
            NSString *message = [NSString stringWithFormat:@"我们将发送短信验证码到这个手机号：%@",_phoneText.text];
            WEAKSELF
            [RMUniversalAlert showAlertInViewController:self withTitle:title message:message cancelButtonTitle:@"取消" destructiveButtonTitle:@"好" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                
                if (strongSelf) {
                    
                    if (buttonIndex == 1) {
                        
                        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
                            
                            [AppDelegate delegate].userInfo.userId = strongSelf.phoneText.text;
                            
                            [strongSelf.delegate sendSaveInfoViewType:MobileType];
                            
                        }
                        
                    }else{
                        
                        return ;
                        
                    }
                    
                }
                
               
            }];
            
        }
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

#pragma mark -->textfield代理协议

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

@end
