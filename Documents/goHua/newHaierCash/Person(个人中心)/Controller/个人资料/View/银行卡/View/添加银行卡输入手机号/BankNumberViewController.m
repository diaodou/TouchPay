//
//  BankNumberViewController.m
//  personMerchants
//
//  Created by 百思为科 on 16/5/19.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "BankNumberViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "RMUniversalAlert.h"
#import "BankCodeViewController.h"
//#import "LittleToolClass.h"
#import "AppDelegate.h"
#import "BSVKHttpClient.h"
//#import "BankTypeModel.h"
#import <MBProgressHUD.h>
#import "SearchCityOrCode.h"
#import "NSString+CheckConvert.h"
#import "UIButton+UnifiedStyle.h"
@interface BankNumberViewController ()<BSVKHttpClientDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{

    NSString * _kaiHuSheng;
    NSString * _kaiHuShi;
    NSString * _kaiHuShengCode;
    NSString * _kaiHuShiCode;
    NSString * _cityFrom;
}
//省 数组
@property (strong, nonatomic) NSArray *provinceArr;
//城市 数组
@property (strong, nonatomic) NSArray *cityArr;

@property (nonatomic,strong) UILabel * cityName;
@property (nonatomic,strong) UITextField *numberTextField;
@property (nonatomic,strong) UIPickerView *cityPickerViw;//城市地址选择器
@property (nonatomic,strong) UIView *groundView;//盛放确定和取消按钮的视图
@end

