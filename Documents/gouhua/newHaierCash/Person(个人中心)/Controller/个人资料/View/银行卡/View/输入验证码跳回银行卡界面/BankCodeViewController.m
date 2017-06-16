//
//  BankCodeViewController.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "BankCodeViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "AppDelegate.h"
#import "RMUniversalAlert.h"
#import "NSString+CheckConvert.h"
#import "BSVKHttpClient.h"
#import "EnterAES.h"
#import "UIColor+DefineNew.h"
#import <MBProgressHUD.h>
#import "CheckCodeHeadModel.h"
#import "WriteVerModel.h"
#import "BankCardGrantModel.h"
#import "BankLIstMode.h"
#import "AddBankViewController.h"
#import "UIButton+UnifiedStyle.h"
#import "BankAgreementViewController.h"
static CGFloat const GetCode = 110;//获取验证码
static CGFloat const JudgeCode = 120;//校验验证码
static CGFloat const bankCardGrant = 130;//银行卡变更授权书签章
static CGFloat const updateBankCardInfo = 140;//编辑银行卡

@interface BankCodeViewController ()<BSVKHttpClientDelegate,UITextFieldDelegate>{
    float x;
    
    UIView *buttonView;
}
@property(nonatomic,strong)UITextField *codeText;//验证码输入框

@property(nonatomic,strong)UIButton *timeButton;//时间按钮

@property(nonatomic,strong)UILabel *timeLabel;//时间显示

@property(nonatomic,assign)NSInteger time;//时间

@property(nonatomic,strong)UIButton *agreeButton;//我同意按钮

@property(nonatomic,strong)NSTimer *timer;//时间定时器

@property(nonatomic,strong)UIButton *nextButton;//下一步

@property(nonatomic,strong)UITableView *showTableView;//协议展示table

@property(nonatomic,copy)NSArray *nameArray;//协议名称数组

@property(nonatomic,strong)UIView *lightView;
@end

@implementation BankCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"验证码";
    
    [self creatBaseUI];
    
}

-(UIView *)lightView{
    
    if (!_lightView) {
        
        _lightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64)];
        
        _lightView.backgroundColor = [UIColor UIColorWithHexColorString:@"0x7f7f7f" AndAlpha:0.8];
        
        
        [self.view addSubview:_lightView];
        
    }
    
    return _lightView;
    
}

