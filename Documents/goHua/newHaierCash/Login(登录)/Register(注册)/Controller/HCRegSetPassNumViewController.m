//
//  RegSetPassNumViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCRegSetPassNumViewController.h"
#import "UIFont+AppFont.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "SvUDIDTools.h"
#import "HCMacro.h"
#import "BSVKHttpClient.h"
#import "NSString+CheckConvert.h"
#import "AppDelegate.h"
#import "RegisterModel.h"
#import "DefineSystemTool.h"
#import "EnterAES.h"
#import "StartBrAgent.h"
#import "SignModel.h"
static CGFloat const SetCode = 110;//设置登录密码
static CGFloat const LogonHttp = 100;//账户登录
@interface HCRegSetPassNumViewController ()<BSVKHttpClientDelegate,UITextFieldDelegate>

{
    
    float x;
    
}

@property(nonatomic,strong)UITextField *firstText;//第一次登录密码输入框

@property(nonatomic,strong)UITextField *sureText;//确认支付密码输入框

@property(nonatomic,assign)BOOL hasSaveUser;//是否成功调用设置登录密码接口

@end

#pragma mark --> life Cycle

@implementation HCRegSetPassNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatBaseUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> private Methods
//创建基本视图
-(void)creatBaseUI{
    
    float height;
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
        height = 75;
        
    }else{
        
        x = scaleAdapter;
        
        height = 45;
        
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 97*x, DeviceWidth, 10*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:lineView];

    
    /*-------------------------设置登录密码-----------------------------*/
    
    UIView *firstView = [[UIView alloc]initWithFrame:CGRectMake(47*x, 155*x, DeviceWidth-94*x, 50*x)];
    
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
    
    _firstText.placeholder = @"设置登录密码";
    
    _firstText.delegate = self;
    
    _firstText.returnKeyType = UIReturnKeyDone;
    
    _firstText.secureTextEntry = YES;
    
    [firstView addSubview:_firstText];
    
    /*-------------------------确认登录密码-----------------------------*/

    UIView *sureView = [[UIView alloc]initWithFrame:CGRectMake(47*x, 225*x, DeviceWidth-94*x, 50*x)];
    
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
    
    _sureText.delegate = self;
    
    _sureText.returnKeyType = UIReturnKeyDone;
    
    _sureText.textColor = UIColorFromRGB(0x999999, 1.0);
    
    [sureView addSubview:_sureText];
    
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(47*x, 318*x, DeviceWidth-94*x, 50*x)];
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    nextButton.layer.cornerRadius = 25*x;
    
    nextButton.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    nextButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [nextButton addTarget:self action:@selector(buildToNextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextButton];

    
}

#pragma mark --> event Methods

-(void)buildToNextAction:(UIButton *)sender{
    
    [_firstText resignFirstResponder];
    
    [_sureText resignFirstResponder];
    
    if (_firstText.text.length == 0) {
        
        [self buildHeadError:@"请设置登录密码"];
        
    }else if (![_firstText.text isValidateInput]){
        
        [self buildHeadError:@"请输入6-20位组合字母、数字"];
    }
    else if (_sureText.text.length == 0){
        
        [self buildHeadError:@"请确认登录密码"];
        
    }else if (![_firstText.text isEqualToString:_sureText.text]){
        
        [self buildHeadError:@"两次密码输入不相同"];
        
    }else{
        
        if (_hasSaveUser) {
           
            [self buildPostLogonHtttp];
            
        }else{
          
             [self buildPostJudgeNumber];
            
        }
        
       
        
    }
    
}

#pragma mark --> textField代理协议

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark -->发起网络请求
//进行设置登录密码
-(void)buildPostJudgeNumber{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if ([AppDelegate delegate].userInfo.userId.length > 0) {
        
        [parm setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId] forKey:@"mobile"];
        
    }
    
    if (_firstText.text.length > 0) {
        
        [parm setObject:[EnterAES simpleEncrypt:_firstText.text] forKey:@"password"];
        
    }
    
    if (_verifyNo.length > 0) {
        
        [parm setObject:_verifyNo forKey:@"verifyNo"];
        
    }
    
    [parm setObject:StringOrNull([EnterAES simpleEncrypt:[SvUDIDTools UDID]]) forKey:@"deviceId"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client postInfo:@"app/appserver/uauth/saveUauthUsers" requestArgument:parm requestTag:SetCode requestClass:NSStringFromClass([self class])];
    
}

//用户登录
-(void)buildPostLogonHtttp{
    
    NSMutableDictionary *signDic = [[NSMutableDictionary alloc]init];
    
    [signDic setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId] forKey:@"userId"];
    
    [signDic setObject:[EnterAES simpleEncrypt:_firstText.text] forKey:@"password"];
    
    if ([SvUDIDTools UDID] && ![[SvUDIDTools UDID] isEqualToString:@""]) {
        
        NSString *string = [EnterAES simpleEncrypt:[NSString stringWithFormat:@"IOS-%@-%@",[SvUDIDTools UDID],[AppDelegate delegate].userInfo.userId]];
        
        [signDic setObject:string forKey:@"deviceId"];
        
    }
    
    [signDic setObject:@"IOS" forKey:@"deviceType"];
    
    [signDic setObject:@"login" forKey:@"type"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client putInfo:@"app/appserver/customerLogin" requestArgument:signDic requestTag:LogonHttp requestClass:NSStringFromClass([self class])];
    
}

#pragma mark --> 网络代理协议

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == SetCode) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            RegisterModel *model = [RegisterModel mj_objectWithKeyValues:responseObject];
         
            [self buildHandleSetCode:model];
            
        }else if (requestTag == LogonHttp){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            SignModel *model = [SignModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleLogon:model];
            
        }
        
    }
    
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]){
        
        if (requestTag == LogonHttp) {
            
            _hasSaveUser = YES;
            
        }
        
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
                return;
            }
        }
    }];
    
    
}

#pragma mark --> 处理网络请求成功后的逻辑

//处理登录的请求
-(void)buildHandleLogon:(SignModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        //手机号
        [AppDelegate delegate].userInfo.userTel = StringOrNull(model.body.mobile);
        //账号
        [AppDelegate delegate].userInfo.userId = StringOrNull(model.body.userId);
        //头像
        [AppDelegate delegate].userInfo.userHeader = StringOrNull(model.body.avatarUrl);

        //百融
        [StartBrAgent startBrAgentLogin];
        
        //保存userId
        [DefineSystemTool storeLastUserLoginId:model.body.userId];
        //保存密钥
        [DefineSystemTool setUserPassword:model.body.clientSecret];
        //保存手机号
        [DefineSystemTool storeLastUserTel:model.body.mobile];
        
        if (!isEmptyString(model.body.token.access_token)) {
            
            [[BSVKHttpClient shareInstance]setTokenInHead:model.body.token.access_token tokenType:model.body.token.token_type];
            
            [AppDelegate delegate].userInfo.bLoginOK = YES;
            
            if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
                
                [_delegate sendSaveInfoViewType:PassWordType];
                
            }
            
        }else{
            
            [self buildHeadError:@"获取信息失败，请重试"];
            
        }

        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//处理设置登录密码的请求
-(void)buildHandleSetCode:(RegisterModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        _hasSaveUser = YES;
        
        [AppDelegate delegate].userInfo.userId = model.body.userId;
        
        [AppDelegate delegate].userInfo.userTel = model.body.mobile;
        
        [self buildPostLogonHtttp];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}


@end
