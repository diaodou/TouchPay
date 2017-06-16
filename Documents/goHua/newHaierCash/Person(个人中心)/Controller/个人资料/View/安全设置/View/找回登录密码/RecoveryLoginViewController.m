//
//  RecoveryLoginViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/21.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "RecoveryLoginViewController.h"
#import "HCMacro.h"
#import "RealNameViewController.h"
#import "UIFont+AppFont.h"
#import "AppDelegate.h"
#import "InputTelFindPwdViewController.h"

@interface RecoveryLoginViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *ReconveryTableView;
@end

@implementation RecoveryLoginViewController
#pragma mark -- lift cycle
- (void)viewDidLoad
{
    self.navigationItem.title = @"找回登录密码";
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);;
    [super viewDidLoad];
    [self creatTableView];
    [self setNavi];
    [self creatView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - setting and getting
//设置导航
- (void)setNavi
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

-(void)creatTableView
{
    
    _ReconveryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 9, DeviceWidth, 120 ) style:UITableViewStylePlain];
    _ReconveryTableView.delegate = self;
    _ReconveryTableView.dataSource = self;
    _ReconveryTableView.scrollEnabled = NO;
    [self.view addSubview:_ReconveryTableView];
}

-(void)creatView
{
    UIView *TopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 9)];

    TopView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
    
    [self.view addSubview:TopView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 2)
    {
        return 0;
    }
    else
    {
        return 60;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
       
        if (indexPath.row == 1) {
//            方式1
            UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 80, 20)];
            topLabel.font = [UIFont appFontRegularOfSize:16];
            topLabel.textColor = UIColorFromRGB(0x333333, 1.0);
            topLabel.text = @"方式一：";
            [cell.contentView addSubview:topLabel];
//            验证码找回
            UILabel *fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 305*DeviceWidth/375, 20)];
            fixedLabel.font = [UIFont appFontRegularOfSize:16];
            fixedLabel.textColor = UIColorFromRGB(0x333333, 1.0);
            fixedLabel.text = @"验证码找回";
            [cell.contentView addSubview:fixedLabel];

            if ([AppDelegate delegate].userInfo.bLoginOK ==YES) {
//                下面发送验证码。。。
                UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 32, 345*DeviceWidth/375, 20)];
                bottomLabel.font = [UIFont appFontRegularOfSize:13];
                bottomLabel.text = [NSString stringWithFormat:@"发送验证码至绑定手机号"];
                bottomLabel.textColor = UIColorFromRGB(0x9d9d9d, 1);
                [cell.contentView addSubview:bottomLabel];
            }else{
                topLabel.frame =CGRectMake(30, 20, 80, 20);
                fixedLabel.frame = CGRectMake(90, 20, 305*DeviceWidth/375, 20);
            }
            
            
             cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else if(indexPath.row == 3){
//            方式2
            UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 80, 20)];
            topLabel.textColor = UIColorFromRGB(0x333333, 1.0);
            topLabel.font = [UIFont appFontRegularOfSize:16];
            topLabel.text = @"方式二：";
            [cell.contentView addSubview:topLabel];
//            实名认证
            UILabel *fixedLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 305*DeviceWidth/375, 20)];
            fixedLabel.textColor = UIColorFromRGB(0x333333, 1.0);
            fixedLabel.font = [UIFont appFontRegularOfSize:16];
            fixedLabel.text = @"实名认证";
            [cell.contentView addSubview:fixedLabel];
            UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 32, 345*DeviceWidth/375, 20)];
            bottomLabel.font = [UIFont appFontRegularOfSize:13];
            bottomLabel.text = @"认证一张本人银行卡";
            bottomLabel.textColor = UIColorFromRGB(0x9d9d9d, 1);
            [cell.contentView addSubview:bottomLabel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        }else{
            cell.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        
        [self toInputTelFindPwdViewController];
    }else if(indexPath.row == 3){
        
        [self toRealNameViewController];
    }
}
#pragma mark - private Methods
- (void)toInputTelFindPwdViewController{
    InputTelFindPwdViewController *phoneVC = [[InputTelFindPwdViewController alloc]init];
    if ([AppDelegate delegate].userInfo.bLoginOK) {//用bLoginOK判断是从修改登录密码流程还是从找回密码流程
        
    }else{
        
        phoneVC.strTel = StringOrNull(_strTel);//输入的登录号
    }
    [self.navigationController pushViewController:phoneVC animated:YES];
}
- (void)toRealNameViewController{
    RealNameViewController *flowName = [[RealNameViewController alloc]init];
    if ([AppDelegate delegate].userInfo.bLoginOK) {
        
        
    }else{//没有登录的情况下
        
        flowName.strTel = _strTel;
    }
    [self.navigationController pushViewController:flowName animated:YES];
}
#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_ReconveryTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_ReconveryTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_ReconveryTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_ReconveryTableView setLayoutMargins:UIEdgeInsetsZero];
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
#pragma mark - event response
- (void)OnBackBtn:(UIButton *)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
