//
//  RegCodeViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "RegCodeViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "AppDelegate.h"
#import "RMUniversalAlert.h"
#import "BSVKHttpClient.h"
#import "EnterAES.h"
#import "WriteVerModel.h"
#import <MBProgressHUD.h>
#import "CheckCodeHeadModel.h"
static CGFloat const GetCode = 110;//获取验证码
static CGFloat const JudgeCode = 120;//校验验证码
@interface RegCodeViewController ()<BSVKHttpClientDelegate,UITextFieldDelegate>
{
    
    float x;
    
    UIView *buttonView;
    
}

@property(nonatomic,strong)UITextField *codeText;//验证码输入框

@property(nonatomic,strong)UIButton *timeButton;//时间按钮

@property(nonatomic,strong)UILabel *timeLabel;//时间显示

@property(nonatomic,assign)NSInteger time;//时间

@property(nonatomic,strong)NSTimer *timer;//时间定时器

@end

@implementation RegCodeViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatBaseUI];
    
    [self buildGetCodeHttp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setIfJudgeAgainSend:(BOOL)ifJudgeAgainSend{
    
    _ifJudgeAgainSend = ifJudgeAgainSend;
    
    if (_ifJudgeAgainSend) {
        
        [_timer invalidate];
        
        _timer = nil;
        
        _timeLabel.text = @"重新发送";
        
        buttonView.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
        
        _timeButton.userInteractionEnabled = YES;
        
        [self buildGetCodeHttp];
        
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
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 97*x, DeviceWidth, 10*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self.view addSubview:lineView];
    
     height = 97*x;
    
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
    
    _codeText.returnKeyType = UIReturnKeyDone;
    
    _codeText.delegate = self;
    
    _codeText.textColor = UIColorFromRGB(0x999999, 1.0);
    
    _codeText.backgroundColor = [UIColor clearColor];
    
    [numberView addSubview:_codeText];
    
     /*----------------------验证码按钮-----------------------*/
    
    buttonView = [[UIView alloc]init];
    
    buttonView.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [self.view addSubview:buttonView];
    
    _timeLabel = [[UILabel alloc]init];
    
    _timeLabel.text = @"重新发送";
    
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    
    _timeLabel.textColor = UIColorFromRGB(0x999999, 1.0);;
    
    _timeLabel.backgroundColor = [UIColor clearColor];
    
    _timeLabel.textColor = [UIColor whiteColor];
    
    [buttonView addSubview:_timeLabel];
    
    _timeButton = [[UIButton alloc]init];
    
    _timeButton.backgroundColor = [UIColor clearColor];
    
    [_timeButton addTarget:self action:@selector(buildTouchAgainPost:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonView addSubview:_timeButton];
    
    UIButton *nextButton = [[UIButton alloc]init];
    
    if (iphone6P) {
       
        numberView.frame = CGRectMake(46*x, 57*x+height, 194*x, 50*x);
        
        nextButton.frame = CGRectMake(46*x, 20+numberView.frame.origin.y+numberView.frame.size.height, DeviceWidth-92*x, 50*x);
        
        leftImg.frame = CGRectMake(25*x, 17*x, 16*x, 16*x);
        
        _codeText.frame = CGRectMake(53*x, 15*x, 141, 20*x);
        
        buttonView.frame = CGRectMake(numberView.frame.origin.x+numberView.frame.size.width+9*x, numberView.frame.origin.y, 114*x, 50*x);
        
        buttonView.layer.cornerRadius = 25*x;
        
        _codeText.font = [UIFont appFontRegularOfSize:14*x];
        
        _timeLabel.font = [UIFont appFontRegularOfSize:14*x];
        
        _timeLabel.frame = CGRectMake(0, 15*x, 114*x, 20*x);
        
        _timeButton.frame = CGRectMake(0, 0, 114*x, 50*x);
        
        nextButton.layer.cornerRadius = 25*x;
        
        numberView.layer.cornerRadius = 25*x;
        
    }else{
        
        numberView.frame = CGRectMake(42*x, 52*x+height, 175*x, 45*x);
        
        nextButton.frame = CGRectMake(42*x, 18+numberView.frame.origin.y+numberView.frame.size.height, DeviceWidth-84*x, 45*x);
        
        leftImg.frame = CGRectMake(22*x, 14.5*x, 16*x, 16*x);
        
        _codeText.frame = CGRectMake(49*x, 12.5*x, 126*x, 20*x);
        
        buttonView.frame = CGRectMake(numberView.frame.origin.x+numberView.frame.size.width+7*x, numberView.frame.origin.y, 104*x, 45*x);
        
        buttonView.layer.cornerRadius = 22.5*x;
        
        _codeText.font = [UIFont appFontRegularOfSize:12*x];
        
        _timeLabel.frame = CGRectMake(0, 12.5*x, 104*x, 20*x);
        
        _timeButton.frame = CGRectMake(0, 0, 104*x, 45*x);
        
        _timeLabel.font = [UIFont appFontRegularOfSize:12*x];
        
        nextButton.layer.cornerRadius = 22.5*x;
        
        numberView.layer.cornerRadius = 22.5*x;
        
    }
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    nextButton.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    nextButton.titleLabel.font = [UIFont appFontRegularOfSize:14];
    
    [nextButton addTarget:self action:@selector(buildToNextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextButton];
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
//点击下一步方法
-(void)buildToNextAction:(UIButton *)sender{
    
    
    [_codeText resignFirstResponder];
    
    if (_codeText.text.length == 0) {
        
        [self buildHeadError:@"请输入验证码"];
        
    }else{
        
        [self buildjudgeCodeHttp];
    }
    
}
//点击重新发送
-(void)buildTouchAgainPost:(UIButton *)sender{
    
    [self buildGetCodeHttp];
    
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

//校验验证码
-(void)buildHandleJudgeCode:(CheckCodeHeadModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        self.verifyNo = _codeText.text;
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendSaveInfoViewType:)]) {
            
            [_delegate sendSaveInfoViewType:VerificationType];
            
        }
        
    }else{
      
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

//发送验证码
-(void)buildHandleGetCode:(WriteVerModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        _number = [AppDelegate delegate].userInfo.userId;
        
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
