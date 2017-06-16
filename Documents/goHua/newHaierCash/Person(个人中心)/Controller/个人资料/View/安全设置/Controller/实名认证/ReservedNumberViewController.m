//
//  ReservedNumberViewController.m
//  personMerchants
//
//  Created by LLM on 2017/1/3.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "ReservedNumberViewController.h"
#import "NewNumberViewController.h"
#import "WriteVerificationViewController.h"
#import "PersonalDataViewController.h"
#import "HCMacro.h"
#import "SearchCityOrCode.h"
#import "UIFont+AppFont.h"
#import "RMUniversalAlert.h"
#import "NSString+CheckConvert.h"
#import "AppDelegate.h"
#import "EnterAES.h"
#import "BSVKHttpClient.h"
#import "WhiteSearchModel.h"
#import "ChangePasswordRealNameModel.h"
#import <MBProgressHUD.h>
#import <NSObject+MJKeyValue.h>
@interface ReservedNumberViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,BSVKHttpClientDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIView *groundView;

@property (nonatomic,strong) UIPickerView *cityPickerView;      //城市选择器

@property (nonatomic,strong) NSArray *provinceArr;
@property(nonatomic,strong)WhiteSearchModel *searchModel;

@property (nonatomic,strong) NSArray *cityArr;

@property (nonatomic,strong) UITextField *phoneNumTF;           //手机号输入框

@property (nonatomic,strong) UILabel *detailCityLabel;          //开户省市

@end

@implementation ReservedNumberViewController
{
    NSString *_kaiHuSheng;
    NSString *_kaiHuShi;
    NSString *_kaiHuShengCode;
    NSString *_kaiHuShiCode;
    
    NSString *_useIdStr;//用户输入账号或绑定手机号
    
    NSString *strProvinceNameTemp;
}

#pragma mark - life circle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"实名认证";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNav];
    
    [self initContentView];
    
}

