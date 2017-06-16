//
//  HCCardSideViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCCardSideViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
#import "DefineSystemTool.h"
#import "BSVKHttpClient.h"
#import "UserSettingModel.h"
#import <MBProgressHUD.h>
#import "NSString+CheckConvert.h"
#import "SCCaptureCameraController.h"
static CGFloat const saveCardMsg = 110;//保存身份证信息
@interface HCCardSideViewController ()<SCNavigationControllerDelegate,BSVKHttpClientDelegate>

{
    
    float x;
    
}

@property(nonatomic,strong)UIImageView *topImgView;//顶部照片视图

@end

@implementation HCCardSideViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatTopImageView];
    
    [self creatBaseUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> life Cycle

//创建顶部照片视图
-(void)creatTopImageView{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
        
    }
    
    _topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(70*x, 127*x, DeviceWidth-140*x, 143*x)];
    
    _topImgView.image = [UIImage imageNamed:@"身份证反面"];
    
    _topImgView.userInteractionEnabled = YES;
    
    [self.view addSubview:_topImgView];
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buildTouchTopImage:)];
    
    [_topImgView addGestureRecognizer:gest];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 97*x, DeviceWidth, 10*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:lineView];
    
    
}

//创建基本视图
-(void)creatBaseUI{
    
    NSArray *array = @[@"发证机关",@"有效时期"];
    
    float  height = _topImgView.frame.origin.y+_topImgView.frame.size.height+25*x;
    
    for (int i =0; i<array.count; i++) {
        
        //左侧标题
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15*x, (height+15*x)+50*i*x, 100*x, 20*x)];
        
        leftLabel.text = array[i];
        
        leftLabel.tag = 10+i;
        
        leftLabel.font = [UIFont appFontRegularOfSize:14*x];
        
        [self.view addSubview:leftLabel];
        
        //右侧信息
        UILabel *rightLabel = [[UILabel alloc]init];
        
        rightLabel.textColor = UIColorFromRGB(0x999999, 1.0);
        
        rightLabel.font = [UIFont appFontRegularOfSize:14*x];
        
        rightLabel.tag = 20+i;
        
        rightLabel.textAlignment = NSTextAlignmentRight;

        [self.view addSubview:rightLabel];
        
        
        rightLabel.frame = CGRectMake(125*x, (height+15*x)+50*i, DeviceWidth-158*x, 20*x);
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-30*x, (17.5*x+height)+50*i, 9*x, 15*x)];
        
        imgView.backgroundColor = [UIColor clearColor];
        
        imgView.image = [UIImage imageNamed:@"首页_箭头右"];

        [self.view addSubview:imgView];
        
        //下划线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15*x, (49*x+height)+50*i*x, DeviceWidth-30*x, 1*x)];
        
        line.backgroundColor = UIColorFromRGB(0xdddddd, 1.0);
        
        line.tag = 30+i;
        
        [self.view addSubview:line];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15*x, height+50*i*x, DeviceWidth, 50*x)];
        
        button.backgroundColor = [UIColor clearColor];
        
        [button addTarget:self action:@selector(buildTouchTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        
    }
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(47*x, height+140*x, DeviceWidth-94*x, 50*x)];
    
    nextButton.layer.cornerRadius = 25*x;
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    [nextButton addTarget:self action:@selector(buildToNextView:) forControlEvents:UIControlEventTouchUpInside];
    
    nextButton.titleLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    nextButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [self.view addSubview:nextButton];
    
}

#pragma mark --> event Methods

//点击顶部照片视图
-(void)buildTouchTopImage:(UITapGestureRecognizer *)gest{
    
    if ([DefineSystemTool isGetCameraPermission]) {
        
        SCCaptureCameraController *con = [[SCCaptureCameraController alloc] init];
        con.scNaigationDelegate = self;
        con.iCardType = TIDCARD2;
        con.isDisPlayTxt = YES;
        [self presentViewController:con animated:YES completion:NULL];
        
        
    }else{
        
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"你还未开启相机权限，请前往设置中心开启" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 1) {
                    
                    [strongSelf toCamera];
                }
            }
        }];
    }
    
    
    
    
}

- (void)toCamera{
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (sysVer >= 10.0) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
        }
        
    }else{
        
        NSURL *url = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
        
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            
            [[UIApplication sharedApplication]openURL:url];
            
        }
        
    }
    
}