@implementation BankNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_fromType == FromEdit) {
        self.title = @"编辑银行卡";
    }else{
        self.title = @"绑定银行卡";
    }
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    if (_provinceCode && _provinceCode.length > 0) {
        
        [self Assignment]; //赋值
        
    }

    [self setLayout];

    [self setButton];
}
#pragma mark - setting and getting
- (void)Assignment{
    
    SearchCityOrCode * search = [[SearchCityOrCode alloc]init];
    
    NSString *province = [search searchName:_provinceCode provinceCode:@"" cityCode:@"" type:typeProvince];
    
    NSString *city = [search searchName:_cityCode provinceCode:_provinceCode cityCode:@"" type:typeCity];
    _cityFrom = [NSString stringWithFormat:@"%@%@",province,city];
    
    _kaiHuShengCode = _provinceCode;
    
    _kaiHuShiCode = _cityCode;
}
-(void)setLayout{

    UILabel *fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, DeviceWidth - 20, 30)];
    
    fixedLabel.text = @"请绑定本人银行卡";
    
    fixedLabel.textColor = UIColorFromRGB(0xf6f6f6f, 1.0);
    
    fixedLabel.font = [UIFont appFontRegularOfSize:14];
    
    [self.view addSubview:fixedLabel];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, DeviceWidth, 150)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:backView];
    
    
    UIView *lineTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 1)];
    
    lineTopView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [backView addSubview:lineTopView];
    
    UIView *lineCenterView = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, DeviceWidth, 1)];
    
    lineCenterView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [backView addSubview:lineCenterView];

    UIView *lineRightView = [[UIView alloc]initWithFrame:CGRectMake(0, 99, DeviceWidth, 1)];
    
    lineRightView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [backView addSubview:lineRightView];

    UILabel * fixedCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 49.5)];
    
    fixedCardLabel.textColor = UIColorFromRGB(0x333333, 1.0);
    
    fixedCardLabel.text = @"卡类型";
    
    fixedCardLabel.font = [UIFont appFontRegularOfSize:14];
    
    [backView addSubview:fixedCardLabel];
    
    UILabel * fixedchoiceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50.5, 80, 49.5)];
    
    fixedchoiceLabel.textColor = UIColorFromRGB(0x333333, 1.0);
    
    fixedchoiceLabel.text = @"开户省市";
    
    fixedchoiceLabel.font = [UIFont appFontRegularOfSize:14];
    
    [backView addSubview:fixedchoiceLabel];
    
    UILabel *cityName = [[UILabel alloc]initWithFrame:CGRectMake(100 *DeviceWidth/375,50.5, DeviceWidth - 80 *DeviceWidth/375, 49.5)];
   
    cityName.textColor = UIColorFromRGB(0x333333, 1.0);
    
    cityName.font = [UIFont appFontRegularOfSize:14];
    
    cityName.text = _cityFrom;
    
    self.cityName = cityName;
    
    [backView addSubview:cityName];
    
    UIButton * choiceBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    choiceBtn.frame = CGRectMake(80 *DeviceWidth/375,50.5, DeviceWidth - 80 *DeviceWidth/375, 49.5);
    
    [choiceBtn addTarget:self action:@selector(tapAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:choiceBtn];
    
    UILabel * fixedNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100.5, 60, 49.5)];
    
    fixedNumLabel.textColor = UIColorFromRGB(0x333333, 1.0);
    
    fixedNumLabel.text = @"手机号";
    
    fixedNumLabel.font = [UIFont appFontRegularOfSize:14];
    
    [backView addSubview:fixedNumLabel];
    
    UILabel *cardNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80 * DeviceWidth/375, 0, 150, 49.5)];
    
    cardNameLabel.font = [UIFont appFontRegularOfSize:14];
    
    cardNameLabel.text = _bankName;
    
    cardNameLabel.textColor = UIColorFromRGB(0x333333, 1.0);
    
    [backView addSubview:cardNameLabel];
    
    UILabel *cardTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth - 20, 49.5)];
    
    cardTypeLabel.textAlignment = NSTextAlignmentRight;
    
    cardTypeLabel.font = [UIFont appFontRegularOfSize:14];
    
    cardTypeLabel.text = _bankType;// 银行卡类型
    
    cardTypeLabel.textColor = UIColorFromRGB(0x333333, 1.0);
    
    [backView addSubview:cardTypeLabel];

    
    
    _numberTextField = [[UITextField alloc]initWithFrame:CGRectMake(80 *DeviceWidth/375, 100.5, DeviceWidth - 80 *DeviceWidth/375, 49.5)];
    
    if (_mobile) {
        
        _numberTextField.text = _mobile;
    }
    
    _numberTextField.delegate = self;
    
    _numberTextField.placeholder = @"银行预留手机号";
    
    _numberTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    _numberTextField.font = [UIFont appFontRegularOfSize:14];
    
    _numberTextField.textColor = UIColorFromRGB(0x333333, 1.0);
    
    [backView addSubview:_numberTextField];
    
    UIImageView * arrow = [[UIImageView alloc]initWithFrame:(CGRectMake(DeviceWidth - 16 - 12 , 67.5, 12, 15))];
    arrow.image = [UIImage imageNamed:@"右侧箭头"];

    [backView addSubview:arrow];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    btn.frame = CGRectMake(DeviceWidth - 40, 115, 20, 20);
    
    [btn setImage:[UIImage imageNamed:@"提示"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(message) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:btn];
}
-(void)setButton{

    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    if (iphone6P) {
        
        nextBtn.frame = CGRectMake(47 , 200, DeviceWidth - 94, 50);
        
        nextBtn.layer.cornerRadius = 25;
        
    }else{
        
        nextBtn.frame = CGRectMake(42 *DeviceWidth/375 , 200, DeviceWidth - 84 *DeviceWidth/375, 45*DeviceWidth/375);
        
        nextBtn.layer.cornerRadius = 22.5*DeviceWidth/375;
        
    }
    
    [nextBtn setBackgroundColor:UIColorFromRGB(0x32beff, 1.0)];
    
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];

    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    nextBtn.titleLabel.font = [UIFont appFontRegularOfSize:17];
    
    [nextBtn addTarget:self action:@selector(nextBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextBtn];
}
//笼罩视图
-(void)creatGroundView{
    
    _groundView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-200, DeviceWidth, 50)];
    
    _groundView.hidden = YES;
    
    [self.view addSubview:_groundView];
    
    UIButton *sureBtn  = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-65, 0, 35, 35)];
    
    [sureBtn setButtonTitle:@"确定" titleFont:14 buttonHeight:35];
    
    sureBtn.tag = 76;
    
    [sureBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_groundView addSubview:sureBtn];
    
    UIButton *releaseBtn  = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 35, 35)];
    
    releaseBtn.tag = 77;
        
    [releaseBtn setButtonTitle:@"取消" titleFont:14 buttonHeight:35];
    
    [releaseBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_groundView addSubview:releaseBtn];
    
}

