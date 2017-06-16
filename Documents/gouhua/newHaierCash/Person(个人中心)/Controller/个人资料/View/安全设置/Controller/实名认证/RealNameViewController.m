//
//  RealNameViewController.m
//  personMerchants
//
//  Created by LLM on 2017/1/3.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "RealNameViewController.h"
#import "ReservedNumberViewController.h"
#import "SupportBankViewController.h"
#import "NSString+CheckConvert.h"
#import "HCMacro.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
#import "BankNameModel.h"
#import "CheckIdNoModel.h"
#import "BankIardInformation.h"
#import <NSObject+MJKeyValue.h>
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>

@interface RealNameViewController ()<BSVKHttpClientDelegate>

@property (nonatomic,strong) UITextField *nameTF;   //姓名的输入框

@property (nonatomic,strong) UITextField *idTF;     //身份证输入框

@property (nonatomic,strong) UITextField *cardTF;   //银行卡的输入框

@property (nonatomic,strong) UIButton *nextBtn;     //下一步


@end

@implementation RealNameViewController
{
    BOOL _isSelect; //是否是查看
}

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"实名认证";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _isSelect = NO;
    
    [self initContentView];
    
    if (self.realNameChageBindPhoneNumType == RealNameChangeDealPwdByNoRemeber) {
        _nameTF.text = StringOrNull([AppDelegate delegate].userInfo.realName);
    }
    if(_idTF.text.length > 0)
    {
        _cardTF.userInteractionEnabled = NO;
        _nameTF.userInteractionEnabled = NO;
        _idTF.userInteractionEnabled = NO;
        _isSelect = YES;
    }else
    {
        _cardTF.userInteractionEnabled = YES;
        _nameTF.userInteractionEnabled = YES;
        _idTF.userInteractionEnabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_idTF resignFirstResponder];
    
    [_cardTF resignFirstResponder];
    
    [_nameTF resignFirstResponder];
}
#pragma mark - 初始化视图

- (void)initContentView
{
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self.view addSubview:lineView];
    for(int i = 0; i < 3; i++)
    {
        UITextField *tf = [[UITextField alloc] init];
        UILabel *leftLabel = [[UILabel alloc] init];

        if (iphone6P) {
            tf.frame = CGRectMake(20, 12+i*50, DeviceWidth-40, 50);
            leftLabel.frame = CGRectMake(0, 0, 80, 50);

        }else{
            tf.frame = CGRectMake(20, 12+i*45, DeviceWidth-40, 45);
            leftLabel.frame = CGRectMake(0, 0, 80, 40);
        }
        tf.leftViewMode = UITextFieldViewModeAlways;
        tf.font = [UIFont systemFontOfSize:15];
        tf.leftView = leftLabel;
        
        if(i == 0)
        {
            tf.placeholder = @"请输入姓名";
            leftLabel.text = @"姓名";
            
            _nameTF = tf;
        }else if (i == 1)
        {
            tf.placeholder = @"请输入身份证号码";
            leftLabel.text = @"身份证";
            
            _idTF = tf;
        }else
        {
            if (iphone6P) {
                tf.frame = CGRectMake(20, 12+i*50, DeviceWidth-62, 50);

            }else{
                tf.frame = CGRectMake(20, 12+i*45, DeviceWidth-62, 45);
            }
            tf.placeholder = @"请输入银行卡卡号";
            leftLabel.text = @"银行卡号";
            tf.keyboardType = UIKeyboardTypeNumberPad;
            
            _cardTF = tf;
        }
        
        [self.view addSubview:tf];
        
        UIView *lineView = [[UIView alloc] init];
        if (iphone6P) {
            lineView.frame = CGRectMake(0, 12+49*(i+1), DeviceWidth, 1);

        }else{
            lineView.frame = CGRectMake(0, 12+44*(i+1), DeviceWidth, 1);
        }
        lineView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [self.view addSubview:lineView];
    }
    
    UIButton *bankListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (iphone6P) {
        bankListBtn.frame = CGRectMake(DeviceWidth-42, 126, 22, 22);

    }else{
        bankListBtn.frame = CGRectMake(DeviceWidth-42, 111, 22, 22);
    }
    [bankListBtn setImage:[UIImage imageNamed:@"提示"] forState:UIControlStateNormal];
    [bankListBtn addTarget:self action:@selector(toSupportBank) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bankListBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (iphone6P) {
        nextBtn.frame = CGRectMake(48, 185, DeviceWidth-96, 50);
        nextBtn.layer.cornerRadius = 25.f;
    } else {
        nextBtn.frame = CGRectMake(40, 180, DeviceWidth-80, 45);
        nextBtn.layer.cornerRadius = 22.5f;
    }
    nextBtn.backgroundColor = UIColorFromRGB(0x32beff, 1);
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(toNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    _nextBtn = nextBtn;
    
    UILabel *tipLabel = [[UILabel alloc] init];
    if (iphone6P) {
        tipLabel.frame = CGRectMake(20, 250, DeviceWidth-40, 60);

    }else{
        tipLabel.frame = CGRectMake(20, 235, DeviceWidth-40, 60);
    }
    tipLabel.text = @"此卡为默认放款卡和还款卡，如果想更换默认还款卡，可在个人中心-个人资料-银行卡中绑定并设置";
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textColor = [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.00];
    [self.view addSubview:tipLabel];
}
#pragma mark - 点击事件

- (void)toNext:(UIButton *)btn
{
    if ([_nameTF.text isEqualToString:@""])
    {
        [self showAlertWithMessage:@"请输入姓名"];
        return;
    }else if ([_idTF.text isEqualToString:@""])
    {
        [self showAlertWithMessage:@"请输入身份证"];
        return;
    }else if ([_cardTF.text isEqualToString:@""])
    {
        [self showAlertWithMessage:@"请输入银行卡号"];
        return;
    }else
    {
        //判断姓名是否符合
        BOOL rightName = [_nameTF.text isValidateName];
        
        if (rightName == NO)
        {
            _nameTF.text = @"";
            [self showAlertWithMessage:@"请输入2-20位中文名"];
        }else
        {
            //判断身份证号
            _nextBtn.userInteractionEnabled = NO;
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [BSVKHttpClient shareInstance].delegate = self;
            
            [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/validate/checkIdNo" requestArgument:@{@"idNo":_idTF.text} requestTag:123 requestClass:NSStringFromClass([self class])];
        }
    }
}

#pragma mark - private methods
- (void)showAlertWithMessage:(NSString *)message
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:message cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                
            }
        }
    }];
}


