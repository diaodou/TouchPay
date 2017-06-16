//
//  SecurityViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/21.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "SecurityViewController.h"
#import "HCMacro.h"
#import "RecoveryLoginViewController.h"
#import "ResetPasswordViewController.h"
#import "ChangNumberViewController.h"
#import "UIFont+AppFont.h"
#import "PassWordViewController.h"
#import "AppDelegate.h"
#import "NSString+CheckConvert.h"
#import "RMUniversalAlert.h"
#import <MJExtension.h>
//海尔会员重设密码
#import "PMWebViewController.h"
#import "BSVKHttpClient.h"
#import "EnterAES.h"
#import "RegisterModel.h"
#import "DefineSystemTool.h"
#import "LoginViewController.h"
static const  CGFloat isRegister = 1001;

@interface SecurityViewController ()<UITableViewDataSource,UITableViewDelegate,BSVKHttpClientDelegate,PMWebViewControllerDelegate>{
    
}
@property (nonatomic,strong) UITableView *SecurityTableView;

@property (nonatomic,strong) PMWebViewController *forgetPasswordController;

@end

@implementation SecurityViewController
#pragma  mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.title =@"安全设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatView];
    [self setNavi];
    [self creatTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_SecurityTableView reloadData];
    
}
#pragma mark - setting and getting
//注意self.forgetPasswordController的使用，每次调用的时候都会重新刷新webViewController，数据会丢失
//这样做的目的是为了多次进入页面时，web页重新刷新。
- (PMWebViewController *)forgetPasswordController {
    if (_forgetPasswordController) {
        _forgetPasswordController = nil;
    }
    _forgetPasswordController = [[PMWebViewController alloc] init];
    _forgetPasswordController.webConDelegate = self;
    _forgetPasswordController.webType = PMWebVeiwControllerTypeChangedPassword;
    
    return _forgetPasswordController;
}


//设置导航
- (void)setNavi
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)OnBackBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)creatView{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 9)];

    topView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
 
    [self.view addSubview:topView];
}
-(void)creatTableView{
    _SecurityTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 9, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    _SecurityTableView.delegate = self;
    _SecurityTableView.dataSource = self;
    _SecurityTableView.scrollEnabled = NO;
    _SecurityTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_SecurityTableView];
}
#pragma mark -- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iphone6P) {
        
        return 50;
    }else{
    
        return 45 *DeviceWidth/375;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSArray *array = @[@"修改登录密码",@"修改支付密码",@"修改绑定手机",@"修改手势密码"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.textLabel.text = array[indexPath.row];
        cell.textLabel.font = [UIFont appFontRegularOfSize:14];
        cell.textLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 2) {
            NSString *telNum = [AppDelegate delegate].userInfo.userTel;
          NSString *tel = [telNum convertToTelNum];
            
            cell.detailTextLabel.text = tel;
            cell.detailTextLabel.font = [UIFont appFontRegularOfSize:13];
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_SecurityTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        // 判断是否为海尔会员
        [self isRegester];
    }else if (indexPath.row == 1){
        
        [self toResetPasswordViewController];
    }else if (indexPath.row == 2){
        
        [self toChangNumberViewController];
    }else{
        
        [self toPassWordViewController];
    }
}
#pragma mark - private Methods
- (void)toRecoveryLoginViewControllerWithModel:(RegisterModel *)model{
    if ([model.body.isRegister isEqualToString:@"Y"] || [model.body.isRegister isEqualToString:@"C"]) {
        //海尔会员修改密码入口
        if ([model.body.alterPwd isEqualToString:@"-1"]) {
            self.forgetPasswordController.webUrlStr = model.body.alterPwdIn;
            _forgetPasswordController.returnUrlStr = model.body.alterPwdOut;
            [self.navigationController pushViewController:_forgetPasswordController animated:YES];
            return;
        }
        
    }
    //非海尔会员修改密码
    RecoveryLoginViewController *recoveryVc = [[RecoveryLoginViewController alloc]init];
    recoveryVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recoveryVc animated:YES];
}
- (void)toResetPasswordViewController{
    if ([AppDelegate delegate].userInfo.bsetPayPwd) {
        ResetPasswordViewController *vc = [[ResetPasswordViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self buildHeadError:@"您尚未设置支付密码"];
    }
}
- (void)toChangNumberViewController{
    ChangNumberViewController *vc = [[ChangNumberViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)toPassWordViewController{
    PassWordViewController *vc = [[PassWordViewController alloc]init];
    vc.flag = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)buildHeadError:(NSString *)error{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                
            }
        }
    }];
}

#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_SecurityTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_SecurityTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_SecurityTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_SecurityTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 网络请求
//此账号是否注册过
- (void)isRegester{
    
    NSString *userId = [AppDelegate delegate].userInfo.userId;
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    client.delegate = self;
    [client getInfo:@"app/appserver/uauth/isRegister" requestArgument:@{@"mobile":[EnterAES simpleEncrypt:userId]} requestTag:isRegister requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma mark - BSVKDelegate
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        if (requestTag == isRegister) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            RegisterModel * model = [RegisterModel mj_objectWithKeyValues:responseObject];
            [self toRecoveryLoginViewControllerWithModel:model];
        }
    }
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
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

#pragma mark - PMWebViewControllerDelegate
- (void)PMWebViewControllerResetPasswordWithSuccess:(BOOL)isSuccess {
    if (isSuccess) {
        [DefineSystemTool setUserPassword:@""];
        NSString *userId = [AppDelegate delegate].userInfo.userId;
        [AppDelegate delegate].userInfo = nil;
        [AppDelegate delegate].userInfo = [[HCUserModel alloc]init];
        [AppDelegate delegate].recordedInfo = [[HCRecordedModel alloc]init];
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        loginVC.userId = userId;
        HCRootNavController *nav = [[HCRootNavController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated: YES completion:nil];
    }
}

@end