#pragma mark - 初始化视图
- (void)setNav
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)initContentView
{
    //卡类型
    UILabel *cardTypeLabel = [[UILabel alloc] init];
    UILabel *bankLabel = [[UILabel alloc] init];
    UILabel *typeLabel = [[UILabel alloc] init];
    UIView *baseView = [[UIView alloc] init];
    UILabel *cityLabel = [[UILabel alloc] init];
    UILabel *detailCityLabel = [[UILabel alloc] init];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"箭头"]];
    UITextField *tf = [[UITextField alloc] init];
    UILabel *leftLabel = [[UILabel alloc] init];
    UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *tipLabel = [[UILabel alloc] init];

    if (iphone6P) {
        cardTypeLabel.frame = CGRectMake(20, 12, 80, 50);
        bankLabel.frame = CGRectMake(100, 12, DeviceWidth-200, 50);
        typeLabel.frame = CGRectMake(DeviceWidth-100, 12, 80, 50);
        baseView.frame = CGRectMake(0, 62, DeviceWidth, 50);
        cityLabel.frame = CGRectMake(20, 0, 80, 50);
        detailCityLabel.frame = CGRectMake(100, 0, DeviceWidth-132, 50);
        iv.frame = CGRectMake(DeviceWidth-20-12, 17.5, 12, 15);
        tf.frame = CGRectMake(20, 112, DeviceWidth-62, 50);
        leftLabel.frame = CGRectMake(0, 0, 80, 50);
        tipBtn.frame = CGRectMake(DeviceWidth-42, 126, 22, 22);
        tipLabel.frame = CGRectMake(20, 250, DeviceWidth-40, 60);

    }else{
        cardTypeLabel.frame = CGRectMake(20, 12, 80, 45);
        bankLabel.frame = CGRectMake(100, 12, DeviceWidth-200, 45);
        typeLabel.frame = CGRectMake(DeviceWidth-100, 12, 80, 45);
        baseView.frame = CGRectMake(0, 57, DeviceWidth, 45);
        cityLabel.frame = CGRectMake(20, 0, 80, 45);
        detailCityLabel.frame = CGRectMake(100, 0, DeviceWidth-132, 45);
        iv.frame = CGRectMake(DeviceWidth-20-12, 15, 12, 15);
        tf.frame = CGRectMake(20, 102, DeviceWidth-62, 45);
        leftLabel.frame = CGRectMake(0, 0, 80, 45);
        tipBtn.frame = CGRectMake(DeviceWidth-42, 116, 22, 22);
        tipLabel.frame = CGRectMake(20, 235, DeviceWidth-40, 60);
    }
    cardTypeLabel.text = @"卡类型";
    [self.view addSubview:cardTypeLabel];
    
    bankLabel.text = self.bankName;
    bankLabel.font = [UIFont appFontRegularOfSize:15];
    [self.view addSubview:bankLabel];
    
    typeLabel.text = self.bankType;
    typeLabel.textAlignment = NSTextAlignmentRight;
    typeLabel.font = [UIFont appFontRegularOfSize:15];
    [self.view addSubview:typeLabel];
    
    //开户城市
    baseView.userInteractionEnabled = YES;
    [self.view addSubview:baseView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(creatPickerView)];
    [baseView addGestureRecognizer:tap];
    
    cityLabel.text = @"开户城市";
    [baseView addSubview:cityLabel];
    
    detailCityLabel.font = [UIFont appFontRegularOfSize:15];
    detailCityLabel.textColor = [UIColor blackColor];
    [baseView addSubview:detailCityLabel];
    
    _detailCityLabel = detailCityLabel;
    
    [baseView addSubview:iv];
    
    //手机号
    tf.placeholder = @"银行预留手机号";
    tf.keyboardType = UIKeyboardTypeNumberPad;
    tf.font = [UIFont systemFontOfSize:15];
    
    leftLabel.text = @"手机号";
    
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.leftView = leftLabel;
    tf.delegate = self;
    
    [self.view addSubview:tf];

    _phoneNumTF = tf;

    //提示按钮
    [tipBtn setImage:[UIImage imageNamed:@"提示"] forState:UIControlStateNormal];
    [tipBtn addTarget:self action:@selector(tip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tipBtn];
    
    //分割线
    for(int i = 0; i < 4; i++)
    {
        UIView *lineView = [[UIView alloc] init];
        if (iphone6P) {
            lineView.frame = CGRectMake(0, 12+49*i, DeviceWidth, 1);

        }else{
            lineView.frame = CGRectMake(0, 12+45*i, DeviceWidth, 1);

        }
        lineView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        [self.view addSubview:lineView];
    }
    
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
    
    //_nextBtn = nextBtn;
    
    tipLabel.text = @"此卡为默认放款卡和还款卡，如果想更换默认还款卡，可在个人中心-个人资料-银行卡中绑定并设置";
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:13];
    tipLabel.textColor = [UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1.00];
    [self.view addSubview:tipLabel];
}

-(void)creatPickerView{
    
    if (!_cityPickerView)
    {
        SearchCityOrCode *transfor =[[SearchCityOrCode alloc]init];
        
        self.provinceArr = [transfor provinceAll];
        
        if (self.provinceArr.count > 0) {
            NSString *strProvinceName = self.provinceArr[0];
            
            self.cityArr = [transfor cityAllFromProv:strProvinceName];
            
            if (self.cityArr.count > 0) {
                _cityPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-200, DeviceWidth, 200)];
                
                _cityPickerView.backgroundColor =[UIColor colorWithRed:243 green:243 blue:243 alpha:1.0];
                _cityPickerView.dataSource = self;
                
                _cityPickerView.delegate = self;
                
                _cityPickerView.tag = 30;
                
                [self.view addSubview:_cityPickerView];
                
                [self creatGroundView];
            }
        }
    }
    
    _cityPickerView.hidden = NO;
    _groundView.hidden = NO;
    [_phoneNumTF resignFirstResponder];
}

