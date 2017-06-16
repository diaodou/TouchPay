//
//  HCCheckBankViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCCheckBankViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "RMUniversalAlert.h"
#import "PostSuccessModel.h"
#import "DefineSystemTool.h"
#import <MBProgressHUD.h>
#import "BSVKHttpClient.h"
#import "AppDelegate.h"
#import "WriteVerModel.h"
#import "UILabel+SizeForStr.h"
#import "WhiteSearchModel.h"
#import "EnterAES.h"
#import "ReservedModel.h"
#import "SearchCityOrCode.h"
#import "BankIardInformation.h"
#import "SearchCityOrCode.h"
#import "UIColor+DefineNew.h"
#import "SupportBankViewController.h"
#import "InvitationModel.h"
static CGFloat const GetCode = 110;//获取验证码
static CGFloat const getBankInfo = 120;//获取银行卡类型
static CGFloat const fCiCustRealThreeInfo = 4 ;          //实名认证
static CGFloat const getCustIsPassTwo = 12;                    //白名单类型查询
static CGFloat const updateCardPostive = 9;              //上传身份证正面
static CGFloat const updateCardTheOther = 10;            //上传身份证反面
static CGFloat const getCustISExistsInvitedCauseTagTwo = 13;                    //用户邀请原因查询
@interface HCCheckBankViewController ()<BSVKHttpClientDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

{
    
    float x;//屏幕适配比例
    
    NSInteger _time;
    
     UIView *_groundView;
    
    UILabel *_cityLabel;//开户省市
    
    NSString *_province;//开户省
    
    NSString *_city;//开户市
    
    NSString *strProvinceNameTemp;
    
    /*
     区分从哪里继续进行接口流程，避免重走已经走过的接口
     */
    BOOL _fromUpdateCardPostive;        //上传身份证正面开始
    
    BOOL _fromUpdateCardTheOther;       //上传身份证反面开始
    
    WhiteSearchModel *_seachModel;
    

}

@property (nonatomic,strong)UITextField *cardTextField;//银行卡输入框

@property (nonatomic,strong)UILabel *cardTypeLabel;//银行卡类型label

@property (nonatomic,strong)UILabel *cardCityLabel;//银行卡预留省市label

@property (nonatomic,strong)UITextField *phoneTextField;//预留手机号输入框

@property (nonatomic,strong)UITextField *codeTextField;//验证码输入框

@property (nonatomic,strong)UILabel *timeLabel;//验证码label

@property (nonatomic,strong)UIButton *timeButton;//验证码按钮

@property (nonatomic,strong)UIView *timeView;

@property (nonatomic,strong)NSTimer *timer;//定时器

@property (nonatomic,strong)UIScrollView *baseScrollView;

//省 数组
@property (strong, nonatomic) NSArray *provinceArr;
//城市 数组
@property (strong, nonatomic) NSArray *cityArr;
//区县 数组
@property (strong, nonatomic) NSArray *areaArr;

@property (nonatomic, strong) UIPickerView *cityPickerViw;


@end