#pragma mark - private Methods
// 视图
-(void)creatBaseUI{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
        
    }
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 1)];
    
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [self.view addSubview:lineView];
    
    UILabel *warnLab = [[UILabel alloc]init];
    
    warnLab.textColor = UIColorFromRGB(0x666666, 1.0);
    
    warnLab.font = [UIFont appFontRegularOfSize:13];
    
    warnLab.text = [NSString stringWithFormat:@"请输入手机%@收到的短信校验码",[_changeTel hiddenCenterNum]];
    
    [self.view addSubview:warnLab];
    
    
    /*----------------------验证码输入框-----------------------*/
    UIView *numberView = [[UIView alloc]init];
    
    numberView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:numberView];
    
    UIImageView *leftImg = [[UIImageView alloc]init];
    
    leftImg.backgroundColor = [UIColor clearColor];
    
    leftImg.image = [UIImage imageNamed:@"注册验证码"];
    
    [numberView addSubview:leftImg];
    
    _codeText = [[UITextField alloc]init];
    
    _codeText.placeholder = @"请输入验证码";
    
    _codeText.font = [UIFont appFontRegularOfSize:13];
    
    _codeText.textColor = UIColorFromRGB(0x999999, 1.0);
    
    _codeText.backgroundColor = [UIColor clearColor];
    
    [numberView addSubview:_codeText];
    
    /*----------------------验证码按钮-----------------------*/
    
    buttonView = [[UIView alloc]init];
    
    buttonView.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    buttonView.layer.cornerRadius = 25*x;
    
    [self.view addSubview:buttonView];
    
    _timeLabel = [[UILabel alloc]init];
    
    _timeLabel.text = @"重新发送";
    
    _timeLabel.font = [UIFont appFontRegularOfSize:13];
    
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    _timeLabel.textColor = UIColorFromRGB(0x999999, 1.0);;
    
    _timeLabel.backgroundColor = [UIColor clearColor];
    
    _timeLabel.textColor = [UIColor whiteColor];
    
    [buttonView addSubview:_timeLabel];
    
    _timeButton = [[UIButton alloc]init];
    
    _timeButton.backgroundColor = [UIColor clearColor];
    
    [_timeButton addTarget:self action:@selector(buildTouchAgainPost:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:_timeButton];
    
    //对号按钮
    _agreeButton = [[UIButton alloc]init];
    
    [_agreeButton setImage:[UIImage imageNamed:@"我同意"] forState:UIControlStateNormal];
    
    [_agreeButton addTarget:self action:@selector(buildAgree:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_agreeButton];
    
    UILabel *optionLabel = [[UILabel alloc]init];
    
    optionLabel.font = [UIFont appFontRegularOfSize:12];
    
    optionLabel.textColor = UIColorFromRGB(0x666666, 1.0);
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"我同意银行卡授权协议"];
    
    [attr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x32beff, 1.0)} range:NSMakeRange(3, 7)];
    
    optionLabel.attributedText = attr;
    
    UIButton *aggreeBtn = [[UIButton alloc]init];
    
    [aggreeBtn addTarget:self action:@selector(buildTouchLook:) forControlEvents:UIControlEventTouchUpInside];
    
    aggreeBtn.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:aggreeBtn];
    
    [self.view addSubview:optionLabel];
    
    //下一步按钮
    
    _nextButton = [[UIButton alloc]init];
    
    [_nextButton addTarget:self action:@selector(buildToNextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nextButton];
    
    
    if (iphone6P) {
        
        warnLab.frame = CGRectMake(60*x, 25*x, DeviceWidth-60*x, 20*x);
        
        numberView.frame = CGRectMake(47*x, 57*x, 193*x, 50*x);
        
        numberView.layer.cornerRadius = 25*x;
        
        leftImg.frame = CGRectMake(25*x, 17*x, 16*x, 16*x);
        
        _codeText.frame = CGRectMake(53*x, 15*x, 141*x, 20*x);
        
        buttonView.frame = CGRectMake(250*x, 57*x, 115*x, 50*x);
        
        buttonView.layer.cornerRadius  = 25*x;
        
        _timeLabel.frame = CGRectMake(0, 15*x, 115*x, 20*x);
        
        _timeButton.frame = CGRectMake(0, 0, 115*x, 50*x);
        
        _agreeButton.frame = CGRectMake(60*x, 125*x, 12*x, 12*x);
        
        optionLabel.frame = CGRectMake(83*x, 125*x, DeviceWidth-83*x, 15*x);
        
        aggreeBtn.frame = CGRectMake(100*x, 118*x, 160*x, 30*x);
        
        _nextButton.frame = CGRectMake(47*x, 177*x, DeviceWidth-94*x, 50*x);
        
        _nextButton.layer.cornerRadius = 25*x;
        
    }else{
        
        warnLab.frame = CGRectMake(56*x, 24*x, DeviceWidth-56*x, 20*x);
        
        numberView.frame = CGRectMake(42*x, 63*x, 176*x, 46*x);
        
        numberView.layer.cornerRadius = 23*x;
        
        leftImg.frame = CGRectMake(25*x, 15*x, 16*x, 16*x);
        
        _codeText.frame = CGRectMake(53*x, 13*x, 123*x, 20*x);
        
        buttonView.frame = CGRectMake(225*x, 63*x, 105*x, 46*x);
        
        buttonView.layer.cornerRadius  = 23*x;
        
        _timeLabel.frame = CGRectMake(0, 15*x, 105*x, 20*x);
        
        _timeButton.frame = CGRectMake(0, 0, 105*x, 46*x);
        
        _agreeButton.frame = CGRectMake(58*x, 123*x, 12*x, 12*x);
        
        optionLabel.frame = CGRectMake(85*x, 123*x, DeviceWidth-85*x, 15*x);
        
        aggreeBtn.frame = CGRectMake(100*x, 113*x, 160*x, 30*x);
        
        _nextButton.frame = CGRectMake(42*x, 163*x, DeviceWidth-84*x, 46*x);
        
        _nextButton.layer.cornerRadius = 23*x;
        
        
    }
    [_nextButton setButtonTitle:@"下一步" titleFont:14 buttonHeight:CGRectGetHeight(_nextButton.frame)];
    
}
//获取验证码
-(void)buildTouchAgainPost:(UIButton *)sender{
    
    [self buildGetCodeHttp];
    
}

//查看协议
-(void)buildTouchLook:(UIButton *)sender{
    
    BankAgreementViewController * vc = [[BankAgreementViewController alloc]init];
    vc.strOnLineUrl = [NSString stringWithFormat:@"app/appserver/grant?custNo=%@&cardNo=%@",[AppDelegate delegate].userInfo.custNum,_cardText];
    [self.navigationController pushViewController:vc animated:YES];
}