//zjj
-(void)creatPickerView{
    
    if (!_cityPickerViw)
    {
        SearchCityOrCode *transfor =[[SearchCityOrCode alloc]init];
        
        self.provinceArr = [transfor provinceAll];
        
        if (self.provinceArr.count > 0) {
            NSString *strProvinceName = self.provinceArr[0];
            
            self.cityArr = [transfor cityAllFromProv:strProvinceName];
            
            if (self.cityArr.count > 0) {
                _cityPickerViw = [[UIPickerView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-200, DeviceWidth, 200)];
                
                _cityPickerViw.dataSource =self;
                
                _cityPickerViw.delegate = self;
                
                _cityPickerViw.tag = 30;
                
                [self.view addSubview:_cityPickerViw];
                
                [self creatGroundView];
            }
        }
    }else
    {
        _cityPickerViw.hidden = NO;
    }
}
#pragma mark - private Methods
// 确定按钮
-(void)creatSureAction:(UIButton *)sender{
    
    if (sender.tag==76) {
        NSInteger one = [_cityPickerViw selectedRowInComponent:0];
        
        NSInteger two = [_cityPickerViw selectedRowInComponent:1];
        
        NSString *cityName = @"";
        NSString *twoString = @"";
        if (one < self.provinceArr.count) {
            cityName = self.provinceArr[one];
        }
        if (two < self.cityArr.count) {
            twoString  = self.cityArr[two];
        }
        
        NSString *text = [NSString stringWithFormat:@"%@%@",cityName,twoString];
        if (![text isEqualToString:@"" ]) {
            self.cityName.text = text;
            self.cityName.font = [UIFont appFontRegularOfSize:14];
            _kaiHuSheng = cityName;
            _kaiHuShi = twoString;
            
            SearchCityOrCode *searc  = [[SearchCityOrCode alloc]init];
            _kaiHuShengCode = [searc searchCode:_kaiHuSheng provinceCode:@"" cityCode:@"" type:typeProvince];
            _kaiHuShiCode = [searc searchCode:_kaiHuShi provinceCode:_kaiHuShengCode cityCode:@"" type:typeCity];
        }
    }
    
    _cityPickerViw.hidden = YES;
    
    _groundView.hidden = YES;
    
}
-(void)tapAction:(UIView *)sender{
    
    [_numberTextField resignFirstResponder];
    
    [self creatPickerView];
    
    _cityPickerViw.hidden = NO;
    _groundView.hidden = NO;
    
}

// 手机号 提示
-(void)message{

    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"银行预留手机号码是办理该银行卡时所填写的手机号码。没有预留、手机号码忘记或者已停用，请联系银行客服进行处理。" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                
            }
        }
    }];

}
-(void)nextBtn:(UIButton *)btn{
    if (!(_kaiHuShi && _kaiHuSheng)&&!_cityFrom) {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请选择开户省市" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
            
        }];
        return;
    }
    
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
    
    [_numberTextField resignFirstResponder];
    
    BOOL numberLength = [_numberTextField.text isValidateMobileNum];
    
    if (numberLength == YES) {
        BankCodeViewController *vc = [[BankCodeViewController alloc]init];
        
            vc.changeTel = _numberTextField.text;
            vc.bankName = _bankName;
            vc.bankType = _bankType;
            vc.cardText = _cardText;
            vc.bankNo = _bankNo;
            vc.provinceStr = _kaiHuShengCode;
            vc.cityStr = _kaiHuShiCode;
            vc.areaStr = _areaCode;
            vc.bankCodeType = BankEdit;
            [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        if (_numberTextField.text.length > 0) {
            WEAKSELF
            
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"手机号码格式不正确" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                if (strongSelf) {
                    if (buttonIndex == 0) {
                        
                    }
                }
            }];
        }else{
            WEAKSELF
            
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请输入手机号" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                if (strongSelf) {
                    if (buttonIndex == 0) {
                        
                    }
                }
            }];
        }
    }
}
#pragma mark -->pickerView的代理方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    //component 列的编号 从0开始
    if (component == 0) {
        
        return self.provinceArr.count;
        
    }else{
        
        return self.cityArr.count;
        
    }
}

//返回值为显示的文本

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLab = (UILabel *)view;
    
    if (!pickerLab) {
        
        pickerLab = [[UILabel alloc]init];
        
        pickerLab.textAlignment = NSTextAlignmentCenter;
        
        pickerLab.font = [UIFont appFontRegularOfSize:14];
        
        pickerLab.textColor = UIColorFromRGB(0x333333, 1.0);
        
    }
    if (pickerView.tag == 30){
        //component 列的编号 从0开始
        if (component == 0) {
            if (row < self.provinceArr.count) {
                pickerLab.text = self.provinceArr[row];
            }
        }else if(component == 1){
            if (row < self.cityArr.count) {
                pickerLab.text = self.cityArr[row];
            }
        }
    }
    
    return pickerLab;
    
}

//选中某列某行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //刷新所有列
    //    [pickerView reloadAllComponents];
    SearchCityOrCode *transfor =[[SearchCityOrCode alloc]init];
    if (pickerView.tag == 30) {
        
        if (component == 0) {
            
            NSString *strProvinceNameTemp = self.provinceArr[row];
            
            self.cityArr = [transfor cityAllFromProv:StringOrNull(strProvinceNameTemp)];
            
            [pickerView reloadComponent:1];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
        }else if (component == 1){
            
            
        }
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _cityPickerViw.hidden = YES;
    _groundView.hidden = YES;
}
@end

