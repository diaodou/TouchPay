//
//  HCPayCodeViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/8.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCPayCodeViewController.h"
#import "UIFont+AppFont.h"
#import "NSString+CheckConvert.h"
#import "HCMacro.h"
#import "BSVKHttpClient.h"
#import <MBProgressHUD.h>
#import "RMUniversalAlert.h"
#import "EnterAES.h"
#import "CheckCodeHeadModel.h"
#import "WriteVerModel.h"
#import "UIColor+DefineNew.h"
#import "PutPayModel.h"
#import "AppDelegate.h"
#import "UpdateRiskInfoModel.h"
#import "ContractShowViewController.h"
#import "ContractConfirmModel.h"
#import "UIButton+LazyButton.h"
#import "OrderCommitModel.h"
static CGFloat const GetCode = 110;//获取验证码
static CGFloat const JudgeCode = 120;//校验验证码
static CGFloat const setPayPassword = 130;//设置支付密码
static CGFloat const getEdApplInfo = 140;//额度激活
static CGFloat const updateOrderAgreement = 150;//确认协议
static CGFloat const updateOrderContract = 160;//确认合同
static CGFloat const commitAppOrder = 170;//确认合同
@interface HCPayCodeViewController ()<BSVKHttpClientDelegate,UITableViewDelegate,UITableViewDataSource>

{
    
    UIView *buttonView;
    
    float x;//屏幕适配比例
    
    NSInteger numberStr;
    
    BOOL _haveCommit;//已提交
    
}
@property(nonatomic,strong)UITextField *codeText;//验证码输入框

@property(nonatomic,strong)UIButton *timeButton;//时间按钮

@property(nonatomic,strong)UILabel *timeLabel;//时间显示

@property(nonatomic,assign)NSInteger time;//时间

@property(nonatomic,strong)NSTimer *timer;//时间定时器

@property(nonatomic,strong)UIButton *agreeButton;//同意协议按钮

@property(nonatomic,strong)UITableView *showTableView;//协议展示table

@property(nonatomic,copy)NSArray *nameArray;//协议名称数组

@property(nonatomic,strong)UIView *lightView;

@property(nonatomic,strong)UIButton *nextButton;//下一步

@end

@implementation HCPayCodeViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [AppDelegate delegate].userInfo.userTel = @"18315919301";
    
    [self creatBaseUI];
    
    [self buildGetCodeHttp];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)lightView{
    
    if (!_lightView) {
        
        _lightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64)];
        
       _lightView.backgroundColor = [UIColor UIColorWithHexColorString:@"0x7f7f7f" AndAlpha:0.8];

        
        [self.view addSubview:_lightView];
        
    }
    
    return _lightView;
    
}

-(UITableView *)showTableView{
    
    if (!_showTableView) {
        
        NSInteger number;
        
        if ([AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned) {
            
            _nameArray = @[@[@"个人征信查询授权书"],@[@"取消"]];
            
            number = 2;
            
        }else {
            
             _nameArray = @[@[@"注册协议",@"个人征信查询授权书",@"借款合同"],@[@"取消"]];
            
            number = 4;
            
        }
        
        _showTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, DeviceHeight-64-15*x-(number * 50*x), DeviceWidth, 15*x+(number* 50*x))];
        
        _showTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        
        _showTableView.delegate = self;
        
        _showTableView.dataSource = self;
        
        _showTableView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
        
        _showTableView.showsVerticalScrollIndicator = NO;
        
        _showTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:_showTableView];
        
        
    }
    
    return _showTableView;
    
}

#pragma mark --> private Methods