// 获取身份证反面信息
- (void)sendIDCBackValue:(NSString *)issue PERIOD:(NSString *) period
{
    NSLog(@"idcback  = %@\n%@\n",issue,period);
    
    UILabel *_officeLabel = (UILabel *)[self.view viewWithTag:20];
    
    _officeLabel.text = [issue deleteSpeaceString];
    
    UILabel *_validityPeriodLabel = (UILabel *)[self.view viewWithTag:21];
    
    _validityPeriodLabel.text = [period deleteSpeaceString];
    
    if (_officeLabel.text.length > 0) {
        
        [_cardDictionary setObject:_officeLabel.text forKey:@"发证机关"];
    }
    
    if (_validityPeriodLabel.text.length >= 10) {
        
        [_cardDictionary setObject:[_validityPeriodLabel.text buildReplaceCertStartDt] forKey:@"有效开始期限"];
        
    }
    
    if (_validityPeriodLabel.text.length > 11) {
        
        [_cardDictionary setObject:[_validityPeriodLabel.text buildReplaceCertEndDt] forKey:@"有效结束期限"];
    }
    
}
//获取拍照的图片
- (void)sendTakeImage:(TCARD_TYPE) iCardType image:(UIImage *)cardImage
{
    if (cardImage) {
        
        NSData *data = UIImageJPEGRepresentation(cardImage, ImageUpZScale);
        
        if (data && data.length > 0) {
            
            [[AppDelegate delegate].imagePutCache setObject:data forKey:@"身份证反面"];
            
            _topImgView.image = cardImage;
            
        }else{
            
            [self buildHeadError:@"证件识别错误，请重新识别"];
        }
    }else{
        
        [self buildHeadError:@"证件识别错误，请重新识别"];
    }
}
//点击下一步方法
-(void)buildToNextView:(UIButton *)sender{
    
    UILabel *labelOne = (UILabel *)[self.view viewWithTag:20];
    
    UILabel *labelTwo = (UILabel *)[self.view viewWithTag:21];
    
    if (labelOne.text.length == 0 || labelTwo.text.length == 0) {
        
        [self buildHeadError:@"请使用扫描功能上传身份证信息"];
        
    }else{
        
        [self querySaveCardMsg];
        
    }
    
   
    
}

#pragma mark --> 发起网路请求

-(void)querySaveCardMsg{
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if ([[_cardDictionary objectForKey:@"最后家庭地址"]isEqualToString:[_cardDictionary objectForKey:@"家庭地址"]]) {
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"家庭地址"]) forKey:@"regAddr"];
    }else{
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"最后家庭地址"]) forKey:@"afterRegAddr"];
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"家庭地址"]) forKey:@"regAddr"];
    }
    if ([[_cardDictionary objectForKey:@"最后性别"]isEqualToString:[_cardDictionary objectForKey:@"性别"]]) {
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"性别"]) forKey:@"gender"];
    }else{
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"性别"]) forKey:@"gender"];
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"最后性别"]) forKey:@"afterGender"];
    }
    if ([[_cardDictionary objectForKey:@"出生年月"]isEqualToString:[_cardDictionary objectForKey:@"最后出生年月"]]) {
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"出生年月"]) forKey:@"birthDt"];
    }else{
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"出生年月"]) forKey:@"birthDt"];
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"最后出生年月"]) forKey:@"afterBirthDt"];
    }
    if ([[_cardDictionary objectForKey:@"最后身份号码"]isEqualToString:[_cardDictionary objectForKey:@"身份号码"]]) {
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"身份号码"]) forKey:@"certNo"];
    }else{
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"身份号码"]) forKey:@"certNo"];
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"最后身份号码"]) forKey:@"afterCertNo"];
    }
    if ([[_cardDictionary objectForKey:@"最后姓名"]isEqualToString:[_cardDictionary objectForKey:@"姓名"]]) {
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"姓名"]) forKey:@"custName"];
    }else{
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"姓名"]) forKey:@"custName"];
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"最后姓名"]) forKey:@"afterCustName"];
    }
    if ([[_cardDictionary objectForKey:@"最后有效开始期限"]isEqualToString:[_cardDictionary objectForKey:@"有效开始期限"]]) {
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"有效开始期限"]) forKey:@"certStrDt"];
    }else{
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"有效开始期限"]) forKey:@"certStrDt"];
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"最后有效开始期限"]) forKey:@"afterCertStrDt"];
    }
    if ([[_cardDictionary objectForKey:@"最后有效结束期限"]isEqualToString:[_cardDictionary objectForKey:@"有效结束期限"]]) {
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"有效结束期限"]) forKey:@"certEndDt"];
    }else{
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"有效结束期限"]) forKey:@"certEndDt"];
        
    }
    if ([[_cardDictionary objectForKey:@"最后发证机关"]isEqualToString:[_cardDictionary objectForKey:@"发证机关"]]) {
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"发证机关"]) forKey:@"certOrga"];
    }else{
        
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"最后发证机关"]) forKey:@"afterCertOrga"];
        [parm setObject:StringOrNull([_cardDictionary objectForKey:@"发证机关"]) forKey:@"certOrga"];
    }
    
    [parm setObject:StringOrNull([_cardDictionary objectForKey:@"民族"]) forKey:@"ethnic"];
    
    [client postInfo:@"app/appserver/saveCardMsg" requestArgument:parm requestTag:saveCardMsg requestClass:NSStringFromClass([self class])];
    
}

#pragma mark --> 网络代理协议


-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == saveCardMsg) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            UserSettingModel *model = [UserSettingModel mj_objectWithKeyValues:responseObject];
            
            [self analySisUserSettingModel:model];
        }
    }
}

- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(httpCode != 0){
            [self buildHeadError:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试((long)%ld)",httpCode]];
        }else{
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

#pragma mark - Model 解析
-(void)analySisUserSettingModel:(UserSettingModel *)model{
    
    if ([model.head.retFlag isEqualToString:SucessCode]) {
                
        if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
            
            [self.delegate sendSaveInfoViewType:CardTheOtherType];
            
        }
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
    }
}


@end
