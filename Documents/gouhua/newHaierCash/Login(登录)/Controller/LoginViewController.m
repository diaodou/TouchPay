//
//  LoginViewController.m
//  newHaierCash
//
//  Created by 张久健 on 2017/6/1.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "LoginViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "DefineSystemTool.h"
#import "HCUserModel.h"
#import "AppDelegate.h"
#import "NSString+CheckConvert.h"
#import "BSVKHttpClient.h"
#import "MBProgressHUD.h"
#import "EnterAES.h"
#import "SvUDIDTools.h"
#import "SignModel.h"
#import "RMUniversalAlert.h"
#import "VersionModel.h"
#import "UserSettingModel.h"
#import "ValidateLogonViewController.h"
#import "HCRootNavController.h"
#import "GestureViewController.h"
#import "RegisterModel.h"
#import "PMWebViewController.h"
#import "RecoveryLoginViewController.h"
#import "HCHomeController.h"
#import "UnlockAccountViewController.h"
#import "StartBrAgent.h"
#import "HCRootTabController.h"
static const CGFloat flushVerifyImage = 200;

@interface LoginViewController ()<UITextFieldDelegate,BSVKHttpClientDelegate>
{
    
    BOOL identical;//新账号与老账号是否相同
    CGFloat _moveDistance;//数据
}
@property (nonatomic,strong) UIView *topInputView;//输入框底部View
@property (nonatomic,strong) UIView *verificationView;//验证码View
@property (nonatomic,strong) UITextField *verificationText;//验证码输入框
@property (nonatomic,strong) UIImageView *verificationImgView;//验证码图片
@property (nonatomic,strong) UIImageView *bottomImg;//背景图
@property (nonatomic,strong) UITextField *fieldPass;//密码
@property (nonatomic,strong) UITextField *fieldName;//账号
@property (nonatomic,strong) NSString *stateStr; //点击哪个按钮的流程
@property (nonatomic,strong) PMWebViewController *forgetPasswordController;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    if (![DefineSystemTool isRemeberPwd]) {
        [DefineSystemTool setRemeberPwd:YES];
    }
    [self createData]; //生成初始数据
    [self createUI];
    [self setArrow];//返回键图标及方法
    if ([DefineSystemTool getLastLoginTel].length>0) {
        _fieldName.text = [DefineSystemTool getLastLoginTel];
    }
    
    [AppDelegate delegate].userInfo.bLoginOK = NO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (_forgetPasswordController) {
        _forgetPasswordController = nil;
    }
    
    if (_model && _model.body.captchaImage.length && self.userId.length > 0) {
        _fieldPass.returnKeyType = UIReturnKeyNext;
        _fieldName.text = self.userId;
        CGRect topViewRect = self.topInputView.frame;
        self.topInputView.frame = CGRectMake(topViewRect.origin.x, topViewRect.origin.y - _moveDistance, topViewRect.size.width, topViewRect.size.height);
        [self.view addSubview:self.verificationView];
        [self resetVerificationImage];
        
    }


}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    _fieldName.text = nil;
    _fieldPass.text = nil;
    
    if (_verificationView && _verificationView.superview) {
        _fieldPass.returnKeyType = UIReturnKeyDone;
        CGRect topViewRect = self.topInputView.frame;
        _verificationText.text = nil;
        [_verificationImgView setImage:nil];
        [self.verificationView removeFromSuperview];
        self.topInputView.frame = CGRectMake(topViewRect.origin.x, topViewRect.origin.y + _moveDistance, topViewRect.size.width, topViewRect.size.height);
        _model = nil;
        self.userId = nil;
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    
    
    [super viewDidDisappear:animated];
    
    //    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - Private Methods
#pragma mark  --绘制UI--
-(void)createUI{
    [self createBottomImg];//背景图
    [self createInPut];//输入框及图标
//    [self creatSmallView];//记住密码
    [self creatGoBtn];//登录、注册、忘记密码按钮
}
//背景图
-(void)createBottomImg{
    _bottomImg = [[UIImageView alloc]initWithFrame:self.view.frame];
    _bottomImg.userInteractionEnabled = YES;
    if (IPHONE4){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"登录背景图4S" ofType:@"png"];
        UIImage *bjImage = [UIImage imageWithContentsOfFile:path];
        _bottomImg.image = bjImage;
    }
    else if (iPhone5){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"登录背景图5S" ofType:@"png"];
        UIImage *bjImage = [UIImage imageWithContentsOfFile:path];
        _bottomImg.image = bjImage;
    }
    else if (iphone6){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"登录背景图6" ofType:@"png"];
        UIImage *bjImage = [UIImage imageWithContentsOfFile:path];
        _bottomImg.image = bjImage;
    }else{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"登录背景图6P" ofType:@"png"];
        UIImage *bjImage = [UIImage imageWithContentsOfFile:path];
        _bottomImg.image = bjImage;
    }
    [self.view addSubview:_bottomImg];
}
//输入框及图标
-(void)createInPut{
    self.topInputView = [UIView new];
    [self.view addSubview:_topInputView];
    UIView *fieldNameView = [[UIView alloc]init];
    fieldNameView.backgroundColor = UIColorFromRGB(0x7f7f7f, 0.5);
    UIView *fieldPassView = [[UIView alloc]init];
    fieldPassView.backgroundColor = UIColorFromRGB(0x7f7f7f, 0.5);
    [_topInputView addSubview:fieldNameView];
    [_topInputView addSubview:fieldPassView];
    _fieldName = [self _generateTextFieldWithPlaceholder:@"手机号"];
    _fieldName.returnKeyType = UIReturnKeyNext;
    [fieldNameView addSubview:_fieldName];
    
    _fieldPass =[self _generateTextFieldWithPlaceholder:@"请输入登录密码"];
    _fieldPass.secureTextEntry = YES;
    _fieldPass.returnKeyType = UIReturnKeyDone;
    [fieldPassView addSubview:_fieldPass];
    
    UIImageView *nameImgView = [[UIImageView alloc]init];
    nameImgView.image = [UIImage imageNamed:@"登录_手机号"];
    [fieldNameView addSubview:nameImgView];
    UIImageView *passImgView = [[UIImageView alloc]init];
    passImgView.image = [UIImage imageNamed:@"登录_密码"];
    [fieldPassView addSubview:passImgView];
    
    if (iphone6P) {
        // 一行64
        _topInputView.frame = CGRectMake(0, 492, DeviceWidth, 110);
        fieldNameView.frame =CGRectMake(48, 0, DeviceWidth-96, 50);
        fieldNameView.layer.cornerRadius = 25.f;
        fieldPassView.frame =CGRectMake(48, 60, DeviceWidth-96, 50);
        fieldPassView.layer.cornerRadius = 25.f;
        _fieldName.frame = CGRectMake(50, 0, DeviceWidth-147, 50);
        _fieldName.font = [UIFont appFontRegularOfSize:15];
        _fieldPass.frame = CGRectMake(50, 0, DeviceWidth-147, 50);
        _fieldPass.font = [UIFont appFontRegularOfSize:15];
        nameImgView.frame = CGRectMake(20, 17, 16, 16);
        passImgView.frame = CGRectMake(20, 17, 16, 16);
    } else if (iphone6) {
        // 一行59
        _topInputView.frame = CGRectMake(0, 445, DeviceWidth, 100);
        fieldNameView.frame =CGRectMake(40, 0, DeviceWidth-80, 45);
        fieldNameView.layer.cornerRadius = 22.f;
        fieldPassView.frame =CGRectMake(40, 55, DeviceWidth-80, 45);
        fieldPassView.layer.cornerRadius = 22.f;
        _fieldName.frame = CGRectMake(45, 0, DeviceWidth-128, 45);
        _fieldPass.frame = CGRectMake(45, 0, DeviceWidth-128, 45);
        _fieldName.font = [UIFont appFontRegularOfSize:13];
        _fieldPass.font = [UIFont appFontRegularOfSize:13];
        nameImgView.frame = CGRectMake(18, 15, 15, 15);
        passImgView.frame = CGRectMake(18, 15, 15, 15);
    } else if (iPhone5) {
        // 一行59
        _topInputView.frame = CGRectMake(0, 375, DeviceWidth, 85);
        fieldNameView.frame =CGRectMake(40, 0, DeviceWidth-80, 40);
        fieldNameView.layer.cornerRadius = 20.f;
        fieldPassView.frame =CGRectMake(40, 45, DeviceWidth-80, 40);
        fieldPassView.layer.cornerRadius = 20.f;
        _fieldName.frame = CGRectMake(44, 0, DeviceWidth-127, 40);
        _fieldPass.frame = CGRectMake(44, 0, DeviceWidth-127, 40);
        _fieldName.font = [UIFont appFontRegularOfSize:12];
        _fieldPass.font = [UIFont appFontRegularOfSize:12];
        nameImgView.frame = CGRectMake(18, 13, 14, 14);
        passImgView.frame = CGRectMake(18, 13, 14, 14);
    } else if (IPHONE4) {
        // 一行42
        _topInputView.frame = CGRectMake(0, 300, DeviceWidth, 85);
        fieldNameView.frame =CGRectMake(40, 0, DeviceWidth-80, 40);
        fieldNameView.layer.cornerRadius = 20.f;
        fieldPassView.frame =CGRectMake(40, 45, DeviceWidth-80, 40);
        fieldPassView.layer.cornerRadius = 20.f;
        _fieldName.frame = CGRectMake(44, 0 , 183, 40);
        _fieldPass.frame = CGRectMake(44, 0 , 183, 40);
        _fieldName.font = [UIFont appFontRegularOfSize:12];
        _fieldPass.font = [UIFont appFontRegularOfSize:12];
        nameImgView.frame = CGRectMake(18, 13, 14, 14);
        passImgView.frame = CGRectMake(18, 13, 14, 14);
    }
    
    
}
- (UITextField *)_generateTextFieldWithPlaceholder:(NSString *)placeholder {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.clearButtonMode = UITextAutocapitalizationTypeAllCharacters;
    textField.delegate = self;
    textField.textColor = [UIColor whiteColor];
    textField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:placeholder attributes:@{NSForegroundColorAttributeName :[UIColor whiteColor],NSFontAttributeName:[UIFont appFontRegularOfSize:15]}];
    return textField;
}