//创建基本视图
-(void)creatBaseUI{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
        
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 97*x, DeviceWidth, 10*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:lineView];
    
    UILabel *warnLab = [[UILabel alloc]init];
    
    warnLab.textColor = UIColorFromRGB(0x666666, 1.0);
    
    warnLab.font = [UIFont appFontRegularOfSize:13];
    
    warnLab.text = [NSString stringWithFormat:@"请输入手机%@收到的短信校验码",[[AppDelegate delegate].userInfo.userTel hiddenCenterNum]];
    
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
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:@"我同意海尔消费金融相关协议"];
    
    [attr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x32beff, 1.0)} range:NSMakeRange(3, 10)];
    
    optionLabel.attributedText = attr;
    
    UIButton *aggreeBtn = [[UIButton alloc]init];
    
    [aggreeBtn addTarget:self action:@selector(buildTouchLook:) forControlEvents:UIControlEventTouchUpInside];
    
    aggreeBtn.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:aggreeBtn];
    
    [self.view addSubview:optionLabel];
    
    //下一步按钮
    
    _nextButton = [[UIButton alloc]init];
    
    _nextButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    _nextButton.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    [_nextButton addTarget:self action:@selector(buildToNextView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_nextButton];
    
    
    if (iphone6P) {
        
        warnLab.frame = CGRectMake(60*x, 132*x, DeviceWidth-60*x, 20*x);
        
        numberView.frame = CGRectMake(47*x, 164*x, 193*x, 50*x);
        
        numberView.layer.cornerRadius = 25*x;
        
        leftImg.frame = CGRectMake(25*x, 17*x, 16*x, 16*x);
        
        _codeText.frame = CGRectMake(53*x, 15*x, 141*x, 20*x);

        
        buttonView.frame = CGRectMake(250*x, 164*x, 115*x, 50*x);
        
        buttonView.layer.cornerRadius  = 25*x;
        
        _timeLabel.frame = CGRectMake(0, 15*x, 115*x, 20*x);
        
        _timeButton.frame = CGRectMake(0, 0, 115*x, 50*x);
        
        _agreeButton.frame = CGRectMake(60*x, 232*x, 12*x, 12*x);
        
        optionLabel.frame = CGRectMake(83*x, 232*x, DeviceWidth-83*x, 15*x);
        
        aggreeBtn.frame = CGRectMake(100*x, 225*x, 160*x, 30*x);
        
        _nextButton.frame = CGRectMake(47*x, 284*x, DeviceWidth-94*x, 50*x);
        
        _nextButton.layer.cornerRadius = 25*x;
        
    }else{
        
        warnLab.frame = CGRectMake(56*x, 143*x, DeviceWidth-56*x, 20*x);
        
        numberView.frame = CGRectMake(42*x, 170*x, 176*x, 46*x);
        
        numberView.layer.cornerRadius = 23*x;
        
        leftImg.frame = CGRectMake(25*x, 15*x, 16*x, 16*x);
        
        _codeText.frame = CGRectMake(53*x, 13*x, 123*x, 20*x);
        
        buttonView.frame = CGRectMake(225*x, 170*x, 105*x, 46*x);
        
        buttonView.layer.cornerRadius  = 23*x;
        
        _timeLabel.frame = CGRectMake(0, 15*x, 105*x, 20*x);
        
        _timeButton.frame = CGRectMake(0, 0, 105*x, 46*x);
        
        _agreeButton.frame = CGRectMake(58*x, 230*x, 12*x, 12*x);
        
        optionLabel.frame = CGRectMake(85*x, 230*x, DeviceWidth-85*x, 15*x);
        
        aggreeBtn.frame = CGRectMake(100*x, 223*x, 160*x, 30*x);
        
        _nextButton.frame = CGRectMake(42*x, 267*x, DeviceWidth-84*x, 46*x);
        
        _nextButton.layer.cornerRadius = 23*x;
  
        
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

//点击下一步
-(void)buildToNextView:(UIButton *)sender{
    
    if (_codeText.text.length == 0) {
        
        [self buildHeadError:@"请输入验证码"];
        
    }else if (!_agreeButton.selected){
        
        [self buildHeadError:@"请先阅读海尔消费金融相关协议并同意"];
        
    }else{
        
        if (_haveCommit) {
           
            WEAKSELF
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"您已提交申请成功" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                STRONGSELF
                if (strongSelf) {
                    
                    if (buttonIndex == 0) {
                        
                        [strongSelf.delegate sendSaveInfoViewType:PasswordVericationType];
                    }
                }
            }];

            
        }else{
            
            _nextButton.bIgnoreEvent = NO;
            
            _nextButton.lazyEventInterval = 2;
            
            if([AppDelegate delegate].mapLocation.locationStatus == LocationNoAuthority) {
                
                [self buildWhiteType];
                
            }else if ([self buildPosition]){
                
                [self createShowPosition];
                
            }else{
                
                [self buildjudgeCodeHttp];
                
            }

            
        }
        
    }
    
}

//获取验证码
-(void)buildTouchAgainPost:(UIButton *)sender{
    
    [self buildGetCodeHttp];
    
}

