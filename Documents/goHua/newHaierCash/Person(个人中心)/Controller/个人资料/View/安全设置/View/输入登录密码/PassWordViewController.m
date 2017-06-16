//
//  PassWordViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "PassWordViewController.h"
#import "NewNumberViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
#import "DefineSystemTool.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import "MBProgressHUD.h"
#import "SvUDIDTools.h"
#import "EnterAES.h"
#import "SignModel.h"
#import "UIButton+LazyButton.h"
#import "GestureViewController.h"
//#import "SettingStore.h"

@interface PassWordViewController ()<BSVKHttpClientDelegate>{
    
    
}
@property(nonatomic,strong)UIButton *nextBtn;
@property (nonatomic, strong) UIView *bjView;
@property (nonatomic, strong) UITextField * numTextField;
@end

@implementation PassWordViewController
#pragma mark -- lift cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title =@"输入登录密码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
}
//设置导航
- (void)setNavi {
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- setting and getting
-(void)creatView{
    [self setLineView];
    [self creatTextField];//输入框
    [self creatBtn];//按钮
}
- (void)setLineView{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self.view addSubview:lineView];
}
//输入框
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
    _numTextField.placeholder = @"输入登录密码，完成身份验证";
    _numTextField.font = [UIFont appFontRegularOfSize:13];
    _numTextField.keyboardType = UIKeyboardTypeDefault;
    
    _numTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [bjView addSubview:_numTextField];

}

// 按钮
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
#pragma Mark --  private Methods
-(void)ToNext{
    
    if (_numTextField.text.length == 0) {
        [self buildHeadError:@"请输入密码"];
    }else{
        
        [self validateUsers];
     }
}
- (void)toNewNumberViewController{
    NewNumberViewController *vc = [[NewNumberViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)toAppdelegate{

    GestureViewController *vc = [[GestureViewController alloc]init];
    
    HCRootNavController *rootNav = [[HCRootNavController alloc]initWithRootViewController:vc];
    
    vc.whereType = whereRoot;
    
    vc.type = GestureViewControllerTypeSetting;
    
    [self.navigationController presentViewController:rootNav animated:YES completion:nil];
}
#pragma mark - request Methods
- (void)validateUsers{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId] forKey:@"userId"];
    
    [dic setObject:[EnterAES simpleEncrypt:_numTextField.text] forKey:@"password"];
    [dic setObject:@"set" forKey:@"type"];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]putInfo:@"app/appserver/customerLogin" requestArgument:dic requestTag:10 requestClass:NSStringFromClass([self class])];
}
#pragma mark -- 键盘动作
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_numTextField resignFirstResponder];
}
#pragma mark -- BSVK delegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {

    if (requestTag == 10){
        
        SignModel *model = [SignModel mj_objectWithKeyValues:responseObject];
        
        [self analySisSignModel:model];
    
        }
    }
}


-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(httpCode != 0)
        {
            [self buildHeadError:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",httpCode]];
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
                
            }
        }
    }];
    
    
}
#pragma mark - Model 解析
- (void)analySisSignModel:(SignModel *)model{
    if ([model.head.retFlag isEqualToString:@"00000"]){
        
        if (self.flag) {
            
            [self toNewNumberViewController];
        }else{
            
            [self toAppdelegate];
        }
    }else if ([model.head.retFlag isEqualToString:@"U0173"]){
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"手势密码重置失败，请直接使用账号登录" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
//                    [SettingStore storeLastUserLoginPwd:@""];
//                    [[AppDelegate delegate]setRootLoginAllWithSignModel:model];

                }
            }
        }];
    }else{
        [self buildHeadError:model.head.retMsg];
    }
}
@end
