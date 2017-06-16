//
//  ConfirmPayNoBankViewController.m
//  personMerchants
//
//  Created by 百思为科 on 16/4/13.
//  Copyright © 2016年 海尔金融. All rights reserved.
//  Update by LLM on 17/1/20.

#import "ConfirmPayNoBankViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
//#import "PhoneProtocolViewController.h"
#import "BSVKHttpClient.h"
#import "RememberPasswordViModel.h"
#import <MJExtension.h>
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
//#import "HaveQuotaIdentityCodeViewController.h"
#import <MBProgressHUD.h>
#import "AllloanViewController.h"
#import "EnterAES.h"
#import "RealNameViewController.h"
@interface ConfirmPayNoBankViewController ()<UITableViewDelegate,UITableViewDataSource,BSVKHttpClientDelegate>
{
    UITextField *_pwdTextField;
    
}

@property(nonatomic,strong)UITableView *PayTable;

@end

@implementation ConfirmPayNoBankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"确认支付";
    self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:238/255.0 blue:239/255.0 alpha:1.0];
    
    [AppDelegate delegate].userInfo.bReturn = NO;
    
    [self setNavi];
    
    [self createPayTable];
    
    [self createPassBtn];
}

#pragma mark - 创建密码按钮
- (void)createPayTable
{
    self.PayTable = [[UITableView alloc]initWithFrame:(CGRectMake(0, 10, DeviceWidth,  125)) style:(UITableViewStylePlain)];
    [self.PayTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.PayTable.delegate = self;
    self.PayTable.dataSource = self;
    self.PayTable.scrollEnabled = NO;
    self.PayTable.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.PayTable];
}

- (void)createPassBtn
{
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    btn.frame = CGRectMake(DeviceWidth - 150 * DeviceWidth / 375, CGRectGetMaxY(self.PayTable.frame), 130 * DeviceWidth/375, 40);
    [btn setTintColor:UIColorFromRGB(0x32beff, 1.0)];
    [btn setTitle:@"忘记支付密码？" forState:(UIControlStateNormal)];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(forgetPassword) forControlEvents:(UIControlEventTouchUpInside)];
   
}
- (void)forgetPassword
{
    RealNameViewController *real = [[RealNameViewController alloc]init];
//    real.flowName = changeDealPwdByNoRemeber;
    [self.navigationController pushViewController:real animated:YES];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"cellaa";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:reuseID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0)
    {
        UILabel *pwd = [[UILabel alloc]initWithFrame:(CGRectMake(20, 0, 90, cell.contentView.frame.size.height))];
        pwd.text = @"支付密码：";
        pwd.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:pwd];
        
        UITextField *txt = [[UITextField alloc]initWithFrame:(CGRectMake(CGRectGetMaxX(pwd.frame), CGRectGetMinY(pwd.frame), DeviceWidth - CGRectGetMaxX(pwd.frame), CGRectGetHeight(pwd.frame))) ];
        txt.font = [UIFont systemFontOfSize:16];
        txt.textAlignment = NSTextAlignmentLeft;
        txt.placeholder = @"请输入支付密码";
        txt.secureTextEntry = YES;
        
        _pwdTextField = txt;
        [cell.contentView addSubview:txt];
    }
    else if (indexPath.row == 1)
    {
        UIButton *next = [[UIButton alloc]initWithFrame:(CGRectMake(20 *DeviceWidth /375,20, DeviceWidth - 40 * DeviceWidth / 375, 40))];
        next.backgroundColor = [UIColor colorWithRed:23/255.0 green:142/255.0 blue:227/255.0 alpha:1.0];
        [next setTitle:@"下一步" forState:(UIControlStateNormal)];
        [next addTarget:self action:@selector(nextStep:) forControlEvents:(UIControlEventTouchUpInside)];
        next.tintColor = [UIColor whiteColor];
        next.titleLabel.font = [UIFont appFontRegularOfSize:16];
        [cell.contentView addSubview:next];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        return 80 ;
    }
    
    return 45;
}