- (void)creatGroundView
{
    _groundView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-200, DeviceWidth, 35)];
    _groundView.backgroundColor = [UIColor colorWithRed:248 green:248 blue:248 alpha:1.0];
    [self.view addSubview:_groundView];
    
    UIButton *sureBtn  = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-65, 0, 35, 35)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:UIColorFromRGB(0x32beff, 1.0) forState:UIControlStateNormal];
    sureBtn.tag = 76;
    sureBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
    [sureBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:sureBtn];
    
    UIButton *releaseBtn  = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 35, 35)];
    releaseBtn.tag = 77;
    releaseBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
    [releaseBtn setTitle:@"取消" forState:UIControlStateNormal];
    [releaseBtn setTitleColor:UIColorFromRGB(0x32beff, 1.0) forState:UIControlStateNormal];
    [releaseBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
    [_groundView addSubview:releaseBtn];
}

#pragma mark - 点击事件
- (void)onBackBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toNext:(UIButton *)btn
{
    _cityPickerView.hidden = YES;
    _groundView.hidden = YES;
    
    if(_kaiHuShi && _kaiHuSheng)
    {
        SearchCityOrCode *searc  = [[SearchCityOrCode alloc]init];
        NSArray *cityArray = [searc cityAllFromProv:_kaiHuSheng];
        if(![cityArray containsObject:_kaiHuShi])
        {
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"开户省份与城市不匹配,请重新选择" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                
            }];
            
            return;
        }
    }
    
    [_phoneNumTF resignFirstResponder];
    
    
        //没选开户省市
        if ([_detailCityLabel.text isEqualToString:@""] || _detailCityLabel.text ==nil)
        {
            [self showAlertWithMessage:@"请选择开户省市"];
        }else if ([_phoneNumTF.text isEqualToString:@""])
        {
            //没有输入手机号
            [self showAlertWithMessage:@"请输入手机号"];
        }else{
            //    全输入 没有空值
            BOOL telNumber = [_phoneNumTF.text isValidateMobileNum];
            //手机号码格式不正确
            if (telNumber == NO)
            {
                [self showAlertWithMessage:@"手机号码格式不正确"];
            }else
            {
                [self setRealName];
                
            }
    }
}

-(void)creatSureAction:(UIButton *)sender{
    
    if (sender.tag==76) {
        NSInteger one = [_cityPickerView selectedRowInComponent:0];
        
        NSInteger two = [_cityPickerView selectedRowInComponent:1];
        
        NSString *cityName = @"";
        NSString *twoString = @"";
        if (one < self.provinceArr.count) {
            cityName = self.provinceArr[one];
        }
        if (two < self.cityArr.count) {
            twoString  = self.cityArr[two];
        }
        
        NSString *text = [NSString stringWithFormat:@"%@%@",cityName,twoString];
        if (![text isEqualToString:@"" ])
        {
            _detailCityLabel.text = text;
            
            _kaiHuSheng = cityName;
            _kaiHuShi = twoString;
            
            SearchCityOrCode *searc  = [[SearchCityOrCode alloc]init];
            _kaiHuShengCode = [searc searchCode:_kaiHuSheng provinceCode:@"" cityCode:@"" type:typeProvince];
            _kaiHuShiCode = [searc searchCode:_kaiHuShi provinceCode:_kaiHuShengCode cityCode:@"" type:typeCity];
        }
    }
    
    _cityPickerView.hidden = YES;
    
    _groundView.hidden = YES;
    
    
    
}

- (void)tip
{
    [self showAlertWithMessage:@"银行预留手机号码是办理该银行卡时所填写的手机号码。没有预留、手机号码忘记或者已停用，请联系银行客服进行处理。"];
}

#pragma mark - pickerView的代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //component 列的编号 从0开始
    if (component == 0)
    {
        return self.provinceArr.count;
    }else
    {
        return self.cityArr.count;
    }
}

