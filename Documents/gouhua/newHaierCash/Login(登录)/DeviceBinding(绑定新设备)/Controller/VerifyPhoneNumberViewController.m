//
//  VerifyPhoneNumberViewController.m
//  personMerchants
//
//  Created by 张久健 on 17/3/6.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "VerifyPhoneNumberViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "RMUniversalAlert.h"
#import "BSVKHttpClient.h"
#import <MJExtension.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "NSString+CheckConvert.h"
#import "EnterAES.h"
#import "WriteVerModel.h"
#import "SvUDIDTools.h"
#import "VerifyPhoneModel.h"
#import "UserSettingModel.h"
#import "SignModel.h"
#import "DefineSystemTool.h"
#import "GestureViewController.h"
#import "StartBrAgent.h"
typedef NS_ENUM(NSInteger,LoginVCGetInfoType)
{
    LoginVCGetInfoTypeRealName = 1,    //只获取实名的情况
    LoginVCGetInfoTypeAllQuateApply,   //第一次提额
    LoginVCGetInfoTypeAllQuateSecond,  //被退回
};
@interface VerifyPhoneNumberViewController ()<BSVKHttpClientDelegate,UITableViewDelegate>

{
    UIView *topView;
    LoginVCGetInfoType _getInfoType;   //获取信息的type
    NSString *clientSecret;//登录接口成功
    float x;
    
}
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIView *bjView;
@property (nonatomic, strong) UITextField *VerTextField;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) UIImageView *imageView;//验证码图标

@end

@implementation VerifyPhoneNumberViewController
@synthesize timeLab;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    self.navigationItem.title = @"填写验证码";

    if (iphone6P) {
        x = scale6PAdapter;
    }else{
        x = scaleAdapter;
    }
    [self creatbottomLab];//验证码：
    [self creatnextBtn];//下一步
    [self setNavi];
    [self requestVerification];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_VerTextField resignFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
#pragma mark - setting and getting
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

// -- 验证码：
-(void)creatbottomLab{
    _bjView = [[UIView alloc]initWithFrame:CGRectMake(45 *x, 65*x, DeviceWidth-200*x, 45*x)];
    _bjView.layer.cornerRadius = 22.5*x;
    _bjView.backgroundColor = UIColorFromRGB(0xeeeeee, 1);
    [self.view addSubview:_bjView];
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20*x, 14*x, 17*x, 17*x)];
    _imageView.image = [UIImage imageNamed:@"注册验证码"];
    [_bjView addSubview:_imageView];
    
    _VerTextField = [[UITextField alloc]initWithFrame:CGRectMake(49*x, 0, DeviceWidth-265*x, 45*x)];
    _VerTextField.placeholder =@"请输入验证码";
    _VerTextField.textColor = UIColorFromRGB(0x999999, 1.0);
    _VerTextField.font = [UIFont appFontRegularOfSize:13*x];
    [_bjView addSubview:_VerTextField];
    
    _timeView =[[UIView alloc]initWithFrame:CGRectMake(DeviceWidth-145*x, 65*x, 100*x, 45*x)];
    _timeView.layer.cornerRadius = 22.5*x;
    _timeView.backgroundColor = UIColorFromRGB(0xeeeeee, 1);
    [self.view addSubview:_timeView];
    
    timeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100*x, 45*x)];
    timeLab.text =@"点击发送";
    timeLab.textColor = UIColorFromRGB(0x999999, 1);
    timeLab.font = [UIFont systemFontOfSize:13*x];
    timeLab.textAlignment = NSTextAlignmentCenter;
    [_timeView addSubview:timeLab];
    
    _timeBtn =[[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-145*x, 65*x, 100*x, 45*x)];
    _timeBtn.layer.cornerRadius = 22.5*x;
    _timeBtn.backgroundColor = [UIColor clearColor];
    [_timeBtn addTarget:self action:@selector(requestVerification) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timeBtn];
}