@implementation HCCheckBankViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];

    [self creatBaseUI];
    
    [self creatCityPickerView];
    
    [self creatGroundView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setCardDic:(NSMutableDictionary *)cardDic{
    
    _cardDic = cardDic;
    
    UILabel *nameLab;
    
    if (IPHONE4) {
        
        nameLab = (UILabel *)[_baseScrollView viewWithTag:210];
        
    }else{
        
        nameLab = (UILabel *)[self.view viewWithTag:210];
        
    }
    
    if ([_cardDic objectForKey:@"最后姓名"]) {
        
         nameLab.text = [_cardDic objectForKey:@"最后姓名"];
        
    }else{
     
         nameLab.text = [_cardDic objectForKey:@"姓名"];
        
    }
    
}

#pragma mark --> private Methods

//创建基本视图
-(void)creatBaseUI{
    
    float height;
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
    }
    
    if (IPHONE4) {
        
        height = 0;
        
        _baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 107*x, DeviceWidth, DeviceHeight-107*x-64)];
        
        _baseScrollView.showsVerticalScrollIndicator = NO;
        
        [self.view addSubview:_baseScrollView];
        
    }else{
        
        height = 107*x;
        
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 97*x, DeviceWidth, 10*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:lineView];
    
    NSArray *array = @[@"持卡人",@"卡号",@"卡类型",@"开户省市",@"预留手机号",@"验证码"];
    
    for (int i = 0; i < array.count; i++) {
        
       UILabel *label = [self creatTemplateLabelFrame:CGRectMake(15*x, 15*x+50*x*i+height, 100*x, 20*x) text:array[i] textColor:UIColorFromRGB(0x333333, 1.0)];
        
        if (IPHONE4) {
            
            [_baseScrollView addSubview:label];
            
        }else{
            
           [self.view addSubview:label];
            
        }
        
       
        
        [self creatTemplateViewFrame:CGRectMake(14*x, 50*x+height+50*x*i, DeviceWidth-28*x, 1*x)];
        
    }
    
    //持卡人一栏
    NSString *string;
    
    if ([_cardDic objectForKey:@"最后姓名"]) {
        
        string = [_cardDic objectForKey:@"最后姓名"];
        
    }else{
        
        string = [_cardDic objectForKey:@"姓名"];
        
    }
    
    UILabel *nameLabel = [self creatTemplateLabelFrame:CGRectMake(125*x, 15*x+height, DeviceWidth-166*x, 20*x) text:string textColor:UIColorFromRGB(0x999999, 1.0)];
    
    nameLabel.textAlignment = NSTextAlignmentRight;
    
    nameLabel.tag = 210;
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:nameLabel];
        
    }else{
        
        [self.view addSubview:nameLabel];
        
    }
    
    UIImageView *nameImg = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-30*x, 18.5*x+height, 15*x, 15*x)];
    
    nameImg.image = [UIImage imageNamed:@"资格校检_说明"];
    
    UIButton *nameBtn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-40*x, height, 40*x, 50*x)];
    
    nameBtn.backgroundColor = [UIColor clearColor];
    
    [nameBtn addTarget:self action:@selector(buildTouchNameWarn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:nameImg];
        
        [_baseScrollView addSubview:nameBtn];
        
    }else{
        
        [self.view addSubview:nameImg];
        
        [self.view addSubview:nameBtn];
        
    }
    
    //卡号一栏
    _cardTextField = [self creatTemplateTextFieldFrame:CGRectMake(125*x, 65*x+height, DeviceWidth-166*x, 20*x) text:@"请输入银行卡号"];
    
    _cardTextField.delegate = self;
    
    _cardTextField.returnKeyType = UIReturnKeyDone;
    
    [self creatTemplateImgViewFrame:CGRectMake(DeviceWidth-30*x, 68.5*x+height, 15*x, 15*x) imageName:@"资格校检_说明"];
    
    UIButton *cardBtn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-40*x, height+50*x, 40*x, 50*x)];
    
    cardBtn.backgroundColor = [UIColor clearColor];
    
    [cardBtn addTarget:self action:@selector(buildToSuppotBank:) forControlEvents:UIControlEventTouchUpInside];
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:_cardTextField];
        
        [_baseScrollView addSubview:cardBtn];
        
    }else{
        
        [self.view addSubview:_cardTextField];
        
        [self.view addSubview:cardBtn];
        
    }
    
    //银行卡类型一栏
    _cardTypeLabel = [self creatTemplateLabelFrame:CGRectMake(125*x, 115*x+height, DeviceWidth-155*x, 20*x) text:@"" textColor:UIColorFromRGB(0x999999, 1.0)];
    
    _cardTypeLabel.textAlignment = NSTextAlignmentRight;
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:_cardTypeLabel];
        
    }else{
        
        [self.view addSubview:_cardTypeLabel];
        
    }
    
    [self creatTemplateImgViewFrame:CGRectMake(DeviceWidth-30*x, 118.5*x+height, 8*x, 13*x) imageName:@"首页_箭头右"];
    
    //开户省市一栏
    _cardCityLabel = [self creatTemplateLabelFrame:CGRectMake(125*x, 165*x+height, DeviceWidth-155*x, 20*x) text:@"" textColor:UIColorFromRGB(0x999999, 1.0)];
    
    _cardCityLabel.textAlignment = NSTextAlignmentRight;
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:_cardCityLabel];
        
    }else{
        
        [self.view addSubview:_cardCityLabel];
        
    }
    
     [self creatTemplateImgViewFrame:CGRectMake(DeviceWidth-30*x, 168.5*x+height, 8*x, 13*x) imageName:@"首页_箭头右"];
    
    UIButton *cityButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 150*x+height, DeviceWidth, 50*x)];
    
    cityButton.backgroundColor = [UIColor clearColor];
    
    [cityButton addTarget:self action:@selector(buildTouchCity) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cityButton];
    
    //预留手机号一栏
    _phoneTextField = [self creatTemplateTextFieldFrame:CGRectMake(125*x, 215*x+height, DeviceWidth-166*x, 20*x) text:@"请输入银行预留手机号"];
    
    [self creatTemplateImgViewFrame:CGRectMake(DeviceWidth-30*x, 218.5*x+height, 15*x, 15*x) imageName:@"资格校检_说明"];
    
    UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-40*x, height+200*x, 40*x, 50*x)];
    
    phoneBtn.backgroundColor = [UIColor clearColor];
    
    [phoneBtn addTarget:self action:@selector(buildTouchPhoneWarn:) forControlEvents:UIControlEventTouchUpInside];
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:_phoneTextField];
        
        [_baseScrollView addSubview:phoneBtn];
        
    }else{
        
        [self.view addSubview:_phoneTextField];
        
        [self.view addSubview:phoneBtn];
        
    }
    
    //验证码一栏
    _codeTextField = [self creatTemplateTextFieldFrame:CGRectMake(125*x, 265*x+height, DeviceWidth-239*x, 20*x) text:@"短信验证码"];
  
    if (IPHONE4) {
        
        [_baseScrollView addSubview:_codeTextField];
        
    }else{
        
        [self.view addSubview:_codeTextField];
        
    }
    
    _timeView = [[UIView alloc]initWithFrame:CGRectMake(DeviceWidth-95*x, 261*x+height, 80*x, 28*x)];
    
    _timeView.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    _timeView.layer.cornerRadius = 14*x;
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:_timeView];
        
    }else{
        
        [self.view addSubview:_timeView];
        
    }
    
    _timeLabel = [self creatTemplateLabelFrame:CGRectMake(DeviceWidth-95*x, 261*x+height, 80*x, 28*x) text:@"获取验证码" textColor:[UIColor whiteColor]];
    
    _timeLabel.backgroundColor = [UIColor clearColor];
    
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:_timeLabel];
        
    }else{
        
        [self.view addSubview:_timeLabel];
        
    }
    
    _timeButton = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-95*x, 261*x+height, 80*x, 28*x)];
    
    _timeButton.backgroundColor = [UIColor clearColor];
    
    [_timeButton addTarget:self action:@selector(buildTouchSendCode:) forControlEvents:UIControlEventTouchUpInside];
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:_timeButton];
        
    }else{
        
        [self.view addSubview:_timeButton];
        
    }
    
    //说明文字
    UILabel *warnLabel = [self creatTemplateLabelFrame:CGRectMake(14*x, 314*x+height, DeviceWidth-28*x, 20*x) text:@"此卡为默认放款卡,如果想更换默认还款卡,可在个人中心-个人资料-银行卡中绑定并设置" textColor:UIColorFromRGB(0x999999, 1.0)];
    
    CGSize size = [warnLabel boundingRectWithSize:CGSizeMake(DeviceWidth-28*x, NSIntegerMax)];
    
    if (size.height >20) {
        
        warnLabel.frame = CGRectMake(14*x, 314*x+height, DeviceWidth-28*x, size.height);
        
        warnLabel.numberOfLines = 0;
        
    }
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:warnLabel];
        
    }else{
        
        [self.view addSubview:warnLabel];
        
    }
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(47*x, warnLabel.frame.origin.y+warnLabel.frame.size.height+40*x, DeviceWidth-94*x, 50*x)];
    
    nextButton.layer.cornerRadius = 25*x;
    
    nextButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    nextButton.titleLabel.font = [UIFont appFontRegularOfSize:15*x];
    
    [nextButton addTarget:self action:@selector(buildToNextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:nextButton];
        
        _baseScrollView.contentSize = CGSizeMake(DeviceWidth, nextButton.frame.origin.y+nextButton.frame.size.height+30*x);
        
    }else{
        
        [self.view addSubview:nextButton];
        
    }
    
}

