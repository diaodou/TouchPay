
#import "GestureViewController.h"
#import "PCCircleView.h"
#import "PCCircleViewConst.h"
#import "PCLockLabel.h"
#import "PCCircleInfoView.h"
#import "PCCircle.h"
//#import "SecurityLocal.h"
#import "UIFont+AppFont.h"
#import "HCMacro.h"
#import "BSVKHttpClient.h"
#import "AppDelegate.h"
#import "RealNameViewController.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import "GestureModel.h"
#import <MJExtension.h>
#import <MBProgressHUD.h>
#import "NSString+CheckConvert.h"
#import "DefineSystemTool.h"
#import "EnterAES.h"
#import "SvUDIDTools.h"
#import "LoginViewController.h"
#import "HCRootTabController.h"
#import "HCHomeController.h"
#import "StartBrAgent.h"


@interface GestureViewController ()<CircleViewDelegate,BSVKHttpClientDelegate>
{
    CGFloat _viewScale;

}

/**
 *  重设按钮
 */
@property (nonatomic, strong) UIButton *resetBtn;

/**
 *  提示Label
 */
@property (nonatomic, strong) PCLockLabel *msgLabel;

/**
 *  解锁界面
 */
@property (nonatomic, strong) PCCircleView *lockView;

/**
 *  infoView
 */
@property (nonatomic, strong) PCCircleInfoView *infoView;

@property(nonatomic,strong) NSString * gesture;

@end

@implementation GestureViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.type == GestureViewControllerTypeLogin || self.type == GestureViewControllerTypeAutomatic) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    // 进来先清空存的第一个密码
    [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
//    [SettingStore clearGestureError];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"手势设置";
    
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(createGesReq:) name:@"ges" object:nil];
    
    [self.view setBackgroundColor:CircleViewBackgroundColor];
    
    // 1.界面相同部分生成器
    [self setupSameUI];
    
    // 2.界面不同部分生成器
    [self setupDifferentUI];
    
}

#pragma mark - 创建UIBarButtonItem
- (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = (CGRect){CGPointZero, {100, 20}};
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont appFontRegularOfSize:17];
    button.tag = tag;
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [button setHidden:YES];
    self.resetBtn = button;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark - 界面不同部分生成器
- (void)setupDifferentUI
{
    switch (self.type) {
        case GestureViewControllerTypeSetting:
            [self setupSubViewsSettingVc];
            break;
        case GestureViewControllerTypeLogin:
            [self setupSubViewsLoginVc];
            break;
        case GestureViewControllerTypeAutomatic:
            [self setupSubViewsLoginVc];
            break;
        default:
            break;
    }
}

#pragma mark - 界面相同部分生成器
- (void)setupSameUI
{
    // 创建导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [self itemWithTitle:@"重设" target:self action:@selector(didClickBtn:) tag:buttonTagReset];
    
    // 解锁界面
    PCCircleView *lockView = [[PCCircleView alloc] init];
    lockView.delegate = self;
    self.lockView = lockView;
    [self.view addSubview:lockView];
    
    PCLockLabel *msgLabel = [[PCLockLabel alloc] init];
    msgLabel.frame = CGRectMake(20 *_viewScale, 124 *_viewScale, DeviceWidth-40 *_viewScale, 25 *_viewScale);
    msgLabel.font = [UIFont appFontRegularOfSize:22 *_viewScale];
//    msgLabel.frame = CGRectMake(0, 0, kScreenW, 14);
//    msgLabel.center = CGPointMake(kScreenW/2, CGRectGetMinY(lockView.frame) - 30);
    self.msgLabel = msgLabel;
    [self.view addSubview:msgLabel];
}

#pragma mark - 设置手势密码界面
- (void)setupSubViewsSettingVc
{
    [self.lockView setType:CircleViewTypeSetting];
    
    self.title = @"设置手势密码";
    
    [self.msgLabel showNormalMsg:gestureTextBeforeSet];
    
//    PCCircleInfoView *infoView = [[PCCircleInfoView alloc] init];
//    infoView.frame = CGRectMake(0, 0, CircleRadius * 2 * 0.6, CircleRadius * 2 * 0.6);
//    infoView.center = CGPointMake(kScreenW/2, CGRectGetMinY(self.msgLabel.frame) - CGRectGetHeight(infoView.frame)/2 - 10);
//    self.infoView = infoView;
//    [self.view addSubview:infoView];
}