//返回值为显示的文本
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLab = (UILabel *)view;
    
    if (!pickerLab)
    {
        pickerLab = [[UILabel alloc]init];
        pickerLab.textAlignment = NSTextAlignmentCenter;
        pickerLab.font = [UIFont appFontRegularOfSize:16];
        pickerLab.textColor = [UIColor blackColor];
    }
    
    //component 列的编号 从0开始
    if (component == 0) {
        if (row < self.provinceArr.count)
        {
            pickerLab.text = self.provinceArr[row];
        }
    }else if(component == 1)
    {
        if (row < self.cityArr.count)
        {
            pickerLab.text = self.cityArr[row];
        }
    }

    
    return pickerLab;
}

//选中某列某行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //刷新所有列
    SearchCityOrCode *transfor =[[SearchCityOrCode alloc]init];
    if (component == 0)
    {
        strProvinceNameTemp = self.provinceArr[row];
        
        self.cityArr = [transfor cityAllFromProv:StringOrNull(strProvinceNameTemp)];
        
        [pickerView reloadComponent:1];
        
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
    }else if (component == 1)
    {
        
        
    }
}

#pragma mark - 做网络请求的方法
// 实名认证接口
-(void)setRealName{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //新增接口  实名修改登录密码支付密码
    if ([AppDelegate delegate].userInfo.userId)
    {
        _useIdStr = [AppDelegate delegate].userInfo.userId;
    }else
    {
        _useIdStr = _strTel;
    }
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:[EnterAES simpleEncrypt:_useIdStr] forKey:@"userId"];
    
    [dic setObject:[EnterAES simpleEncrypt:_nameText] forKey:@"custName"];
    
    [dic setObject:[EnterAES simpleEncrypt:_idText] forKey:@"certNo"];
    
    [dic setObject:[EnterAES simpleEncrypt:_cardText] forKey:@"cardNo"];
    
    [dic setObject:[EnterAES simpleEncrypt:_phoneNumTF.text] forKey:@"mobile"];
    
    [dic setObject:_bankCode forKey:@"bankCode"];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/uauth/identify" requestArgument:dic requestTag:10086 requestClass:NSStringFromClass([self class])];
}

#pragma mark - bsvkDelegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 10086){
        
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            ChangePasswordRealNameModel *model = [ChangePasswordRealNameModel mj_objectWithKeyValues:responseObject];
            
            [self analysisChangePasswordRealNameModel:model];
        }
    }
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if(httpCode != 0)
        {
            [self showAlertWithMessage:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode]];
        }
        else
        {
            [self showAlertWithMessage:@"网络环境异常，请检查网络并重试"];
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

- (void)analysisChangePasswordRealNameModel:(ChangePasswordRealNameModel *)model
{
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        
        if (self.reservedNumberChageBindPhoneNumType == ReservedNumberChangeDealPwdByNoRemeber) {
            //实名认证修改支付密码
            WriteVerificationViewController *control = [[WriteVerificationViewController alloc]init];
            control.writeVerificationChageBindPhoneNumType =  WriteVerificationChangeDealPwdByNoRemeber;
//            control.bankDict = [NSMutableDictionary dictionary];
//            control.bankDict = _bankDict;
            control.strTel = [AppDelegate delegate].userInfo.userId;//登录状态下这个是userTel
            control.getCodeTel = _phoneNumTF.text;
//            [control.bankDict setObject:_bankCode forKey:@"bankCode"];
            control.getCodeTel = model.body.mobile;  //接受验证码的手机号
            [self.navigationController pushViewController:control animated:YES];
        }else{
            //实名认证密码修改登录密码
            WriteVerificationViewController *control = [[WriteVerificationViewController alloc]init];
            control.getCodeTel = model.body.mobile;  //接受验证码的手机号
            control.strTel = _strTel;
            [self.navigationController pushViewController:control animated:YES];
        }
    }else
    {
        [self showAlertWithMessage:model.head.retMsg];
    }
}

#pragma mark - textField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{

    _cityPickerView.hidden = YES;
    
    _groundView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [_phoneNumTF resignFirstResponder];
}
@end
