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
#import <MBProgressHUD.h>
#import "BSVKHttpClient.h"
#import "AppDelegate.h"
#import "WriteVerModel.h"
#import "UILabel+SizeForStr.h"
#import "EnterAES.h"
#import "BankIardInformation.h"
static CGFloat const GetCode = 110;//获取验证码
static CGFloat const getBankInfo = 120;//获取银行卡类型
@interface HCCheckBankViewController ()<BSVKHttpClientDelegate,UITextFieldDelegate>

{
    
    float x;//屏幕适配比例
    
    NSInteger _time;
    
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


@end

@implementation HCCheckBankViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
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
    UILabel *nameLabel = [self creatTemplateLabelFrame:CGRectMake(125*x, 15*x+height, DeviceWidth-166*x, 20*x) text:[AppDelegate delegate].userInfo.realName textColor:UIColorFromRGB(0x999999, 1.0)];
    
    nameLabel.textAlignment = NSTextAlignmentRight;
    
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

#pragma mark --> event Methods
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
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
            
            [_delegate sendSaveInfoViewType:CheckBankType];
            
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
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (requestTag == GetCode) {
         
            WriteVerModel *model = [WriteVerModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleGetCode:model];

            
        }else if (requestTag == getBankInfo){
            
            BankIardInformation *model = [BankIardInformation mj_objectWithKeyValues:responseObject];
            
            [self buildHandleCardType:model];
            
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