//登录注册按钮
-(void)creatGoBtn{
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
//    [loginBtn setTitleColor:[UIColor colorWithRed:0.0588 green:0.3882 blue:0.6863 alpha:1.0] forState:UIControlStateNormal];
    loginBtn.tintColor = [UIColor whiteColor];
    loginBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
    loginBtn.backgroundColor = UIColorFromRGB(0x32beff, 1);
    [loginBtn addTarget:self action:@selector(GoToNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    if (iphone6P) {
        loginBtn.frame = CGRectMake(48, 622, DeviceWidth-96, 50);
        loginBtn.layer.cornerRadius = 25.f;
    } else if (iphone6) {
        loginBtn.frame = CGRectMake(40, 563, DeviceWidth-80, 45);
        loginBtn.layer.cornerRadius = 22.f;
    } else if (iPhone5) {
        loginBtn.frame = CGRectMake(40, 470, DeviceWidth-80, 40);
        loginBtn.layer.cornerRadius = 20.f;
    } else if (IPHONE4) {
        loginBtn.frame = CGRectMake(40, 395, DeviceWidth-80, 40);
        loginBtn.layer.cornerRadius = 20.f;
    }
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [registerBtn setTitle:@"手机快速注册" forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont appFontRegularOfSize:13];
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    registerBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    registerBtn.layer.borderWidth = 0.0f;
    registerBtn.tintColor = UIColorFromRGB(0x666666, 1);
    [registerBtn addTarget:self action:@selector(Register) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    if (iphone6P) {
        registerBtn.frame = CGRectMake(52, 672+15, DeviceWidth/4, 25);
    } else if (iphone6) {
        registerBtn.frame = CGRectMake(40, 590+27, DeviceWidth/4, 25);
    } else if (iPhone5) {
        registerBtn.frame = CGRectMake(40, 520, DeviceWidth/4, 25);
    } else if (IPHONE4) {
        registerBtn.frame = CGRectMake(40, 440, DeviceWidth/4, 25);
    }
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont appFontRegularOfSize:13];
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    forgetBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    forgetBtn.layer.borderWidth = 0.0f;
    forgetBtn.tintColor = UIColorFromRGB(0x666666, 1);
    [forgetBtn addTarget:self action:@selector(ForgotPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    if (iphone6P) {
        forgetBtn.frame = CGRectMake(361-DeviceWidth/4, 672 +15, DeviceWidth/4, 25);
    } else if (iphone6) {
        forgetBtn.frame = CGRectMake(328-DeviceWidth/4, 590 +27, DeviceWidth/4, 25);
    } else if (iPhone5) {
        forgetBtn.frame = CGRectMake(277-DeviceWidth/4, 520, DeviceWidth/4, 25);
    } else if (IPHONE4) {
        forgetBtn.frame = CGRectMake(275-DeviceWidth/4, 440, DeviceWidth/4, 25);
    }
}
//绘制头部箭头
- (void)setArrow{
    UIImageView * arrowBack = [UIImageView new];
    arrowBack.image = [UIImage imageNamed:@"头部箭头"];
    UIButton * arrowBackAction = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [arrowBackAction addTarget:self action:@selector(arrowBackAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_bottomImg addSubview:arrowBack];
    [_bottomImg addSubview:arrowBackAction];
    if (iphone6P) {
        arrowBack.frame = CGRectMake(21, 34, 11, 13);
        arrowBackAction.frame = CGRectMake(10, 25, 30, 30);
    }else if (iphone6){
        arrowBack.frame = CGRectMake(20, 31, 10, 12);
        arrowBackAction.frame = CGRectMake(10, 20, 40, 30);
    }else {
        arrowBack.frame = CGRectMake(16, 27, 8, 10);
        arrowBackAction.frame = CGRectMake(10, 20, 30, 30);
    }
    
}
//验证码
- (UIView *)verificationView {
    if (!_verificationView) {
        _verificationView = [UIView new];
        _verificationView.backgroundColor = [UIColor clearColor];
        
        UIView *verificatView = [[UIView alloc]init];
        verificatView.backgroundColor = UIColorFromRGB(0x7f7f7f, 0.5);
        [_verificationView addSubview:verificatView];
        
        UIImageView *img = [UIImageView new];
        img.image = [UIImage imageNamed:@"验证码"];
        [verificatView addSubview:img];
        
        self.verificationText = [self _generateTextFieldWithPlaceholder:@"验证码"];
        [_verificationText setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_verificationText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [verificatView addSubview:_verificationText];
        _verificationText.returnKeyType = UIReturnKeyDone;
        
        self.verificationImgView = [UIImageView new];
        _verificationImgView.backgroundColor = [UIColor redColor];
        [_verificationView addSubview:_verificationImgView];
        _verificationImgView.userInteractionEnabled = YES;
        [_verificationImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_flushVerifyImage)]];

        if (iphone6P) {
            _verificationView.frame = CGRectMake(0, 552, DeviceWidth, 50);
            verificatView.frame = CGRectMake(48, 0, DeviceWidth-240, 50);
            verificatView.layer.cornerRadius = 25.f;
            img.frame = CGRectMake(20, 17, 16, 16);
            _verificationText.frame = CGRectMake(50, 0, DeviceWidth-290, 50);
            _verificationText.font = [UIFont appFontRegularOfSize:15];
            _verificationImgView.frame = CGRectMake(DeviceWidth-180, 5, 110, 40);
        } else if (iphone6) {
            _verificationView.frame = CGRectMake(0, 497, DeviceWidth, 45);
            verificatView.frame = CGRectMake(40, 0, DeviceWidth-220, 45);
            verificatView.layer.cornerRadius = 20.f;
            img.frame = CGRectMake(18, 15, 15, 15);
            _verificationText.frame = CGRectMake(45, 0, DeviceWidth-270, 44);
            _verificationText.font = [UIFont appFontRegularOfSize:13];
            _verificationImgView.frame = CGRectMake(DeviceWidth-160 , 3, 100, 35);
            
        } else if (iPhone5) {
            _verificationView.frame = CGRectMake(0, 410, DeviceWidth, 40);
            verificatView.frame = CGRectMake(42, 0, DeviceWidth-175, 40);
            verificatView.layer.cornerRadius = 20.f;
            img.frame = CGRectMake(18, 13, 14, 14);
            _verificationText.frame = CGRectMake(44, 0, DeviceWidth-227, 40);
            _verificationText.font = [UIFont appFontRegularOfSize:12];
            _verificationImgView.frame = CGRectMake(DeviceWidth-125, 5, 80, 30);
            
        } else if (IPHONE4) {
            _verificationView.frame = CGRectMake(0, 348, DeviceWidth, 40);
            verificatView.frame = CGRectMake(42, 0, DeviceWidth-175, 40);
            verificatView.layer.cornerRadius = 20.f;
            img.frame = CGRectMake(18, 13, 14, 140);
            _verificationText.frame = CGRectMake(44, 0, DeviceWidth-227, 40);
            _verificationText.font = [UIFont appFontRegularOfSize:12];
            _verificationImgView.frame = CGRectMake(DeviceWidth-125, 5, 80, 30);
        }
        
    }
    return _verificationView;
}

#pragma mark - Button Response 按钮点击事件

//登录点击
-(void)GoToNext{
    if (_fieldName.text.length == 0) {
        [self buildHeadError:@"请输入用户名"];
        return;
    }

    if (![_fieldName.text isValidateMobileNum]) {
        [self buildHeadError:@"请输入11位手机号"];
        return;
    }
    
    if (_fieldPass.text.length == 0){
        [self buildHeadError: @"请输入密码"];
        return;
    }
    //需要验证的信息为空
    else if (_verificationView && _verificationView.superview && _verificationText.text.length == 0) {
         [self buildHeadError: @"请输入验证码"];
        return;
    }
    //检测是否在维护中
    [self checkSystemMaintain];
    _stateStr = @"登录";
}
//注册点击
-(void)Register{
    _stateStr = @"注册";
    [self checkSystemMaintain];
}
//忘记密码
-(void)ForgotPassword{
    NSString *fildNameStr = [_fieldName.text deleteSpeaceString];
    if (![fildNameStr isValidateMobileNum]) {//判断11位纯数字
        [self buildHeadError:@"请输入11位绑定手机号"];
        return;
    }

    _stateStr = @"忘记密码";
    [self checkSystemMaintain];
}
//头部箭头点击事件
-(void)arrowBackAction{
    
    if (_fromType == fromOther) {
        UIViewController *rootVC = self.presentingViewController;
        
        while (rootVC.presentingViewController) {
            rootVC = rootVC.presentingViewController;
        }
        
        if ([rootVC isKindOfClass:[HCRootTabController class]]) {
            HCRootTabController *tabCon = (HCRootTabController *)rootVC;
            UINavigationController *con = tabCon.selectedViewController;
            [con popToRootViewControllerAnimated:YES];
            [rootVC dismissViewControllerAnimated:NO completion:nil];
            tabCon.selectedIndex = 0;

        }
        
    }else{
        [self dismissViewControllerAnimated: YES completion:nil];
    }
    
}
#pragma mark - 请求服务获取数据
//检测是否在维护中
- (void)checkSystemMaintain
{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
        BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
        client.delegate = self;
        NSString *strVersion = [DefineSystemTool VersionShort];
    
        NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
        [parmDic setObject:StringOrNull(strVersion) forKey:@"version"];
        [parmDic setObject:@"ios" forKey:@"sysVersion"];
        [parmDic setObject:@"customer" forKey:@"versionType"];
    
        [client getInfo:@"app/appmanage/version/check" requestArgument:parmDic requestTag:222 requestClass:NSStringFromClass([self class])];
}
- (void)login
{
    [[BSVKHttpClient shareInstance]setTokenInHead:@"" tokenType:@""];
    
    //账号/密码/验证码(如果有的话)不为空
    //去掉空格
    NSString *userId = [_fieldName.text deleteSpeaceString];
    
    if (userId && userId.length > 0 ) {
        
        _fieldName.text = userId;
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *signDic = [[NSMutableDictionary alloc]init];
    
    [signDic setObject:[EnterAES simpleEncrypt:_fieldName.text] forKey:@"userId"];
    
    [signDic setObject:[EnterAES simpleEncrypt:_fieldPass.text] forKey:@"password"];
    
    //如果有验证信息
    if (_model && _model.body.captchaImage && _model.body.captchaToken) {
        [signDic setObject:[EnterAES simpleEncrypt:_model.body.captchaToken] forKey:@"captchaToken"];
        
        [signDic setObject:[EnterAES simpleEncrypt:_verificationText.text] forKey:@"captchaAnswer"];
    }
    if ([SvUDIDTools UDID] && ![[SvUDIDTools UDID] isEqualToString:@""]) {
        NSString *string = [EnterAES simpleEncrypt:[NSString stringWithFormat:@"IOS-%@-%@",[SvUDIDTools UDID],_fieldName.text]];
        [signDic setObject:string forKey:@"deviceId"];
    }
    
    [signDic setObject:@"IOS" forKey:@"deviceType"];
    
    [signDic setObject:@"login" forKey:@"type"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    NSLog(@"账号密码是:%@,%@",_fieldName.text,_fieldPass.text);
    
    [client putInfo:@"app/appserver/customerLogin" requestArgument:signDic requestTag:10 requestClass:NSStringFromClass([self class])];
}
//此账号是否注册过
- (void)isRegesterWithStrTel:(NSString *)strTel{
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    [client getInfo:@"app/appserver/uauth/isRegister" requestArgument:@{@"mobile":[EnterAES simpleEncrypt:strTel]} requestTag:111 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

//得到用户支付密码手势密码验证是否设置信息
- (void)getSettingInfo
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/uauth/validateUserFlag" requestArgument:@{@"userId":[EnterAES simpleEncrypt:_model.body.userId]} requestTag:3 requestClass:NSStringFromClass([self class])];
    
}

//刷新验证码
- (void)_flushVerifyImage {
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    [client getInfo:@"app/appserver/uauth/haierCaptcha" requestArgument:nil requestTag:flushVerifyImage requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
#pragma mark - BSVKDelegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 10) {
            //登录接口
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            _model = [SignModel mj_objectWithKeyValues:responseObject];
            
            [self manageLogin:_model];
            
        }
        else if (requestTag == 3) {
            //获取设置信息
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UserSettingModel *model = [UserSettingModel mj_objectWithKeyValues:responseObject];
            [self manageValidateUserFlag:model];
            
        }
            else if (requestTag == 111)
        {
            //判断账号是否冻结
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            RegisterModel * model = [RegisterModel mj_objectWithKeyValues:responseObject];
            
            [self manageIsRegister:model];
            
        }
        else if (requestTag == 222)
        {
            //系统是否需要更新
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            VersionModel *model = [VersionModel mj_objectWithKeyValues:responseObject];
            [self manageCheck:model];
            
        }
        else if (requestTag == flushVerifyImage) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            _model = [SignModel mj_objectWithKeyValues:responseObject];
            if ([_model.head.retFlag isEqualToString:@"00000"])
            {
                [self resetVerificationImage];
            } else{
                [self buildHeadError:_model.head.retMsg];
            }
            
        }
        
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
#pragma mark --> 网络请求数据处理
-(void)manageLogin:(SignModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        NSString *olduserId = [DefineSystemTool getLastLoginTel];
        
        if ([olduserId isEqualToString:_fieldName.text]) {
            identical = YES;
        }else{
            identical = NO;
        }
        
        [AppDelegate delegate].userInfo.bLoginOK = YES;
        
        if ([model.body.provider isEqualToString:@"HAIERUAC"] && ([AppDelegate delegate].userInfo.whiteType == WhiteNoCheck||![AppDelegate delegate].userInfo.whiteType)) {
            
            [AppDelegate delegate].userInfo.haierVipState = IsHaierVip;
        }
        if ([model.body.isRealInfo isEqualToString:@"Y"]) {
            
            [[AppDelegate delegate].userInfo initRealNameInfo:model.body.realInfo];
        }else{
            
        }
        //手机号  解密
        [AppDelegate delegate].userInfo.userTel = StringOrNull(model.body.mobile);
        //账号
        [AppDelegate delegate].userInfo.userId = StringOrNull(model.body.userId);
        
        NSLog(@"mobile = %@",[AppDelegate delegate].userInfo.userId);
        
        [DefineSystemTool storeLastUserLoginId:model.body.userId];
        //头像
        [AppDelegate delegate].userInfo.userHeader = StringOrNull(model.body.avatarUrl);
        //百融
        [StartBrAgent startBrAgentLogin];
        
        if ([DefineSystemTool isRemeberPwd]) {
            //保存userId
            [DefineSystemTool storeLastUserLoginId:model.body.userId];
            //保存密钥
            [DefineSystemTool setUserPassword:model.body.clientSecret];
            //保存手机号
            [DefineSystemTool storeLastUserTel:model.body.mobile];
            //保存登录号
            [DefineSystemTool storeLastLoginTel:_fieldName.text];
            
            NSLog(@"密码%@",[DefineSystemTool userPassword]);
            
            NSLog(@"账号是%@",[DefineSystemTool getLastUserLoginId]);
            
        }
        if (!isEmptyString(model.body.token.access_token)) {
            
            [[BSVKHttpClient shareInstance]setTokenInHead:model.body.token.access_token tokenType:model.body.token.token_type];
        }
        
        //                [[AppDelegate delegate]loginSucessXinge];
        NSLog(@"自动登录，bLoginOK = YES");
        NSLog(@"token == %@",model.body.token);
        
        //请求设置信息
        [self getSettingInfo];
    }else if ([model.head.retFlag isEqualToString:@"U0169"]){
        ValidateLogonViewController *Vc = [[ValidateLogonViewController alloc]init];
        
        Vc.fieldName = _fieldName.text;
        
        Vc.fieldPass = _fieldPass.text;
        Vc.boRemember = YES;
        Vc.mobile = model.body.mobile;
        
        [self.navigationController pushViewController:Vc animated:YES];
        
    }else if ([model.head.retFlag isEqualToString:@"U0173"]){
        self.userId = _fieldName.text;
        if (_verificationView && _verificationView.superview) {
            [self resetVerificationImage];
            [self buildHeadError:model.head.retMsg];
            return;
        }
        _fieldPass.returnKeyType = UIReturnKeyNext;
        CGRect topViewRect = self.topInputView.frame;
        [UIView animateWithDuration:.3 animations:^{
            self.topInputView.frame = CGRectMake(topViewRect.origin.x, topViewRect.origin.y - _moveDistance, topViewRect.size.width, topViewRect.size.height);
            
        } completion:^(BOOL finished) {
            [self.view addSubview:self.verificationView];
            [self resetVerificationImage];
        }];
        [self buildHeadError:model.head.retMsg];
    }else {
        
        [self buildHeadError:model.head.retMsg];
        
    }
}
-(void)manageValidateUserFlag:(UserSettingModel *)model{
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
            if (_fromType == fromLogin) {
                GestureViewController *HCVC = [[GestureViewController alloc]init];
                HCVC.hidesBottomBarWhenPushed = YES;
                HCVC.type = GestureViewControllerTypeSetting;
                HCVC.whereType = whereother;
                [self.navigationController pushViewController:HCVC animated:YES];
            }else{
                GestureViewController *HCVC = [[GestureViewController alloc]init];
                HCVC.hidesBottomBarWhenPushed = YES;
                HCVC.type = GestureViewControllerTypeSetting;
                HCVC.whereType = whereRoot;
                [self.navigationController pushViewController:HCVC animated:YES];
            }
            
        }else {
            [AppDelegate delegate].userInfo.bsetGuestPwd = YES;
            
            if (_fromType == fromLogin) {//正常登录从哪来回哪去
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                if (identical == YES) {//新登录号与旧的相同
                    if (_fromType == fromForgetGesture) {//从忘记手势过来需要从新设置
                        GestureViewController *HCVC = [[GestureViewController alloc]init];
                        HCVC.hidesBottomBarWhenPushed = YES;
                        HCVC.type = GestureViewControllerTypeSetting;
                        HCVC.whereType = whereother;
                        [self.navigationController pushViewController:HCVC animated:YES];
                    }else if (_fromType == fromOther){//从退出登录以及设置修改登录密码过来
                        UIViewController *rootVC = self.presentingViewController;
                        
                        while (rootVC.presentingViewController) {
                            rootVC = rootVC.presentingViewController;
                        }
                        
                        if ([rootVC isKindOfClass:[HCRootTabController class]]) {
                            HCRootTabController *tabCon = (HCRootTabController *)rootVC;
                            UINavigationController *con = tabCon.selectedViewController;
                            [con popToRootViewControllerAnimated:YES];
                            [rootVC dismissViewControllerAnimated:NO completion:nil];
                            tabCon.selectedIndex = 0;
                            
                        }

                    }else{
                        UIViewController *rootVC = self.presentingViewController;
                        
                        while (rootVC.presentingViewController) {
                            rootVC = rootVC.presentingViewController;
                        }
                        
                        [rootVC dismissViewControllerAnimated:NO completion:nil];
                        
                    }
                    
                }else{//新登录号与旧的不同登陆后回首页
                    UIViewController *rootVC = self.presentingViewController;
                    
                    while (rootVC.presentingViewController) {
                        rootVC = rootVC.presentingViewController;
                    }
                    
                    if ([rootVC isKindOfClass:[HCRootTabController class]]) {
                        HCRootTabController *tabCon = (HCRootTabController *)rootVC;
                        UINavigationController *con = tabCon.selectedViewController;
                        [con popToRootViewControllerAnimated:YES];
                        [rootVC dismissViewControllerAnimated:NO completion:nil];
                        tabCon.selectedIndex = 0;
                        
                    }
                }

            }
           
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

-(void)manageIsRegister:(RegisterModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        if ([model.body.isRegister isEqualToString:@"Y"] || [model.body.isRegister isEqualToString:@"C"]) {
            //海尔会员修改密码入口
            if ([model.body.alterPwd isEqualToString:@"-1"]) {
                self.forgetPasswordController.webUrlStr = model.body.alterPwdIn;
                _forgetPasswordController.returnUrlStr = model.body.alterPwdOut;
                [self.navigationController pushViewController:_forgetPasswordController animated:YES];
            } else {
                RecoveryLoginViewController *con = [[RecoveryLoginViewController alloc]init];
                con.strTel = _fieldName.text;//登录号
                [self.navigationController pushViewController:con animated:YES];
            }
            
        }else{
            
            [self buildHeadError:@"此手机号未注册！"];
            
        }
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }

}
-(void)manageCheck:(VersionModel *)model{
    if([model.head.retFlag isEqualToString:@"00000"])
    {
        if([model.body.isFix isEqualToString:@"Y"])
        {
            NSString *alert = [NSString stringWithFormat:@"系统维护中,维护时间为%@至%@",model.body.beginTime,model.body.endTime];
            [self buildHeadError:alert];
        }else
        {
            if([_stateStr isEqualToString:@"登录"])
            {
                [self login];
            }else if ([_stateStr isEqualToString:@"注册"])
            {
                if (_fromType == fromLogin) {
                    UnlockAccountViewController *vc = [[UnlockAccountViewController alloc]init];
                    vc.startType = FromRegister;
                    vc.showType = ShowRegAndRealInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    UnlockAccountViewController *vc = [[UnlockAccountViewController alloc]init];
                    vc.startType = FromRegister;
                    vc.ifFromGesture = YES;
                    vc.showType = ShowRegAndRealInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
                
            }else if ([_stateStr isEqualToString:@"忘记密码"])
            {
                NSString *userName = [_fieldName.text deleteSpeaceString];  //去掉空格
                _fieldName.text = userName;
                
                [self isRegesterWithStrTel:userName];
            }
        }
    }else
    {
        [self buildHeadError:model.head.retMsg];
    }

}


#pragma mark --other 其他方法--
//创建数据
- (void)createData {
    
    //用于验证行的显示、隐藏
    _moveDistance = 0;
    if (iphone6P) {
        _moveDistance = 64;
    } else if (iphone6) {
        _moveDistance = 59;
    } else if (iPhone5) {
        _moveDistance = 59;
    }else if (IPHONE4) {
        _moveDistance = 42;
    }
}

- (void)resetVerificationImage {
    NSData *_decodedImageData = [[NSData alloc] initWithBase64Encoding:_model.body.captchaImage];
    UIImage *decodedImage = [UIImage imageWithData:_decodedImageData];
    [self.verificationImgView setImage:decodedImage];
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _fieldName && _verificationView && _verificationView.superview) {
        if (![_fieldName.text isEqualToString:self.userId]) {
            _fieldPass.returnKeyType = UIReturnKeyDone;
            CGRect topViewRect = self.topInputView.frame;
            _verificationText.text = nil;
            [_verificationImgView setImage:nil];
            [self.verificationView removeFromSuperview];
            _model = nil;
            self.userId = nil;
            [UIView animateWithDuration:.3 animations:^{
                self.topInputView.frame = CGRectMake(topViewRect.origin.x, topViewRect.origin.y + _moveDistance, topViewRect.size.width, topViewRect.size.height);
            }];
            
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _fieldName) {
        [_fieldName resignFirstResponder];
        [_fieldPass becomeFirstResponder];
        
        return NO;
    }else if(textField == _verificationText){
        [_verificationText resignFirstResponder];
        [self GoToNext];
        return YES;
    }else {
        if (_verificationView && _verificationView.superview) {
            [_fieldPass resignFirstResponder];
            [_verificationText becomeFirstResponder];
            return NO;
        } else {
            [_fieldPass resignFirstResponder];
            [self GoToNext];
            return YES;
        }
    }
}
#pragma mark - Getting and Setting 懒加载
//注意self.forgetPasswordController的使用，每次调用的时候都会重新刷新webViewController，数据会丢失
//这样做的目的是为了多次进入页面时，web页重新刷新。
- (PMWebViewController *)forgetPasswordController {
    if (_forgetPasswordController) {
        _forgetPasswordController = nil;
    }
    _forgetPasswordController = [[PMWebViewController alloc] init];
    _forgetPasswordController.webType = PMWebVeiwControllerTypeForgotPassword;
    
    return _forgetPasswordController;
}



@end