#pragma mark - 登陆手势密码界面
- (void)setupSubViewsLoginVc
{
    [self.lockView setType:CircleViewTypeLogin];
    
    // 头像
    UIImageView  *imageView = [[UIImageView alloc] init];
    if (iphone6P) {
        imageView.frame = CGRectMake(0, 0, 134 *_viewScale, 134 *_viewScale);
        
        imageView.layer.cornerRadius = 67.0f *_viewScale;
    }else{
        imageView.frame = CGRectMake(0, 0, 121 *_viewScale, 121 *_viewScale);
        
        imageView.layer.cornerRadius = 60.5f *_viewScale;
    }
    
   
    imageView.center = CGPointMake(kScreenW/2, kScreenH/5);
    [imageView setImage:[UIImage imageNamed:@"手势密码_头像"]];
    [self.view addSubview:imageView];
    UILabel *labelTip = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 16, [UIScreen mainScreen].bounds.size.width, 21)];
    labelTip.text = @"请输入手势密码";
    labelTip.textAlignment = NSTextAlignmentCenter;
    labelTip.font = [UIFont systemFontOfSize:14];
    labelTip.textColor = [UIColor colorWithRed:154.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    [self.view addSubview:labelTip];
    self.msgLabel.frame = CGRectMake(0, CGRectGetMaxY(labelTip.frame) + 4, [UIScreen mainScreen].bounds.size.width, 21);
    self.lockView.frame = CGRectMake(CGRectGetMinX(self.lockView.frame), CGRectGetMaxY(labelTip.frame) + 10, CGRectGetWidth(self.lockView.frame), CGRectGetHeight(self.lockView.frame));

    // 管理手势密码
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // 登录其他账户
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    if (iphone6P) {
        [self creatButton:leftBtn frame:CGRectMake(48 *_viewScale, DeviceHeight-72 *_viewScale, DeviceWidth/2-48 *_viewScale, 16 *_viewScale) title:@"忘记手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];
        
        [self creatButton:rightBtn frame:CGRectMake(DeviceWidth/2, DeviceHeight-72 *_viewScale, DeviceWidth/2-48 *_viewScale, 16 *_viewScale) title:@"用其他账号登录" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];

    }else if(IPHONE4){
        [self creatButton:leftBtn frame:CGRectMake(48 *_viewScale, DeviceHeight-32 *_viewScale, DeviceWidth/2-48 *_viewScale, 16 *_viewScale) title:@"忘记手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];
        
        [self creatButton:rightBtn frame:CGRectMake(DeviceWidth/2, DeviceHeight-32 *_viewScale, DeviceWidth/2-48 *_viewScale, 16 *_viewScale) title:@"用其他账号登录" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];

    }else{
        [self creatButton:leftBtn frame:CGRectMake(48 *_viewScale, DeviceHeight-72 *_viewScale, DeviceWidth/2-48 *_viewScale, 16 *_viewScale) title:@"忘记手势密码" alignment:UIControlContentHorizontalAlignmentLeft tag:buttonTagManager];
        
        [self creatButton:rightBtn frame:CGRectMake(DeviceWidth/2, DeviceHeight-72 *_viewScale, DeviceWidth/2-48 *_viewScale, 16 *_viewScale) title:@"用其他账号登录" alignment:UIControlContentHorizontalAlignmentRight tag:buttonTagForget];
    }
   
}

#pragma mark - 创建UIButton
- (void)creatButton:(UIButton *)btn frame:(CGRect)frame title:(NSString *)title alignment:(UIControlContentHorizontalAlignment)alignment tag:(NSInteger)tag
{
    btn.frame = frame;
    btn.tag = tag;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:154.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn setContentHorizontalAlignment:alignment];
    [btn.titleLabel setFont:[UIFont appFontRegularOfSize:14.0f]];
    [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

#pragma mark - button点击事件
- (void)didClickBtn:(UIButton *)sender
{
    NSLog(@"%ld", (long)sender.tag);
    switch (sender.tag) {
        case buttonTagReset:
        {
            NSLog(@"点击了重设按钮");
            // 1.隐藏按钮
            [self.resetBtn setHidden:YES];
            
            // 2.infoView取消选中
            [self infoViewDeselectedSubviews];
            
            // 3.msgLabel提示文字复位
            [self.msgLabel showNormalMsg:gestureTextBeforeSet];
            
            // 4.清除之前存储的密码
            [PCCircleViewConst saveGesture:nil Key:gestureOneSaveKey];
        }
            break;
        case buttonTagManager:
        {
            NSLog(@"点击了忘记势密码按钮");
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            HCRootNavController *nav = [[HCRootNavController alloc]initWithRootViewController:loginVC];
            loginVC.fromType = fromForgetGesture;
            [self presentViewController:nav animated: YES completion:nil];
        }
            break;
        case buttonTagForget:
        {
            NSLog(@"点击了登录其他账户按钮");
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            HCRootNavController *nav = [[HCRootNavController alloc]initWithRootViewController:loginVC];
            [AppDelegate delegate].userInfo = [[HCUserModel alloc]init];
            loginVC.fromType = fromGesture;
            [self presentViewController:nav animated: YES completion:nil];
        }

            break;
        default:
            break;
    }
    
    
    
}

#pragma mark - circleView - delegate
#pragma mark - circleView - delegate - setting
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type connectCirclesLessThanNeedWithGesture:(NSString *)gesture
{
    NSString *gestureOne = [PCCircleViewConst getGestureWithKey:gestureOneSaveKey];
    
    // 看是否存在第一个密码
    if ([gestureOne length]) {
        [self.resetBtn setHidden:NO];
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
    } else {
        NSLog(@"密码长度不合法%@", gesture);
        [self.msgLabel showWarnMsgAndShake:gestureTextConnectLess];
    }
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetFirstGesture:(NSString *)gesture
{
    [self.msgLabel showWarnMsg:gestureTextDrawAgain];
    
    // infoView展示对应选中的圆
//    [self infoViewSelectedSubviewsSameAsCircleView:view];
}

- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteSetSecondGesture:(NSString *)gesture result:(BOOL)equal
{
    
    if (equal) {
        NSLog(@"两次手势匹配！可以进行本地化保存了");
        NSData* data = [gesture dataUsingEncoding:NSUTF8StringEncoding];
        NSString *gestureStr = [DefineSystemTool md5StringWithData:data];
        
        //手势密码设置
        NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
        [dic setObject:StringOrNull([EnterAES simpleEncrypt:[AppDelegate delegate].userInfo.userId]) forKey:@"userId"];
        [dic setObject:[EnterAES simpleEncrypt:gestureStr] forKey:@"gesture"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        WEAKSELF
        [[BSVKHttpClient shareInstance]putInfo:@"app/appserver/uauth/gesture" requestArgument:dic completion:^(id results, NSError *error) {
            STRONGSELF
            if (results) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSLog(@"手势%@",results);
                GestureModel *model = [GestureModel mj_objectWithKeyValues:results];
                if ([model.head.retFlag isEqualToString:@"00000"]) {
                    
                    [strongSelf.msgLabel showWarnMsg:gestureTextSetSuccess];
                    
                    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:gestureTextSetSuccess cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                        
                        if (strongSelf) {
                            if (buttonIndex == 0) {
                                
                                [PCCircleViewConst saveGesture:gesture Key:gestureFinalSaveKey];
                                
                                if (_whereType == whereother) {
                                    UIViewController *rootVC = self.presentingViewController;
                                    
                                    while (rootVC.presentingViewController) {
                                        rootVC = rootVC.presentingViewController;
                                    }
                                    [rootVC dismissViewControllerAnimated:NO completion:nil];
                                }else{
                                    UIViewController *rootVC = self.presentingViewController;
                                    
                                    while (rootVC.presentingViewController) {
                                        rootVC = rootVC.presentingViewController;
                                    }
                                    
                                    if ([rootVC isKindOfClass:[HCRootTabController class]]) {
                                        HCRootTabController *tabCon = (HCRootTabController *)rootVC;
                                        UINavigationController *con = tabCon.selectedViewController;
                                        [con popToRootViewControllerAnimated:YES];
                                        [rootVC dismissViewControllerAnimated:NO completion:nil];
                                        
                                    }
                                }
                                
                            }
                        }
                    }]; 
                }else {
                    [strongSelf.msgLabel showWarnMsgAndShake:model.head.retMsg];
                    [strongSelf.resetBtn setHidden:NO];
                }
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [strongSelf.msgLabel showWarnMsgAndShake:@"网络环境异常，请检查网络并重试"];
                [strongSelf.resetBtn setHidden:NO];
            }
        }];
    } else {
        NSLog(@"两次手势不匹配！");
        [self.msgLabel showWarnMsgAndShake:gestureTextDrawAgainError];
        [self.resetBtn setHidden:NO];
    }
}

#pragma mark - circleView - delegate - login or verify gesture
- (void)circleView:(PCCircleView *)view type:(CircleViewType)type didCompleteLoginGesture:(NSString *)gesture result:(BOOL)equal
{
    // 此时的type有两种情况 Login or verify
    if (type == CircleViewTypeLogin) {
        
        if (equal) {
            NSLog(@"登陆成功！");
        } else {
            NSLog(@"密码错误！");
            [self.msgLabel showWarnMsgAndShake:gestureTextGestureVerifyError];
        }
    } else if (type == CircleViewTypeVerify) {
        
        if (equal) {
            NSLog(@"验证成功，跳转到设置手势界面");
            
        } else {
            NSLog(@"原手势密码输入错误！");
            
        }
    }
}

#pragma mark - infoView展示方法
#pragma mark - 让infoView对应按钮选中
- (void)infoViewSelectedSubviewsSameAsCircleView:(PCCircleView *)circleView
{
    for (PCCircle *circle in circleView.subviews) {
        
        if (circle.state == CircleStateSelected || circle.state == CircleStateLastOneSelected) {
            
            for (PCCircle *infoCircle in self.infoView.subviews) {
                if (infoCircle.tag == circle.tag) {
                    [infoCircle setState:CircleStateSelected];
                }
            }
        }
    }
}

#pragma mark - 让infoView对应按钮取消选中
- (void)infoViewDeselectedSubviews
{
    [self.infoView.subviews enumerateObjectsUsingBlock:^(PCCircle *obj, NSUInteger idx, BOOL *stop) {
        [obj setState:CircleStateNormal];
    }];
}
//手势密码验证
- (void)createGesReq :(NSNotification *)noti{
    
    //   初始化client
    [BSVKHttpClient shareInstance].delegate = self;
    NSString *gess = [NSString stringWithFormat:@"%@",noti.object[@"ges"]];
    NSData* data = [gess dataUsingEncoding:NSUTF8StringEncoding];
    NSString *ges = [DefineSystemTool md5StringWithData:data];
    
    self.gesture = ges;
    
    if (self.type == GestureViewControllerTypeLogin || self.type == GestureViewControllerTypeAutomatic)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:StringOrNull([EnterAES simpleEncrypt:[DefineSystemTool getLastUserLoginId]]) forKey:@"userId"];
        [dic setObject:StringOrNull([EnterAES simpleEncrypt:ges]) forKey:@"gesture"];
        [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/uauth/validateGesture" requestArgument:dic requestTag:1 requestClass:NSStringFromClass([self class])];
    }
}
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 1) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            GestureModel *model = [GestureModel mj_objectWithKeyValues:responseObject];
            
            NSLog(@"手势验证回执%@",responseObject);
            
            if ([model.head.retFlag isEqualToString:@"00000"])
            {
                [AppDelegate delegate].userInfo.userHeader = model.body.avatarUrl;
                [AppDelegate delegate].userInfo.userId = model.body.userId;
                [AppDelegate delegate].userInfo.userTel = model.body.mobile;
                [AppDelegate delegate].userInfo.bLoginOK = YES;
                //百融
                [StartBrAgent startBrAgentLogin];
                if (self.type ==GestureViewControllerTypeAutomatic) {
                    UIViewController *rootVC = self.presentingViewController;
                    
                    while (rootVC.presentingViewController) {
                        rootVC = rootVC.presentingViewController;
                    }
                    
                    if ([rootVC isKindOfClass:[HCRootTabController class]]) {
                        HCRootTabController *tabCon = (HCRootTabController *)rootVC;
                        [tabCon.homeCon showKPController];
                        [tabCon dismissViewControllerAnimated:YES completion:nil];
                    }

                    
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                
            }else{//如果没成功，那么就把异常抛出
                [self.msgLabel showWarnMsgAndShake:model.head.retMsg];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"gestureError" object:nil];
                [self.resetBtn setHidden:NO];
            }
        }
        
    }
}
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [Bugly reportError:error];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        NSLog(@"%@",error);
        
        NSLog(@"%ld",(long)requestTag);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (httpCode == 500) {
            
            [self buildHeadError:@"服务器错误"];
        }else{
            
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

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


@end