//创建模板label
-(UILabel *)creatTemplateLabelFrame:(CGRect)frame text:(NSString *)title textColor:(UIColor *)color{
    
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    label.text = title;
    
    label.font = [UIFont appFontRegularOfSize:13*x];
    
    label.textColor = UIColorFromRGB(0x333333, 1.0);
    
    label.textColor = color;
    
    return label;
    
}

//创建模板textField
-(UITextField *)creatTemplateTextFieldFrame:(CGRect)frame text:(NSString *)plan{
    
    UITextField *text = [[UITextField alloc]initWithFrame:frame];
    
    text.placeholder = plan;
    
    text.font = [UIFont appFontRegularOfSize:15*x];
    
    text.textColor = UIColorFromRGB(0x999999, 1.0);
    
    text.delegate = self;
    
    text.textAlignment = NSTextAlignmentRight;
    
    return text;
    
}

//创建模板view
-(void)creatTemplateViewFrame:(CGRect)frame{
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    
    view.backgroundColor = UIColorFromRGB(0xdddddd, 1.0);
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:view];
        
    }else{
        
        [self.view addSubview:view];
        
    }
    
}

//创建模板view
-(void)creatTemplateImgViewFrame:(CGRect)frame imageName:(NSString *)name{
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:frame];
    
    view.image = [UIImage imageNamed:name];
    
    if (IPHONE4) {
        
        [_baseScrollView addSubview:view];
        
    }else{
        
        [self.view addSubview:view];
        
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

//创建城市地址选择器
-(void)creatCityPickerView{
    
    SearchCityOrCode *codr = [[SearchCityOrCode alloc]init];
    
    self.provinceArr = [codr provinceAll];
    
    if (self.provinceArr.count > 0) {
        
        self.cityArr = [codr cityAllFromProv:self.provinceArr[0]];
        
        if (self.cityArr.count > 0) {
            
            self.areaArr = [codr areaAllFromProv:self.provinceArr[0] andCityName:self.cityArr[0]];
            
        }
        
    }
    _cityPickerViw = [[UIPickerView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-200*x, DeviceWidth, 200*x)];
    
    _cityPickerViw.dataSource =self;
    
    _cityPickerViw.delegate = self;
    
    _cityPickerViw.tag = 45;
    
    _cityPickerViw.hidden = YES;
    
    _cityPickerViw.backgroundColor = [UIColor UIColorWithRed:243 green:243 blue:243 alpha:1.0];
    
    [self.view addSubview:_cityPickerViw];
    
}

//创建确定和取消按钮
-(void)creatGroundView{
    
    _groundView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-200*x, DeviceWidth, 50*x)];
    
    _groundView.backgroundColor = [UIColor UIColorWithRed:248 green:248 blue:248 alpha:1.0];

    
    _groundView.hidden = YES;
    
    [self.view addSubview:_groundView];
    
    UIButton *sureBtn  = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-65, 0, 35, 35)];
    
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];

    [sureBtn setTitleColor:[UIColor UIColorWithRed:27 green:156 blue:253 alpha:1.0] forState:UIControlStateNormal];
    
    sureBtn.tag = 76;
    
    sureBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    [sureBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_groundView addSubview:sureBtn];
    
    UIButton *releaseBtn  = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 35, 35)];
    
    releaseBtn.tag = 77;
    
    releaseBtn.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    [releaseBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [releaseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [releaseBtn addTarget:self action:@selector(creatSureAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_groundView addSubview:releaseBtn];
    
}



#pragma mark --> event Methods

//点击开户省市
-(void)buildTouchCity{
    
    _cityPickerViw.hidden = NO;
    
    _groundView.hidden = NO;
    
}

//点击确定，取消执行的方法
-(void)creatSureAction:(UIButton *)sender{
    
    if (sender.tag == 76) {
        
        NSInteger one = [_cityPickerViw selectedRowInComponent:0];
        
        NSInteger two = [_cityPickerViw selectedRowInComponent:1];
        
        NSInteger three = [_cityPickerViw selectedRowInComponent:2];
        
        NSString *cityName = @"";
        
        NSString *twoString = @"";
        
        NSString *areaName = @"";
        
        if (one < self.provinceArr.count) {
            
            cityName = self.provinceArr[one];
        }
        if (two < self.cityArr.count) {
            
            twoString  = self.cityArr[two];
            
        }
        
        if (three < self.areaArr.count) {
            
            areaName = self.areaArr[three];
        }
        
        
        //1.先通过0列的row获取 省份字典
        
         SearchCityOrCode *transform = [[SearchCityOrCode alloc]init];
        
        if (cityName.length>0) {
            
            _province = [transform searchCode:cityName provinceCode:@"" cityCode:@"" type:typeProvince];

            
        }else{
            
            _province = @"";
        }
        
        
        if (twoString.length > 0) {
            
            _city = [transform searchCode:twoString provinceCode:_province cityCode:@"" type:typeCity];
            
        }else{
            
            _city = @"";
        }
        
        //4.通过"sub"key获取城市包含的地区数组
        
        NSString *text = [NSString stringWithFormat:@"%@%@%@",cityName,twoString,areaName];
        
        _cardCityLabel.text = text;
        
        
    }
    
    _cityPickerViw.hidden = YES;
    
    _groundView.hidden = YES;
    
    
}



//点击获取验证码
-(void)buildTouchSendCode:(UIButton *)sender{
    
    if (_phoneTextField.text.length > 0) {
        
         [self buildGetCodeHttp];
        
    }else{
      
         [self buildHeadError:@"请输入银行预留手机号"];
        
    }
    
   
    
}

//定时器所调用的方法
-(void)buildChangeTime:(NSTimer *)changeTime{
    
    _time--;
    
    if (_time == 0) {
        
        [changeTime invalidate];
        
        _timer = nil;
        
        _timeLabel.text = @"重新发送";
        
        _timeView.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
        
        _timeButton.userInteractionEnabled = YES;
        
    }else{
        
        _timeLabel.text = [NSString stringWithFormat:@"%lds后重发",(long)_time];
        
        _timeView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
        
        _timeLabel.textColor = [UIColor whiteColor];
        
        _timeButton.userInteractionEnabled = NO;
        
    }
    
}

//点击持卡人提示
-(void)buildTouchNameWarn:(UIButton *)sender{
    
    [self buildHeadError:@"为了保证您的账户资金安全，只能帮您认证用户本人的银行卡"];
    
}

//点击银行预留手机号提示
-(void)buildTouchPhoneWarn:(UIButton *)sender{
    
    [self buildHeadError:@"银行预留手机号码是办理该银行卡时所填写的手机号码。没有预留、手机号码忘记或者已停用，请联系银行客服进行处理。"];
    
}

//查看所支持的银行
-(void)buildToSuppotBank:(UIButton *)sender{
    
    SupportBankViewController *supVc = [[SupportBankViewController alloc]init];
    
    HCRootNavController *nav = [[HCRootNavController alloc]initWithRootViewController:supVc];
    
    [self presentViewController:nav animated:YES completion:nil];
    
}

//点击下一步
-(void)buildToNextAction:(UIButton *)sender{
    
    if (_cardTextField.text.length == 0) {
        
        [self buildHeadError:@"请输入银行卡号"];
        
    }else if (_cardCityLabel.text.length == 0){
        
        [self buildHeadError:@"请选择开户省市"];
        
    }else if (_phoneTextField.text.length == 0){
        
        [self buildHeadError:@"请输入银行预留手机号"];
        
    }else if (_codeTextField.text.length == 0){
        
        [self buildHeadError:@"请输入验证码"];
        
    }else{
        
        if (_fromUpdateCardPostive) {
            
            [self updateCardPostive];
            
        }else if (_fromUpdateCardTheOther){
            
            [self updateCardTheOther];
            
        }else{
            
            [self buildSetRealName];
            
        }
        

    }

    
}

#pragma mark --> pickerView代理方法

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    
    return 3;
    
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    
    //component 列的编号 从0开始
    if (component == 0) {
        
        return self.provinceArr.count;
        
    }else if(component == 1){
        
        return self.cityArr.count;
        
    }else if (component == 2){
        
        
        return self.areaArr.count;
    }
    
    return 0;
    
}


//返回值为显示的文本

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLab = (UILabel *)view;
    
    if (!pickerLab) {
        
        pickerLab = [[UILabel alloc]init];
        
        pickerLab.textAlignment = NSTextAlignmentCenter;
        
        pickerLab.font = [UIFont appFontRegularOfSize:15];
        
        pickerLab.textColor = [UIColor blackColor];
        
    }
    
    //component 列的编号 从0开始
    if (component == 0) {
        
        if (row < self.provinceArr.count) {
            pickerLab.text = self.provinceArr[row];
        }
        
    }else if(component == 1){
        
        if (row < self.cityArr.count) {
            pickerLab.text = self.cityArr[row];
        }
        
    }else if (component == 2){
        if (row < self.areaArr.count) {
            pickerLab.text = self.areaArr[row];
        }
    }
    
    
    return pickerLab;
    
}