//查看协议
-(void)buildTouchLook:(UIButton *)sender{
    
    self.lightView.hidden = NO;
    
    self.showTableView.hidden = NO;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendViewShow:)]) {
        
        [_delegate sendViewShow:YES];
        
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

-(void)buildAgree:(UIButton *)sender{
    
    sender.selected = !sender.selected;
    
    if (sender.selected ) {
        
        [sender setImage:[UIImage imageNamed:@"gouxuan无框"] forState:UIControlStateNormal];
        
    }else{
        
        [sender setImage:[UIImage imageNamed:@"我同意"] forState:UIControlStateNormal];
    }
    
}

-(void)createShowPosition{
    WEAKSELF
    
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"定位失败,请检查网络或定位服务后重试!" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        
        STRONGSELF
        
        if (strongSelf)
        {
            
            if(buttonIndex == 0)
            {
                
                [_nextButton setBackgroundColor:UIColorFromRGB(0x028ce5, 1.0)];
                [[AppDelegate delegate].mapLocation openLocationService];
            }else{
                
                [_nextButton setBackgroundColor:UIColorFromRGB(0x028ce5, 1.0)];
            }
        }
    }];
}
//地理位置是否需要从新获取
-(BOOL)buildPosition{
    if ([AppDelegate delegate].mapLocation.strProvinceCode.length>0 && [AppDelegate delegate].mapLocation.strProvince.length>0 && [AppDelegate delegate].mapLocation.myCoordinate2D.latitude && [AppDelegate delegate].mapLocation.myCoordinate2D.longitude){
        return NO;
    }else{
        return YES;
    }
}
//判断是否需要定位
-(void)buildWhiteType{
    
    //提示没有权限
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"当前无法确认您的位置，请开启定位服务" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 1)
            {

                //去设置页面
                [strongSelf toSetLocation];
            }
        }
    }];
}
//设置定位
- (void)toSetLocation
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark --> table代理协议

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _nameArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = _nameArray[section];
    
    return array.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jack"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jack"];
        
        cell.contentView.backgroundColor = [UIColor whiteColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50*x)];
        
        label.tag = 10;
        
        label.font = [UIFont appFontRegularOfSize:15*x];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [cell.contentView addSubview:label];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5*x, DeviceWidth, 0.5*x)];
        
        line.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
        
        [cell.contentView addSubview:line];
        
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    
    NSArray *array = _nameArray[indexPath.section];
    
    label.text = array[indexPath.row];
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50*x;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 15*x;
        
    }else{
        
        return 0.000000009;
        
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.showTableView.hidden = YES;
    
    self.lightView.hidden = YES;
    
    if (_delegate && [_delegate respondsToSelector:@selector(sendViewShow:)]) {
    
        [_delegate sendViewShow:NO];
        
    }
    
    if (indexPath.section == 0) {
        
        NSArray *array = _nameArray[indexPath.section];
        
        [self buildHandleToShow:array[indexPath.row]];
        
    }
    
}

-(void)buildHandleToShow:(NSString *)string{
    
    ContractShowViewController *conVc = [[ContractShowViewController alloc]init];
    
//    if ([string isEqualToString:@"个人"]) {
//        <#statements#>
//    }
    
}

#pragma mark --> 网络请求

//征信协议
-(void)creditProtocol
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client postInfo:@"app/appserver/apporder/updateOrderAgreement" requestArgument:@{@"orderNo":[AppDelegate delegate].userInfo.orderNo,@"msgCode":StringOrNull(_codeText.text),@"type":@"3"} requestTag:updateOrderAgreement requestClass:NSStringFromClass([self class])];
}

