//
//  WriteVerificationViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "WriteVerificationViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "VerityPwdViewController.h"
#import "RMUniversalAlert.h"
#import "DefineSystemTool.h"
#import "NewNumberViewController.h"
#import "RMUniversalAlert.h"
#import "BSVKHttpClient.h"
#import <MJExtension.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "CheckCodeHeadModel.h"
#import "EnterAES.h"
#import "WriteVerModel.h"
#import <Bugly/Bugly.h>
#import "NSString+CheckConvert.h"
@interface WriteVerificationViewController ()<BSVKHttpClientDelegate,UITableViewDelegate>
{
    float x;
}
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) UIView *timeView;//验证码底部View
@property (nonatomic, strong) UIView *bjView;//验证码底部View
@property (nonatomic, strong) UIImageView *imageView;//验证码图标
@property (nonatomic, strong) UITextField *VerTextField;

@end

@implementation WriteVerificationViewController
@synthesize timeLab;
#pragma mark - left cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff, 1.0);
    self.navigationItem.title = @"填写验证码";
    if (iphone6P) {
        x = scale6PAdapter;
    }else{
        x = scaleAdapter;
    }
    [self creattopLab];//短信验证码已发送至
    [self creatbottomLab];//验证码：
    [self creatnextBtn];//下一步
    [self setNavi];
    if ([AppDelegate delegate].userInfo.bLoginOK) {
        
    }else{
        if (_getCodeTel.length>0) {
            // 实名认证结束自动发一条验证码
            [self timeCountdown];
        }else{
            [self requestVerification];
        }
    }

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


// -- 短信验证码发送至
-(void)creattopLab{
    UILabel *topLabel = [[UILabel alloc]init];
    NSString *phoneStr = [[NSString alloc]init];

    if ([AppDelegate delegate].userInfo.bLoginOK) {
        
        phoneStr = _strTel;
    }else{
        if (_getCodeTel.length>0) {
            phoneStr = _getCodeTel;
        }else{
            phoneStr = _strTel;
        }
        
    }
    topLabel.text = [NSString stringWithFormat:@"请输入手机%@收到的短信验证码", [phoneStr convertToTelNum]];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.frame = CGRectMake(0, 36 *x,DeviceWidth, 14*x);
    topLabel.textColor = UIColorFromRGB(0x666666, 1.0);
    topLabel.font = [UIFont appFontRegularOfSize:12];
    [self.view addSubview:topLabel];
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
#pragma mark - private Methods

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
                strongSelf.timeLab.textColor = UIColorFromRGB(0x999999, 1);
                strongSelf.timeBtn.userInteractionEnabled = YES;
                
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
                strongSelf.timeLab.textColor = UIColorFromRGB(0x999999, 1);
                strongSelf.timeLab.adjustsFontSizeToFitWidth=YES;
                strongSelf.timeBtn.userInteractionEnabled = NO;
                
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
        //        验证码校验
        [self checkCodeWithTag:104];
    }
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

    if ([AppDelegate delegate].userInfo.bLoginOK) {
        
    }else{
        if (_getCodeTel.length>0) {
             [verDic setObject:StringOrNull([EnterAES simpleEncrypt:_getCodeTel]) forKey:@"phone"];
        }else{
             [verDic setObject:StringOrNull([EnterAES simpleEncrypt:_strTel]) forKey:@"phone"];
        }
       
    }
    BSVKHttpClient * verClient = [BSVKHttpClient shareInstance];
    
    verClient.delegate = self;
    //   发送短信验证码
    [verClient getInfo:@"app/appserver/smsSendVerify" requestArgument:verDic requestTag:200 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
// ----校验验证码-----
- (void)checkCodeWithTag:(NSInteger)tag {
    BSVKHttpClient *codeClient = [BSVKHttpClient shareInstance];
    codeClient.delegate = self;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    if ([AppDelegate delegate].userInfo.bLoginOK) {
        
    }else{
        if (_getCodeTel.length>0) {
            [parmDict setObject:_getCodeTel forKey:@"phone"];
        }else{
             [parmDict setObject:_strTel forKey:@"phone"];
        }
       
    }
    [parmDict setObject:_VerTextField.text forKey:@"verifyNo"];
    [codeClient postInfo:@"app/appserver/smsVerify" requestArgument:parmDict requestTag:tag requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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

        else if (requestTag == 104){//验证码校验
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            CheckCodeHeadModel *headModel = [CheckCodeHeadModel mj_objectWithKeyValues:responseObject];
            
            [self analySisCheckCodeHeadModel:headModel];
            
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
                    strongSelf.timeLab.text =@"点击发送";
                }
            }
        }];
        
    }
}
- (void)analySisCheckCodeHeadModel:(CheckCodeHeadModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        if ([AppDelegate delegate].userInfo.bLoginOK) {
            
            if (_writeVerificationChageBindPhoneNumType == WriteVerificationChanageTelByCheckCode) {
                //通过短信验证修改绑定手机号
                NewNumberViewController *verityVC = [[NewNumberViewController alloc]init];
                verityVC.chageBindNumType = ChangeBindPhoneNumTypeByCheckCode;
                [self.navigationController pushViewController:verityVC animated:YES];
                
            }
            
        }else{
            VerityPwdViewController *verityVC = [[VerityPwdViewController alloc]init];
            verityVC.verifyNo = _VerTextField.text;
            verityVC.telNum = _strTel;
            [self.navigationController pushViewController:verityVC animated:YES];
        }
    }else{//验证码校验错误
        
        [self buildHeadError:model.head.retMsg];
        
    }
}
@end