- (void)toSupportBank
{
//    SupportBankViewController *supportVC = [[SupportBankViewController alloc] init];
//    CustomNavigationController *custnav = [[CustomNavigationController alloc] initWithRootViewController:supportVC];
//    [self.navigationController presentViewController:custnav animated:YES completion:nil];
}

#pragma mark - 做网络请求的方法
- (void)beginTest
{

        NSString *cardNoStr;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [BSVKHttpClient shareInstance].delegate = self;
        
        if (_isSelect)
        {
            cardNoStr = [AppDelegate delegate].userInfo.realCard;
        }else
        {
            cardNoStr = _cardTF.text;
        }
        
        [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/crm/cust/getBankInfo" requestArgument:@{@"cardNo":cardNoStr} requestTag:1000 requestClass:NSStringFromClass([self class])];
    
}

#pragma mark -- BSVK delegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        //    校验身份证号
        if (requestTag == 123)
        {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            CheckIdNoModel *checkModel = [CheckIdNoModel mj_objectWithKeyValues:responseObject];
            
            if ([checkModel.head.retFlag isEqualToString:SucessCode]) {
                
                if ([checkModel.body.flag isEqualToString:@"Y"]) {
                    
                    [self beginTest];
                }else
                {
                    _nextBtn.userInteractionEnabled = YES;
                    
                    [self showAlertWithMessage:@"身份证输入有误，请检查"];
                }
            }else
            {
                _nextBtn.userInteractionEnabled = YES;
                [self showAlertWithMessage:checkModel.head.retMsg];
            }
        }
        else if (requestTag == 1000)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            _nextBtn.userInteractionEnabled = YES;
            
            BankIardInformation *bankIdModel = [BankIardInformation mj_objectWithKeyValues:responseObject];
            
            if ([bankIdModel.head.retFlag isEqualToString:SucessCode])
            {
                

                ReservedNumberViewController *Real = [[ReservedNumberViewController alloc]init];
                
                
                Real.title = @"实名认证";
                
                Real.nameText = _nameTF.text;
                
                Real.idText = _idTF.text;
            
                Real.cardText = _cardTF.text;
                
                Real.bankName = bankIdModel.body.bankName;
                
                Real.bankCode = bankIdModel.body.bankNo;
                
                Real.bankType = bankIdModel.body.cardType;
            
                if ([AppDelegate delegate].userInfo.bLoginOK) {
                    
                    Real.strTel = [AppDelegate delegate].userInfo.userId;
                }else{
                
                    Real.strTel = _strTel;

                }
                if (self.realNameChageBindPhoneNumType == RealNameChageBindPhoneNumByRealNameType) {
                    
                    Real.reservedNumberChageBindPhoneNumType = ReservedNumberChageBindPhoneNumByRealNameType;
                }else if (self.realNameChageBindPhoneNumType == RealNameChangeDealPwdByNoRemeber){
                    
                    Real.reservedNumberChageBindPhoneNumType = ReservedNumberChangeDealPwdByNoRemeber;
                }
                NSMutableDictionary *bankDict = [[NSMutableDictionary alloc]init];
                
                [bankDict setObject:_nameTF.text forKey:@"custName"];
                
                [bankDict setObject:_idTF.text forKey:@"certNo"];
                
                [bankDict setObject:_cardTF.text forKey:@"cardNo"];
                
                Real.bankDict = [NSMutableDictionary dictionary];
                        
                Real.bankDict = bankDict;
                
                [self.navigationController pushViewController:Real animated:YES];
                    
            }

            else{
                _nextBtn.userInteractionEnabled = YES;
                
                WEAKSELF
                [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:bankIdModel.head.retMsg cancelButtonTitle:@"查看支持银行" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                    STRONGSELF
                    if (strongSelf) {
                        if (buttonIndex == 0)
                        {
                            [strongSelf toSupportBank];
                        }
                    }
                }];

            }
        }
    }
}

- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    _nextBtn.userInteractionEnabled = YES;
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
        NSLog(@"%@",error);
        
        NSLog(@"%ld",(long)requestTag);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(httpCode != 0)
        {
            [self showAlertWithMessage:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",httpCode]];
        }
        else
        {
            [self showAlertWithMessage:@"网络环境异常，请检查网络并重试"];
        }
        
    }
}


@end