// 风险采集
- (void)MKLupdateRiskInfo
{
    NSMutableDictionary * allDic = [[NSMutableDictionary alloc]init];
    NSMutableArray *allArray=[[NSMutableArray alloc]init];
    numberStr ++;
    //A502
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realId] forKey:@"idNo"];
    [dic setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realTel] forKey:@"mobile"];
    [dic setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realName] forKey:@"name"];
    [dic setObject:@"A502" forKey:@"dataTyp"];
    [dic setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"reserved6"];
    [dic setObject:@"2" forKey:@"source"];
    NSString * strCityCode = [NSString stringWithFormat:@"%@",[AppDelegate delegate].mapLocation.strCityCode];
    NSMutableArray *listArray = [[NSMutableArray alloc]init];
    [listArray addObject:strCityCode];
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSString *jack=[EnterAES simpleEncrypt:listArray[0]];
    [array addObject:jack];
    [dic setObject:array forKey:@"content"];
    if ([AppDelegate delegate].userInfo.applSeq.length > 0) {
        
        [dic setObject:[AppDelegate delegate].userInfo.applSeq forKey:@"applSeq"];
        
    }
    
    
    //A504
    NSMutableDictionary * dicOne = [[NSMutableDictionary alloc]init];
    [dicOne setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realId] forKey:@"idNo"];
    [dicOne setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realTel] forKey:@"mobile"];
    [dicOne setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realName] forKey:@"name"];
    [dicOne setObject:@"A504" forKey:@"dataTyp"];
    [dicOne setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"reserved6"];
    [dicOne setObject:@"2" forKey:@"source"];
    NSString * strCity = [NSString stringWithFormat:@"%@",[AppDelegate delegate].mapLocation.strCity];
    NSMutableArray *listArrayOne = [[NSMutableArray alloc]init];
    [listArrayOne addObject:strCity];
    NSMutableArray *arrayOne=[[NSMutableArray alloc]init];
    NSString *jackOne=[EnterAES simpleEncrypt:listArrayOne[0]];
    [arrayOne addObject:jackOne];
    [dicOne setObject:arrayOne forKey:@"content"];
    if ([AppDelegate delegate].userInfo.applSeq.length > 0) {
        
        [dic setObject:[AppDelegate delegate].userInfo.applSeq forKey:@"applSeq"];
        
    }
    
    //04
    NSMutableDictionary * dicTwo = [[NSMutableDictionary alloc]init];
    [dicTwo setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realId] forKey:@"idNo"];
    [dicTwo setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realTel] forKey:@"mobile"];
    [dicTwo setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.realName] forKey:@"name"];
    [dicTwo setObject:@"04" forKey:@"dataTyp"];
    [dicOne setObject:StringOrNull([AppDelegate delegate].userInfo.applSeq) forKey:@"reserved6"];
    [dicTwo setObject:@"2" forKey:@"source"];
    NSString * latitude = [NSString stringWithFormat:@"纬度%f",[AppDelegate delegate].mapLocation.myCoordinate2D.latitude];
    NSString * longitude = [NSString stringWithFormat:@"经度%f",[AppDelegate delegate].mapLocation.myCoordinate2D.longitude];
    NSString * encryStr = [NSString stringWithFormat:@"%@%@",longitude,latitude];
    NSMutableArray *listArrayTwo = [[NSMutableArray alloc]init];
    [listArrayTwo addObject:encryStr];
    NSMutableArray *arrayTwo=[[NSMutableArray alloc]init];
    NSString *jackTwo=[EnterAES simpleEncrypt:listArrayTwo[0]];
    [arrayTwo addObject:jackTwo];
    [dicTwo setObject:arrayTwo forKey:@"content"];
    if ([AppDelegate delegate].userInfo.applSeq.length > 0) {
        
        [dic setObject:[AppDelegate delegate].userInfo.applSeq forKey:@"applSeq"];
        
    }
    
    
    [allArray addObject:dic];
    [allArray addObject:dicOne];
    [allArray addObject:dicTwo];
    [allDic setObject:allArray forKey:@"list"];
    WEAKSELF
    [[BSVKHttpClient shareInstance]postInfo:@"app/appserver/updateListRiskInfo" requestArgument:allDic completion:^(id results, NSError *error) {
        STRONGSELF
        if (results) {
            UpdateRiskInfoModel *infoModel = [UpdateRiskInfoModel mj_objectWithKeyValues:results];
            
            if ([infoModel.response.head.retFlag isEqualToString:SucessCode]) {
                
                NSLog(@"MKL地理位置风险采集成功");
            }else{
                
                if (numberStr == 1) {
                    [strongSelf MKLupdateRiskInfo];
                }
            }
        }
    }];
}

//额度激活
- (void)getEdApplInfo {
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];

    
    [client getInfo:@"app/appserver/customer/getEdApplInfo" requestArgument:dic requestTag:getEdApplInfo requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//设置支付密码
- (void)setPassWord{
    
    NSString * userID = StringOrNull([AppDelegate delegate].userInfo.userId);
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance] putInfo:@"app/appserver/uauth/payPasswd" requestArgument:@{@"userId":[EnterAES simpleEncrypt:userID],@"payPasswd":[EnterAES simpleEncrypt:self.passWord]} requestTag:setPayPassword requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

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
    
    if ([AppDelegate delegate].userInfo.userTel.length > 0 && [AppDelegate delegate].userInfo.userTel) {
        
        [parm setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userTel] forKey:@"phone"];
        
    }
    
    BSVKHttpClient * verClient = [BSVKHttpClient shareInstance];
    
    verClient.delegate = self;
    //   发送短信验证码
    [verClient getInfo:@"app/appserver/smsSendVerify" requestArgument:parm requestTag:GetCode requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
}