//选中某列某行的时候调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (pickerView.tag == 45) {
        
        SearchCityOrCode *transfor =[[SearchCityOrCode alloc]init];
        
        if (component == 0) {
            
            strProvinceNameTemp = self.provinceArr[row];
            
            self.cityArr = [transfor cityAllFromProv:StringOrNull(strProvinceNameTemp)];
            
            [pickerView reloadComponent:1];
            
            [pickerView selectRow:0 inComponent:1 animated:YES];
            
            NSString *strCityName = self.cityArr[0];
            
            self.areaArr = [transfor areaAllFromProv:strProvinceNameTemp andCityName:strCityName];
            
            [pickerView reloadComponent:2];
            
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
            
        }else if (component == 1){
            
            NSString *strCityName = self.cityArr[row];
            
            self.areaArr = [transfor areaAllFromProv:StringOrNull(strProvinceNameTemp) andCityName:strCityName];
            
            //刷新2列
            [pickerView reloadComponent:2];
            
            //滚动到0行
            [pickerView selectRow:0 inComponent:2 animated:YES];
            
        }else if (component == 2){
            
            //不需要更新
        }
    }
    
    
    
}


#pragma mark -->textField代理协议

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if ([textField isEqual:_cardTextField] && _cardTextField.text.length > 0) {
        
        [self buildGetCardType];
        
    }
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark --> 发起网络请求