-(void)creatnextBtn{
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    nextBtn.frame = CGRectMake(45*x, 145*x, DeviceWidth-90*x, 45*x);
    nextBtn.layer.cornerRadius = 22.5*x;
    [nextBtn setBackgroundColor: UIColorFromRGB(0x32beff, 1.0)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont appFontRegularOfSize:15*x];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:nextBtn];
    
    [nextBtn addTarget:self action:@selector(btnNextClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)OnBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)timeCountdown {
    WEAKSELF
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        STRONGSELF
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                strongSelf.timeLab.text = @"重新发送";
                strongSelf.timeLab.userInteractionEnabled = YES;
            });
        }else{
            //            int minutes = timeout / 60;
            
            int seconds = timeout % 60;
            NSString *strTime ;
            if (timeout == 60) {
                strTime = @"60";
            }
            else
                strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.timeLab.text = [NSString stringWithFormat:@"%@s后重发",strTime];
                strongSelf.timeLab.adjustsFontSizeToFitWidth=YES;
                strongSelf.timeLab.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

- (void)btnNextClick {
    
    [_VerTextField resignFirstResponder];
    
    if (_VerTextField.text.length == 0) {
        
        [self buildHeadError:@"请输入验证码"];
        return;
    }else{
        if (![_VerTextField.text isValidateInput]) {
            [self buildHeadError:@"验证码不能包含特殊字符"];
            
            return;
        }
        if (clientSecret.length>0) {
            [self getSettingInfo];
        }else{
            [self verifyAndBindDeviceId];
        }
    }
}
-(void)verifyAndBindDeviceId{
    NSMutableDictionary *verDic = [[NSMutableDictionary alloc]init];
    if (_mobile){
        
        [verDic setObject:_mobile forKey:@"phone"];
        
    }
    [verDic setObject:[EnterAES simpleEncrypt:StringOrNull(_fieldName)] forKey:@"userId"];
    [verDic setObject:_VerTextField.text forKey:@"verifyNo"];
    [verDic setObject:StringOrNull([EnterAES simpleEncrypt:[SvUDIDTools UDID]]) forKey:@"deviceId"];
    [verDic setObject:@"IOS" forKey:@"deviceType"];
    BSVKHttpClient * verClient = [BSVKHttpClient shareInstance];
    
    verClient.delegate = self;
    
    [verClient postInfo:@"app/appserver/verifyAndBindDeviceId" requestArgument:verDic requestTag:100 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
//弹框
- (void)alertWithString:(NSString *)message{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:message cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            
        }
    }];
}
#pragma mark -- 请求
-(void)requestVerification{
    
    NSMutableDictionary *verDic = [[NSMutableDictionary alloc]init];
    if (_mobile){
        
        [verDic setObject:[EnterAES simpleEncrypt:_mobile] forKey:@"phone"];
        
        
    }    BSVKHttpClient * verClient = [BSVKHttpClient shareInstance];
    
    verClient.delegate = self;
    //   发送短信验证码
    [verClient getInfo:@"app/appserver/smsSendVerify" requestArgument:verDic requestTag:200 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
//得到设置信息
- (void)getSettingInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/uauth/validateUserFlag" requestArgument:@{@"userId":[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId]} requestTag:3 requestClass:NSStringFromClass([self class])];
    
}

#pragma mark - BSVK Delegate
//请求成功
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 200){//验证码发送成功
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            WriteVerModel *model = [WriteVerModel mj_objectWithKeyValues:responseObject];
            
            [self analySisWriteVerModel:model];
            
            
        }
        else if (requestTag == 100){

            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            SignModel *model = [SignModel mj_objectWithKeyValues:responseObject];
            
            [self VerifyPhoneModel:model];
            
        }
        else if (requestTag == 3) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UserSettingModel *model = [UserSettingModel mj_objectWithKeyValues:responseObject];
            if ([model.head.retFlag isEqualToString:@"00000"]) {
                
                
                if ([model.body.payPasswdFlag isEqualToString:@"0"]) {
                    //没有设置支付密码
                    [AppDelegate delegate].userInfo.bsetPayPwd = NO;
                }else {
                    //设置了支付密码
                    [AppDelegate delegate].userInfo.bsetPayPwd = YES;
                }
                
                
                if ([model.body.gestureFlag isEqualToString:@"0"]) {
                    [AppDelegate delegate].userInfo.bsetGuestPwd = NO;
                    //未设置手势密码
                    GestureViewController *HCVC = [[GestureViewController alloc]init];
                    HCVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:HCVC animated:YES];
                }else {
                    [AppDelegate delegate].userInfo.bsetGuestPwd = YES;
                   //设置了手势密码
                    [self dismissViewControllerAnimated:YES completion:nil];

                }
            }else {
                [AppDelegate delegate].userInfo.bsetGuestPwd = NO;
                WEAKSELF
                [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    STRONGSELF
                    if (strongSelf) {
                        if (buttonIndex == 0) {
                            
                        }
                    }
                }];
            }
        }
    }
}
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]){
        
        if(httpCode != 0)
        {
            [self buildHeadError:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",httpCode]];
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
- (void)analySisWriteVerModel:(WriteVerModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        NSLog(@"发送验证码成功");
        [self timeCountdown];
        
    }else{
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
        
    }
}
-(void)VerifyPhoneModel:(SignModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [AppDelegate delegate].userInfo.bLoginOK = YES;
        
        if ([model.body.provider isEqualToString:@"HAIERUAC"]){
            
            if ([AppDelegate delegate].userInfo.whiteType == WhiteNoCheck||![AppDelegate delegate].userInfo.whiteType) {
                
                [AppDelegate delegate].userInfo.haierVipState = IsHaierVip;
                
            }
            
        }
        if ([model.body.isRealInfo isEqualToString:@"Y"]) {
            
            [[AppDelegate delegate].userInfo initRealNameInfo:model.body.realInfo];
        }else{
            
        }
        //手机号  解密
        [AppDelegate delegate].userInfo.userTel = StringOrNull(model.body.mobile);
        //账号
        [AppDelegate delegate].userInfo.userId = StringOrNull(model.body.userId);
        [DefineSystemTool storeLastUserLoginId:model.body.userId];
        //头像
        [AppDelegate delegate].userInfo.userHeader = StringOrNull(model.body.avatarUrl);
        //百融
        [StartBrAgent startBrAgentLogin];
        
        if (_boRemember == YES) {

            //保存userId
            [DefineSystemTool storeLastUserLoginId:model.body.userId];
            //保存密钥
            [DefineSystemTool setUserPassword:model.body.clientSecret];
            //保存手机号
            [DefineSystemTool storeLastUserTel:model.body.mobile];
            //保存登录号
            [DefineSystemTool storeLastLoginTel:_fieldName];
            
            NSLog(@"密码%@",[DefineSystemTool userPassword]);
            
            NSLog(@"账号是%@",[DefineSystemTool getLastUserLoginId]);
            
        }
        if (!isEmptyString(model.body.token.access_token)) {
            
            [[BSVKHttpClient shareInstance]setTokenInHead:model.body.token.access_token tokenType:model.body.token.token_type];
            clientSecret = @"Y";
        }
        
        [AppDelegate delegate].userInfo.bLoginOK = YES;
//        [[AppDelegate delegate]loginSucessXinge];
        NSLog(@"自动登录，bLoginOK = YES");
        NSLog(@"token == %@",model.body.token);
        
        //请求设置信息
        [self getSettingInfo];
        
    }else{
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
        
    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark textField Delegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_VerTextField resignFirstResponder];
}



- (void)dealloc {
    
}

@end