//合同确认接口
-(void)contractSure
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * strOnLineUrl = [NSString stringWithFormat:@"app/appserver/apporder/updateOrderContract"];
    BSVKHttpClient *agreementConfirm = [BSVKHttpClient shareInstance];
    agreementConfirm.delegate = self;
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setObject:StringOrNull([AppDelegate delegate].userInfo.orderNo) forKey:@"orderNo"];
    //            合同确认
    [agreementConfirm  postInfo: strOnLineUrl requestArgument:parmDic requestTag:updateOrderContract requestClass:NSStringFromClass([self class])];
}

//订单提交
- (void)orderCommit{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    
    [parmDic setObject:[AppDelegate delegate].userInfo.orderNo forKey:@"orderNo"];
    
    if ([AppDelegate delegate].userInfo.busFlowName == CashLoanWait || [AppDelegate delegate].userInfo.busFlowName == CashLoanReturned || [AppDelegate delegate].userInfo.busFlowName == CashLoanCreate)
    {
        [parmDic setObject:@"1" forKey:@"opType"];// 现金贷
    }
    else
    {
        [parmDic setObject:@"2" forKey:@"opType"];//商品贷
    }
    

    [parmDic setObject:StringOrNull(_codeText.text) forKey:@"msgCode"];//验证码
    BSVKHttpClient *client = [[BSVKHttpClient alloc]init];
    client.delegate = self;
    
    [client getInfo:@"app/appserver/apporder/commitAppOrder" requestArgument:parmDic requestTag:commitAppOrder requestClass:NSStringFromClass([self class])];
    

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
            
        }else if (requestTag == setPayPassword){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            WriteVerModel *model = [WriteVerModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSetPass:model];
            
        }else if (requestTag == getEdApplInfo){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            PutPayModel *model = [PutPayModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleQuotto:model];
            
        }else if (requestTag == updateOrderAgreement){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
         
            ContractConfirmModel *model = [ContractConfirmModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleContract:model];
            
        }else if (requestTag == updateOrderContract){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
         
            ContractConfirmModel *model = [ContractConfirmModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleSure:model];
            
        }else if (requestTag == commitAppOrder){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            OrderCommitModel *model = [OrderCommitModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleOrderCommit:model];
            
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

#pragma mark -->网络请求成功后的逻辑处理

//订单提交成功后的逻辑
-(void)buildHandleOrderCommit:(OrderCommitModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        _haveCommit = YES;
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
            
            [_delegate sendSaveInfoViewType:VerificationType];
            
        }
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//合同确认
-(void)buildHandleSure:(ContractConfirmModel*)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {

        [self orderCommit];
        
#warning mark -->暂时注释以后恢复
        //百融风险采集
        //[StartBrAgent startBrAgentlend];
        
        numberStr = 0;
        [self MKLupdateRiskInfo];

        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//处理征信协议确认
-(void)buildHandleContract:(ContractConfirmModel*)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        //合同确认
        [self contractSure];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//处理额度激活
-(void)buildHandleQuotto:(PutPayModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        [AppDelegate delegate].userInfo.applSeq = model.body.applSeq;
        
        numberStr = 0;
        
        _haveCommit = YES;
        
        [self MKLupdateRiskInfo];
#warning mark --> 暂时注释以后恢复
        //百融风险采集
//        [StartBrAgent startBrAgentlend];
 
        if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
            
            [_delegate sendSaveInfoViewType:VerificationType];
            
        }
        
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//设置支付密码逻辑
-(void)buildHandleSetPass:(WriteVerModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if ([AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned) {
           
            [self getEdApplInfo];
            
        }else if ([AppDelegate delegate].userInfo.busFlowName == CashLoanWait || [AppDelegate delegate].userInfo.busFlowName == QuotaApply || [AppDelegate delegate].userInfo.busFlowName == QuotaReturned){
            
            [self creditProtocol];
            
        }else{
            
            if (_ifCommitOrder) {
               
                 [self creditProtocol];
                
            }else{
                
                if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
                    
                    [_delegate sendSaveInfoViewType:VerificationType];
                    
                }
                
            }
            
        }
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//校验验证码
-(void)buildHandleJudgeCode:(CheckCodeHeadModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
       
        
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