// 上传身份证正面
- (void)updateCardPostive{
    
    NSString *strm;
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    NSData *data = (NSData *)[[AppDelegate delegate].imagePutCache objectForKey:@"身份证正面"];
    
    if (data && data.length > 0) {
        
        strm = [DefineSystemTool md5StringWithData:data];
    }else{
        
        data = UIImageJPEGRepresentation(_cardPosiviteImageView.image, ImageUpZScale);
        
        strm = [DefineSystemTool md5StringWithData:data];
    }
    
    NSString *name = @"DOC53.jpg";
    
    if ([AppDelegate delegate].userInfo.custNum.length > 0 && [AppDelegate delegate].userInfo.custNum) {
        
        [parm setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
        
    }
    
    [parm setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    
    [parm setObject:@"DOC53" forKey:@"attachType"];
    
    [parm setObject:@"身份证正面" forKey:@"attachName"];
    
    
    if (strm.length > 0 && strm) {
        
        [parm setObject:strm forKey:@"md5"];
        
    }
    
    [parm setObject:@"" forKey:@"commonCustNo"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [client puFile:@"app/appserver/attachUploadPerson" requestArgument:parm fileData:data fileName:name name:@"multipartFile" mimeType:@"image/jpeg" requestTag:updateCardPostive requestClass:NSStringFromClass([self class])];
}
// 上传身份证反面
- (void)updateCardTheOther{
    
    NSString *strm;
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    NSData *data = (NSData *)[[AppDelegate delegate].imagePutCache objectForKey:@"身份证反面"];
    
    if (data && data.length > 0) {
        
        strm = [DefineSystemTool md5StringWithData:data];
    }else{
        
        data = UIImageJPEGRepresentation(_cardTheOtherImageView.image, ImageUpZScale);
        
        strm = [DefineSystemTool md5StringWithData:data];
    }
    
    
    NSString *name = @"DOC54.jpg";
    
    if ([AppDelegate delegate].userInfo.custNum.length > 0 && [AppDelegate delegate].userInfo.custNum) {
        
        [parm setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
        
    }
    
    [parm setObject:@"DOC54" forKey:@"attachType"];
    
    [parm setObject:@"身份证反面" forKey:@"attachName"];
    
    [parm setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    
    if (strm.length > 0 && strm) {
        
        [parm setObject:strm forKey:@"md5"];
        
    }
    
    [parm setObject:@"" forKey:@"commonCustNo"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [client puFile:@"app/appserver/attachUploadPerson" requestArgument:parm fileData:data fileName:name name:@"multipartFile" mimeType:@"image/jpeg" requestTag:updateCardTheOther requestClass:NSStringFromClass([self class])];
}


// 查询邀请原因
- (void)searchTwoSocialReason {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    //持卡人一栏
    NSString *string;
    
    if ([_cardDic objectForKey:@"最后姓名"]) {
        
        string = [_cardDic objectForKey:@"最后姓名"];
        
    }else{
        
        string = [_cardDic objectForKey:@"姓名"];
        
    }
    
    [dic setObject:string forKey:@"custName"];
    
    [dic setObject:_phoneTextField.text forKey:@"phonenumber"];
    
    [dic setObject:[_cardDic objectForKey:@"身份号码"] forKey:@"certNo"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/crm/cust/getCustISExistsInvitedCauseTag" requestArgument:dic requestTag:getCustISExistsInvitedCauseTagTwo requestClass:NSStringFromClass([self class])];
}

//查询白名单类型
-(void)buildSearchTwoWhiteType{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:[_cardDic objectForKey:@"身份号码"] forKey:@"certNo"];
    
    UILabel *nameLab;
    
    if (IPHONE4) {
        
        nameLab = (UILabel *)[_baseScrollView viewWithTag:210];
        
    }else{
        
        nameLab = (UILabel *)[self.view viewWithTag:210];
        
    }
    
    [dic setObject:nameLab.text forKey:@"custName"];
    
    [dic setObject:_phoneTextField.text forKey:@"phonenumber"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/crm/cust/getCustIsPass" requestArgument:dic requestTag:getCustIsPassTwo requestClass:NSStringFromClass([self class])];
    
    
}


// 实名认证接口
-(void)buildSetRealName{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *bankDic = [[NSMutableDictionary alloc]init];
    
    //持卡人一栏
    NSString *string;
    
    if ([_cardDic objectForKey:@"最后姓名"]) {
        
        string = [_cardDic objectForKey:@"最后姓名"];
        
    }else{
        
        string = [_cardDic objectForKey:@"姓名"];
        
    }
    
    [bankDic setObject:string forKey:@"custName"];
    
    [bankDic setObject:[_cardDic objectForKey:@"身份号码"] forKey:@"certNo"];
    
    [bankDic setObject:_cardTextField.text forKey:@"cardNo"];
    
    [bankDic setObject:_phoneTextField.text forKey:@"mobile"];
    
    [bankDic setObject:[AppDelegate delegate].userInfo.userId forKey:@"userId"];
    
    [bankDic setObject:StringOrNull(_province) forKey: @"acctProvince"];
    
    [bankDic setObject:StringOrNull(_city) forKey:@"acctCity"];
    
    [bankDic setObject:@"app_person" forKey:@"dataFrom"];
    
    [bankDic setObject:StringOrNull([AppDelegate delegate].userInfo.userId) forKey:@"bindMobile"];
    
    BSVKHttpClient * realClient = [BSVKHttpClient shareInstance];
    
    NSLog(@"上传值%@",[bankDic allValues]);
    
    realClient.delegate = self;
    
    [realClient postInfo:@"app/appserver/crm/cust/fCiCustRealThreeInfo" requestArgument:bankDic requestTag:fCiCustRealThreeInfo requestClass:NSStringFromClass([self class])];
}


//获取验证码
-(void)buildGetCodeHttp{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    if (_phoneTextField.text.length > 0 && _phoneTextField) {
        
        [parm setObject:[EnterAES simpleEncrypt:_phoneTextField.text] forKey:@"phone"];
        
    }
    
    BSVKHttpClient * verClient = [BSVKHttpClient shareInstance];
    
    verClient.delegate = self;
    //   发送短信验证码
    [verClient getInfo:@"app/appserver/smsSendVerify" requestArgument:parm requestTag:GetCode requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}

//获取银行卡类型请求
- (void)buildGetCardType{
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/crm/cust/getBankInfo" requestArgument:@{@"cardNo":_cardTextField.text} requestTag:getBankInfo requestClass:NSStringFromClass([self class])];
}

#pragma mark --> 网络代理协议

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == GetCode) {
            
             [MBProgressHUD hideHUDForView:self.view animated:YES];
         
            WriteVerModel *model = [WriteVerModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleGetCode:model];

            
        }else if (requestTag == getBankInfo){
            
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            BankIardInformation *model = [BankIardInformation mj_objectWithKeyValues:responseObject];
            
            [self buildHandleCardType:model];
            
        }else if (requestTag == fCiCustRealThreeInfo){
            
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            ReservedModel *model = [ReservedModel mj_objectWithKeyValues:responseObject];
            
            [self analysisReservedModel:model];
            
        }else if (requestTag == getCustIsPassTwo){
           
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            WhiteSearchModel *model = [WhiteSearchModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSearchTwoModel:model];
            
        }else if (requestTag == getCustISExistsInvitedCauseTagTwo){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            InvitationModel *invitationModel = [InvitationModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleInvitationModel:invitationModel];
            
        }else if (requestTag == updateCardPostive){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
            
            [self analySisCardPositivePostSuccessModel:model];
            
        }else if (requestTag == updateCardTheOther){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            PostSuccessModel *model = [PostSuccessModel mj_objectWithKeyValues:responseObject];
            
            [self analySisCardTheOtherPostSuccessModel:model];
            
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

#pragma mark --> 网络请求成功后的处理逻辑

- (void)analySisCardPositivePostSuccessModel:(PostSuccessModel *)model{
    
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        
        _fromUpdateCardPostive = NO;
        
        [self updateCardTheOther];
        
    }else{
        
        _fromUpdateCardPostive = YES;
        
        [self buildHeadError:model.head.retMsg];
        
    }
}
- (void)analySisCardTheOtherPostSuccessModel:(PostSuccessModel *)model{
    
    if ([model.head.retFlag isEqualToString:SucessCode]) {
        
        [[AppDelegate delegate].imagePutCache removeAllObjects];
        
        _fromUpdateCardPostive = NO;
        
        _fromUpdateCardTheOther = NO;
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
            
            [_delegate sendSaveInfoViewType:CheckBankType];
            
        }

        
    }else{
        
        _fromUpdateCardPostive = NO;
        
        _fromUpdateCardTheOther = YES;
        
        [self buildHeadError:model.head.retMsg];
        
    }
}


// 处理请求邀请原因
-(void)buildHandleInvitationModel:(InvitationModel *)invitationModel{
    
    if ([invitationModel.head.retFlag isEqualToString:@"00000"]) {
        // 有邀请原因   走下去
        if ([invitationModel.body.isExits isEqualToString:@"Y"]) {
            
            if ([_seachModel.body.isPass isEqualToString:@"1"]) {
                
                [AppDelegate delegate].userInfo.whiteType = WhiteCReason;
            }else{
                
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityReason;
            }
            
            [self updateCardPostive];
            
        }else{
            if ([_seachModel.body.isPass isEqualToString:@"1"]) {
                
                [AppDelegate delegate].userInfo.whiteType = WhiteCNoReason;
            }else{
                
                [AppDelegate delegate].userInfo.whiteType = WhiteSocityNoReason;
            }
            [self updateCardPostive];
        }
    }else{
        [self buildHeadError:invitationModel.head.retMsg];
    }
    
    
}
//处理白名单请求
-(void)buildHandleSearchTwoModel:(WhiteSearchModel *)allowModel{
    
    if ([allowModel.head.retFlag isEqualToString:@"00000"]){
        
        _seachModel = allowModel;
        //社会化顾客
        if ([allowModel.body.isPass isEqualToString:SocietyUser]){
            
            [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            
            [self searchTwoSocialReason];
            
        }else if ([allowModel.body.isPass isEqualToString:@"1"]){
            //优质白名单  海尔、电信员工
            if ([allowModel.body.level isEqualToString:Auser]){
                
                [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
                
                [AppDelegate delegate].userInfo.whiteType = WhiteA;
                
                [self updateCardPostive];
            }
            //其他白名单
            else if ([allowModel.body.level isEqualToString:Buser]){
                
                [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
                
                [AppDelegate delegate].userInfo.whiteType = WhiteB;
                [self updateCardPostive];
                
            }else if ([allowModel.body.level isEqualToString:Cuser]){
                [AppDelegate delegate].userInfo.haierVipState = IsHaierVip;
 
                [self searchTwoSocialReason];
                
            }
        }else if ([allowModel.body.isPass isEqualToString:@"-1"]){
            [AppDelegate delegate].userInfo.haierVipState = NoHaierVip;
            [self buildHeadError:@"此账号无贷款权限，详情请拨打4000187777"];
        }
        
    }else{
        [self buildHeadError:allowModel.head.retMsg];
    }
    
    
}


//解析实名认证
- (void)analysisReservedModel:(ReservedModel *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"]){
        
        [[AppDelegate delegate].userInfo initRealNameInfo:model.body];
        
        [AppDelegate delegate].userInfo.userTel = _phoneTextField.text;
        
        _fromUpdateCardPostive = YES;
        
        [self buildSearchTwoWhiteType];
#pragma mark -->暂时注释
        //调用百融 登录
//        [StartBrAgent startBrAgentLogin];
//        //调用百融 注册
//        [StartBrAgent startBrAgentregister];
        
    }else{
        [self buildHeadError:model.head.retMsg];
    }
}

//处理银行卡类别
-(void)buildHandleCardType:(BankIardInformation *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        _cardTypeLabel.text = [NSString stringWithFormat:@"%@ %@",model.body.bankName,model.body.cardType];
        
    }else if ([model.head.retFlag isEqualToString:@"C1203"]){
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"系统暂不支持您认证的银行卡" cancelButtonTitle:@"查看支持银行" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex){
            STRONGSELF
            if (strongSelf){
                if (buttonIndex == 0){
                    
                    strongSelf.cardTextField.text = @"";
                    
                    [strongSelf buildToSuppotBank:nil];
                }
            }
        }];
        
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




@end
