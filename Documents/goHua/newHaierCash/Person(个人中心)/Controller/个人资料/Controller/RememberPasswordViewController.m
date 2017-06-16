//
//  RememberPasswordViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "RememberPasswordViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "RMUniversalAlert.h"
#import "BSVKHttpClient.h"
#import "AppDelegate.h"
#import "NSString+CheckConvert.h"
#import <MJExtension.h>
#import <MBProgressHUD.h>
#import "EnterAES.h"
#import "UIButton+LazyButton.h"
#import <Bugly/Bugly.h>
#import "ApprovalProgressViewController.h"
#import "HCMySelfController.h"
#import "RealNameViewController.h"
#import "VerityPwdViewController.h"
#import "ContractShowViewController.h"
#import "HCRootNavController.h"
#import "UpdateRiskInfoModel.h"
#import "RememberPasswordViModel.h"
#import "PutPayModel.h"
#import "SvUDIDTools.h"

@interface RememberPasswordViewController ()<BSVKHttpClientDelegate>
{

}

/*
 界面搭建
 */
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UITextField * numTextField;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIButton *agreeButton;
@property(nonatomic,strong)UIImageView *choiceImg;
@end

@implementation RememberPasswordViewController
#pragma mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setInit];    // 初始化赋值
    [self setView];    // 创建view
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];

}
#pragma mark - private Methods
- (void)setInit{

    self.edgesForExtendedLayout = UIRectEdgeBottom;
}
- (void)setView{
    [self setLineView];
    [self creatTextField];//输入框
    [self creatBtn];//按钮
    if ([AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned) {
        [self creatPassBtn];
    }
    
}

- (void)setLineView{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self.view addSubview:lineView];
}
// -- 输入框
-(void)creatTextField{
    
    UIView * bjView = [[UIView alloc]init];
    
    _numTextField = [[UITextField alloc]init];
    
    _numTextField.secureTextEntry = YES;
    
    bjView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    if (iphone6P) {
        
        bjView.frame = CGRectMake(47,47, DeviceWidth - 94, 50);
        
        bjView.layer.cornerRadius = 25;
        
        _numTextField.frame = CGRectMake(20,0, bjView.frame.size.width - 30, 50);
    }else{
        
        bjView.frame = CGRectMake(42 *DeviceWidth/375,42*DeviceWidth/375, DeviceWidth - 82*DeviceWidth/375, 45*DeviceWidth/375);
        
        bjView.layer.cornerRadius = 22.5*DeviceWidth/374;
        
        _numTextField.frame = CGRectMake(16 *DeviceWidth/375,0, bjView.frame.size.width - 16*DeviceWidth/375, 45*DeviceWidth/375);
    }
    
    [self.view addSubview:bjView];
    _numTextField.placeholder = @"请输入原密码";
    _numTextField.font = [UIFont appFontRegularOfSize:13];
    _numTextField.keyboardType = UIKeyboardTypeDefault;
    
    _numTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bjView addSubview:_numTextField];
    
    if ([AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned) {
#warning mark - 还缺少提额的flowName
        
        _numTextField.placeholder = @"请输入支付密码";
        
        self.title = @"密码验证";
        
    }else{
        
        self.title = @"输入原密码";
        
    }
}
// -- 按钮
-(void)creatBtn{
    _nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    if (iphone6P) {
        _nextBtn.frame = CGRectMake(47 , 120, DeviceWidth - 94, 50);
        _nextBtn.layer.cornerRadius = 25;
        
    }else{
        _nextBtn.frame = CGRectMake(42 *DeviceWidth/375 , 110, DeviceWidth - 84 *DeviceWidth/375, 45*DeviceWidth/375);
        _nextBtn.layer.cornerRadius = 22.5*DeviceWidth/374;
    }
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:UIColorFromRGB(0x32beff, 1.0)];
    [_nextBtn addTarget:self action:@selector(ToNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    _nextBtn.bIgnoreEvent = NO;
    _nextBtn.lazyEventInterval = 0.5;
}

// -----忘记支付密码－－－－－－－

- (void)creatPassBtn{
    UIButton * passBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    passBtn.frame = CGRectMake(DeviceWidth - 30 - 120, CGRectGetMaxY(_nextBtn.frame) + 10, 120, 20);
    [passBtn setTitle:@"忘记支付密码？" forState:(UIControlStateNormal)];
    passBtn.tintColor = UIColorFromRGB(0x32beff, 1.0);
    [passBtn addTarget:self action:@selector(toRealNameViewController) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:passBtn];
    
}
- (void)toVerityPwdViewController{
    _nextBtn.userInteractionEnabled = YES;
    [_nextBtn setBackgroundColor:UIColorFromRGB(0x32beff, 1.0)];
    VerityPwdViewController *vc = [[VerityPwdViewController alloc]init];
    vc.verityPwdType = VerityPwdChangeDealPwdByRemeber;
    vc.oldPayPassWord = _numTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
}

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
#pragma mark - event response

- (void)toRealNameViewController{
    
    RealNameViewController *real = [[RealNameViewController alloc]init];
//    real.flowName = changeDealPwdByNoRemeber;
    [self.navigationController pushViewController:real animated:YES];
}
-(void)ToNext{
    
    [_numTextField resignFirstResponder];
    
    if (_numTextField.text.length == 0) {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请输入密码" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
    }else if(![_numTextField.text isValidateInput]){
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请输入6-20字母数字组合" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
    }else{
        
         [self validatePayPasswd];
        
    }
}

#pragma mark - set request
- (void)validatePayPasswd{
    
    _nextBtn.userInteractionEnabled = NO;
    
    [_nextBtn setBackgroundColor:UIColorFromRGB(0xf6f6f6f, 1.0)];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [dict setObject:StringOrNull([EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId]) forKey:@"userId"];
    [dict setObject:[EnterAES simpleEncrypt:_numTextField.text]forKey:@"payPasswd"];
    [[BSVKHttpClient shareInstance] getInfo:@"app/appserver/uauth/validatePayPasswd" requestArgument:dict requestTag:1 requestClass:NSStringFromClass([self class])];
}
#pragma mark - BSVK Delegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == 1) {
            RememberPasswordViModel *model = [RememberPasswordViModel mj_objectWithKeyValues:responseObject];
            
            [self analySisRememberPasswordViModel:model];
            
        }
    }
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {

        _nextBtn.userInteractionEnabled = YES;
        
        [_nextBtn setBackgroundColor:UIColorFromRGB(0x32beff, 1.0)];
        
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

#pragma mark - Model 解析
- (void)analySisRememberPasswordViModel:(RememberPasswordViModel *)model{
  
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [self toVerityPwdViewController];
    }else{
       
        _nextBtn.userInteractionEnabled = YES;
        
        [_nextBtn setBackgroundColor:UIColorFromRGB(0x32beff, 1.0)];
        
        [self buildHeadError:model.head.retMsg];
    }
}
#pragma mark -- textField Delegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_numTextField resignFirstResponder];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end