#pragma mark - 下一步
- (void)nextStep:(UIButton *)sender
{
    [_pwdTextField resignFirstResponder];
    
    if(_pwdTextField.text.length == 0)
    {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请输入支付密码" cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex)
         {
             STRONGSELF
             if (strongSelf)
             {
                 if (buttonIndex == 0)
                 {
                 }
             }
         }];
        
        return;
    }
    
    //支付密码验证
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    NSString *userId = StringOrNull([AppDelegate delegate].userInfo.userId);
    [dict setObject:[EnterAES simpleEncrypt:userId] forKey:@"userId"];
    [dict setObject:[EnterAES simpleEncrypt:_pwdTextField.text] forKey:@"payPasswd"];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance] getInfo:@"app/appserver/uauth/validatePayPasswd" requestArgument:dict requestTag:1 requestClass:NSStringFromClass([self class])];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
#pragma mark - 设置导航
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
    if ([AppDelegate delegate].userInfo.busFlowName == CashLoanCreate || [AppDelegate delegate].userInfo.busFlowName == GoodsLoanCreate)
    {
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"订单已保存，可到个人中心待提交订单查看,是否返回?" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex)
        {
            STRONGSELF
            if (strongSelf)
            {
                if (buttonIndex == 1)
                {
                    [strongSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        }];
    }
    else if ([AppDelegate delegate].userInfo.busFlowName == CashLoanWait || [AppDelegate delegate].userInfo.busFlowName == GoodsLoanWait)
    {
        //待提交
        NSArray *vcArray = self.navigationController.viewControllers;
        
        for(UIViewController *vc in vcArray)
        {
            if ([vc isKindOfClass:[AllloanViewController class]])
            {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }
    else if ( [AppDelegate delegate].userInfo.busFlowName == CashLoanReturned || [AppDelegate delegate].userInfo.busFlowName == GoodsReturnedByMerchant || [AppDelegate delegate].userInfo.busFlowName == GoodsReturnedByCredit )
    {
        //被退回
        NSArray *vcArray = self.navigationController.viewControllers;
        
        for(UIViewController *vc in vcArray)
        {
            if ([vc isKindOfClass:[AllloanViewController class]])
            {
                [AppDelegate delegate].userInfo.bReturn = YES;
                [self.navigationController popToViewController:vc animated:YES];
            }else{
                [AppDelegate delegate].userInfo.bReturn = YES;
                [self.navigationController popToViewController:[vcArray objectAtIndex:1] animated:YES];
            }
        }
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.PayTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.PayTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.PayTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.PayTable setLayoutMargins:UIEdgeInsetsZero];
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

#pragma mark - BSVKHttpDelegate
//请求成功
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
        RememberPasswordViModel * model = [RememberPasswordViModel mj_objectWithKeyValues:responseObject];
        
        if ([model.head.retFlag isEqualToString:@"00000"] )
        {
#warning mark - 跳转一个界面
            //                PhoneProtocolViewController *vc = [[PhoneProtocolViewController alloc]init];
            //                vc.tel = [AppDelegate delegate].userInfo.userTel;
            //                vc.flowName = beReturnCashLoan;
            //                [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            if ([model.head.retMsg isEqualToString:@"支付密码验证失败"])
            {
                model.head.retMsg = @"密码错误，请重新输入";
            }
            
            WEAKSELF
            [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:[NSString stringWithFormat:@"%@",model.head.retMsg] cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex)
            {
                STRONGSELF
                if (strongSelf)
                {
                    if (buttonIndex == 0)
                    {
                    }
                }
            }];
        }
    }
}
//请求失败
- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        NSString *errorStr;
        if(httpCode != 0)
        {
            errorStr = [NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",httpCode];
        }
        else
        {
            errorStr = @"网络环境异常，请检查网络并重试";
        }
        WEAKSELF
        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:errorStr cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
            STRONGSELF
            if (strongSelf) {
                if (buttonIndex == 0) {
                    
                }
            }
        }];
    }
}


@end
