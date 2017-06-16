//
//  ChangNumberViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/22.
//  Copyright © 2016年 海尔金融. All rights reserved.
//
#import "UIFont+AppFont.h"
#import "ChangNumberViewController.h"
#import "HCMacro.h"
#import "WriteVerificationViewController.h"
#import "RealNameViewController.h"
#import "NewNumberViewController.h"

#import "AppDelegate.h"
@interface ChangNumberViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *changeTableView;
@end

@implementation ChangNumberViewController
#pragma Mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改绑定手机号";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    [[UIBarButtonItem appearance]setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [self creatTableView];
    [self creatView];
    [self setNavi];
}
#pragma mark - setting and getting
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
- (void)creatTableView{
    _changeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 9, DeviceWidth, 100) style:UITableViewStylePlain];
    _changeTableView.delegate = self;
    _changeTableView.dataSource = self;
    _changeTableView.scrollEnabled = NO;
    [self.view addSubview:_changeTableView];
}
// set View
-(void)creatView{
    UIView *TopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 9)];
    TopView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
    [self.view addSubview:TopView];
}
#pragma mark -- tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iphone6P) {
        
        return 50;
    }else{
    
        return 45;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString *cellID = @"cellID";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        NSArray *array = @[@"原手机能接收验证码",@"实名认证，认证一张本人的银行卡"];
        cell.textLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        cell.textLabel.font = [UIFont appFontRegularOfSize:14];
        cell.textLabel.text = array[indexPath.row];
        cell.accessoryType = UITableViewCellStyleValue1;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_changeTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        [self toWriteVerificationViewController];
    }
    else
    {
        [self toNewNumViewController];
    }
}
#pragma mark -- private Methods
- (void)toWriteVerificationViewController{
    WriteVerificationViewController *vc = [[WriteVerificationViewController alloc]init];
    vc.strTel = [AppDelegate delegate].userInfo.userTel;
    vc.writeVerificationChageBindPhoneNumType = WriteVerificationChanageTelByCheckCode;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)toNewNumViewController
{
    NewNumberViewController *vc = [[NewNumberViewController alloc]init];
    vc.chageBindNumType = ChangeBindPhoneNumByRealNameType;
    [self.navigationController pushViewController:vc animated:YES];
    
//    RealNameViewController *realNameVC = [[RealNameViewController alloc]init];
//    realNameVC.strTel = [AppDelegate delegate].userInfo.userId;
//    realNameVC.chageBindNumType = ChageBindPhoneNumByRealNameType;
//    [self.navigationController pushViewController:realNameVC animated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_changeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_changeTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_changeTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_changeTableView setLayoutMargins:UIEdgeInsetsZero];
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


@end