//同意协议
-(void)buildAgree:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected ) {
        
        [sender setImage:[UIImage imageNamed:@"gouxuan无框"] forState:UIControlStateNormal];
        
    }else{
        
        [sender setImage:[UIImage imageNamed:@"我同意"] forState:UIControlStateNormal];
    }
    
}

//添加定时器
-(void)creatAddTimer{
    
    _timeButton.userInteractionEnabled = NO;
    
    _time = 60;
    
    if (!_timer) {
        
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(buildChangeTime:) userInfo:nil repeats:YES];
        
        [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
        
    }
    
}
//定时器所调用的方法
-(void)buildChangeTime:(NSTimer *)changeTime{
    
    _time--;
    
    if (_time == 0) {
        
        [changeTime invalidate];
        
        _timer = nil;
        
        _timeLabel.text = @"重新发送";
        
        buttonView.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
        
        _timeButton.userInteractionEnabled = YES;
        
    }else{
        
        _timeLabel.text = [NSString stringWithFormat:@"%lds后重发",(long)_time];
        
        buttonView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
        
        _timeLabel.textColor = [UIColor whiteColor];
        
        _timeButton.userInteractionEnabled = NO;
        
    }
    
}
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
- (void)backViewController{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[AddBankViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}
#pragma mark --> event Methods
//点击下一步方法
-(void)buildToNextAction:(UIButton *)sender{
    
    
    [_codeText resignFirstResponder];
    
    if (_codeText.text.length == 0) {
        
        [self buildHeadError:@"请输入验证码"];
        
    }else{
        
        if (_agreeButton.selected) {
        
            [self buildjudgeCodeHttp];
        }else{
            
            [self buildHeadError:@"请先阅读银行卡授权协议并同意"];
            
        }
        
        
    }
    
}
#pragma mark -->textfield代理协议

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}


#pragma mark --> 网络请求

//验证验证码
-(void)buildjudgeCodeHttp{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if (_codeText.text.length > 0) {
        
        [parm setObject:_codeText.text forKey:@"verifyNo"];
        
    }
    
    if ([AppDelegate delegate].userInfo.userId.length > 0) {
        
        [parm setObject:[AppDelegate delegate].userInfo.userId forKey:@"phone"];
        
    }
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client postInfo:@"app/appserver/smsVerify" requestArgument:parm requestTag:JudgeCode requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
}

//获取验证码
-(void)buildGetCodeHttp{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if ([AppDelegate delegate].userInfo.userId.length > 0 && [AppDelegate delegate].userInfo.userId) {
        
        [parm setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId] forKey:@"phone"];
        
    }
    
    BSVKHttpClient * verClient = [BSVKHttpClient shareInstance];
    
    verClient.delegate = self;
    //   发送短信验证码
    [verClient getInfo:@"app/appserver/smsSendVerify" requestArgument:parm requestTag:GetCode requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
}
- (void)buildBankCardGrant{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //签章
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
    
    [dic setObject:[AppDelegate delegate].userInfo.realName forKey:@"custName"];
    
    [dic setObject:[AppDelegate delegate].userInfo.realId forKey:@"certNo"];
    
    [dic setObject:_cardText forKey:@"cardNo"];
    
    [dic setObject:_bankName forKey:@"bankName"];
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/bankCardGrant" requestArgument:dic requestTag:bankCardGrant requestClass:NSStringFromClass([self class])];
    
}
#pragma mark --> 网络代理协议

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == GetCode) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            WriteVerModel *model = [WriteVerModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleGetCode:model];
            
        }else if (requestTag == JudgeCode){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            CheckCodeHeadModel *model = [CheckCodeHeadModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleJudgeCode:model];
            
        }else if (requestTag == bankCardGrant){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            BankCardGrantModel * model = [BankCardGrantModel mj_objectWithKeyValues:responseObject];
    
            [self analySisBankCardGrantModel:model];
            
        }else if (requestTag == updateBankCardInfo){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            BankLIstMode *model = [BankLIstMode mj_objectWithKeyValues:responseObject];
            
            [self analySisBankLIstMode:model];
            
        }
    }
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]){
        
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
#pragma mark -->网络请求成功后的逻辑处理

//校验验证码
-(void)buildHandleJudgeCode:(CheckCodeHeadModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [self buildBankCardGrant];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//发送验证码
-(void)buildHandleGetCode:(WriteVerModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [self creatAddTimer];
        
    }else{
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:model.head.retMsg cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    strongSelf.timeLabel.text =@"点击发送";
                }
            }
        }];
        
        
    }
    
}
- (void)analySisBankCardGrantModel:(BankCardGrantModel *)model{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        if (_bankCodeType == BankEdit) {
            NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];

            [dic setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
            [dic setObject:_cardText forKey:@"cardNo"];//银行卡号
            [dic setObject:_changeTel forKey:@"mobile"];// 手机号
            [dic setObject:StringOrNull(_provinceStr) forKey:@"acctProvince"];//开户省
            [dic setObject:StringOrNull(_cityStr) forKey:@"acctCity"];//开户市
            if (_areaStr) {
                [dic setObject:_areaStr forKey:@"acctArea"];//开户区
            }
            BSVKHttpClient *client = [BSVKHttpClient shareInstance];
            client.delegate = self;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [client postInfo:@"app/appserver/crm/cust/updateBankCardInfo" requestArgument:dic requestTag:updateBankCardInfo requestClass:NSStringFromClass([self class])];
        }else{
            // 添加银行卡
            // 5.39-保存还款银行卡接口
            NSMutableDictionary *saveReimbDict = [[NSMutableDictionary alloc]init];

            [saveReimbDict setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];//客户编号
            [saveReimbDict setObject:[AppDelegate delegate].userInfo.realName forKey:@"custName"];//姓名
            [saveReimbDict setObject:_cardText forKey:@"cardNo"];//银行卡号
            [saveReimbDict setObject:[AppDelegate delegate].userInfo.realId forKey:@"certNo"];//身份证号
            [saveReimbDict setObject:_changeTel forKey:@"phonenumber"];// 手机号
            [saveReimbDict setObject:_bankNo forKey:@"bankCode"];//银行代码
            [saveReimbDict setObject:_bankName forKey:@"bankName"];// 银行名称
            [saveReimbDict setObject:@"" forKey:@"cardTypeCode"];//卡类型代码
            [saveReimbDict setObject:_bankType forKey:@"cardTypeName"];// 卡类型名称
            [saveReimbDict setObject:@"N" forKey:@"isRealnameCard"];//是否实名认证新增卡
            [saveReimbDict setObject:@"N" forKey:@"isDefaultCard"];// 是否默认卡
            [saveReimbDict setObject:@"" forKey:@"accBchCde"];// 开户支行代码
            [saveReimbDict setObject:@"" forKey:@"accBchName"];// 开户支行名称
            [saveReimbDict setObject:StringOrNull(_provinceStr) forKey:@"acctProvince"];//开户省
            [saveReimbDict setObject:StringOrNull(_cityStr) forKey:@"acctCity"];//开户市
            if (_areaStr) {
                [saveReimbDict setObject:_areaStr forKey:@"acctArea"];//开户区
            }

            BSVKHttpClient *client = [BSVKHttpClient shareInstance];
            client.delegate = self;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [client postInfo:@"app/appserver/crm/cust/saveBankCard" requestArgument:saveReimbDict requestTag:updateBankCardInfo requestClass:NSStringFromClass([self class])];
        }
    }else{
        if (_bankCodeType == BankEdit) {
            [self buildHeadError:@"编辑银行卡失败"];
        }else{
            [self buildHeadError:@"添加银行卡失败"];
        }
    }
}
- (void)analySisBankLIstMode:(BankLIstMode *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if ([[AppDelegate delegate].userInfo.realCard isEqualToString:_cardText]) {
            
            [AppDelegate delegate].userInfo.acctProvinceCode = _provinceStr;
            
            [AppDelegate delegate].userInfo.acctCityCode = _cityStr;
            
            [AppDelegate delegate].userInfo.realTel = _changeTel;
        }
        
        if (_bankCodeType == BankEdit) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            WEAKSELF
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"编辑银行卡成功" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                if (strongSelf) {
                    if (buttonIndex == 0) {
                        
                        [strongSelf backViewController];
                    }
                }
            }];
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            WEAKSELF
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"添加银行卡成功" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                if (strongSelf) {
                    if (buttonIndex == 0) {
                        
                        [strongSelf backViewController];
                    }
                }
            }];
            
        }
        
    }else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *str = model.head.retMsg;
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:str cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                    
                }
            }
        }];
    }
}
@end
