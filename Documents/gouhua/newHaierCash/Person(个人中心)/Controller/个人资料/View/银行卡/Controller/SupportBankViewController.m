//
//  SupportBankViewController.m
//  personMerchants
//
//  Created by liliangming on 2017/3/14.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "SupportBankViewController.h"
#import "BankNameModel.h"
#import "HCMacro.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import <MJExtension.h>
static const float getSupportBankList = 100;

@interface SupportBankViewController ()<UITableViewDelegate,UITableViewDataSource,BSVKHttpClientDelegate>

@end

@implementation SupportBankViewController
{
    BankNameModel *_bankNameModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"支持银行卡";
    [self setLineView];
    [self setNavi];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getSupportBankList];
}

#pragma mark - 得到支持的银行卡
- (void)getSupportBankList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [BSVKHttpClient shareInstance].delegate = self;
    [[BSVKHttpClient shareInstance] getInfo:@"app/appserver/crm/cust/getBankList" requestArgument:nil requestTag:getSupportBankList requestClass:NSStringFromClass([self class])];
}

#pragma mark - 初始化视图
//设置导航
- (void)setNavi
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
- (void)setLineView{

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, .5)];
    
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    [self.view addSubview:lineView];
}
- (void)initContentView
{
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, .5, DeviceWidth, DeviceHeight - 64) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:table];
}

#pragma mark - 点击事件
- (void)onBackBtn:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((70 - 33)/2, (80-33)/2, 33, 33)];
        iv.tag = 102;
        [cell.contentView addSubview:iv];
        
        UILabel *bankNameLabel = [[UILabel alloc] init];
        bankNameLabel.frame = CGRectMake(70, 20, DeviceWidth - 40, 20);
        bankNameLabel.textAlignment = NSTextAlignmentLeft;
        bankNameLabel.font = [UIFont systemFontOfSize:16];
        bankNameLabel.textColor = [UIColor blackColor];
        bankNameLabel.tag = 100;
        [cell.contentView addSubview:bankNameLabel];
        
        UILabel *bankLimitLabel = [[UILabel alloc] init];
        bankLimitLabel.frame = CGRectMake(70, 40, DeviceWidth - 40, 20);
        bankLimitLabel.textAlignment = NSTextAlignmentLeft;
        bankLimitLabel.textColor = [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00];
        bankLimitLabel.font = [UIFont systemFontOfSize:14];
        bankLimitLabel.tag = 101;
        [cell.contentView addSubview:bankLimitLabel];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, 79.7f, DeviceWidth, 0.3f);
        lineView.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];
        [cell.contentView addSubview:lineView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel *bankNameLabel = [cell.contentView viewWithTag:100];
    bankNameLabel.text = _bankNameModel.body[indexPath.row].bankName;
    UIImageView *iv = [cell.contentView viewWithTag:102];
    UIImage *iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"还款卡_%@",_bankNameModel.body[indexPath.row].bankName]];
    if(iconImage)
    {
        iv.image = iconImage;
    }
    else
    {
        iv.image = [UIImage imageNamed:@"默认"];
    }
    
    UILabel *bankLimitLabel = [cell.contentView viewWithTag:101];
    if([_bankNameModel.body[indexPath.row].singleCollLimited isEqualToString:@"-1"])
    {
        bankLimitLabel.text = @"不限额";
    }
    else
    {
        bankLimitLabel.text = [NSString stringWithFormat:@"单笔限额%@元",_bankNameModel.body[indexPath.row].singleCollLimited]; 
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _bankNameModel.body.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - BSVKDelegate
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
        if(requestTag == getSupportBankList)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            _bankNameModel = [BankNameModel mj_objectWithKeyValues:responseObject];
            
            if([_bankNameModel.head.retFlag isEqualToString:@"00000"])
            {
                [self initContentView];
            }
            else
            {
                [self buildHeadError:_bankNameModel.head.retMsg];
            }
        }
    }
}

- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])])
    {
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
- (void)buildHeadError:(NSString *)error
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                
            }
        }
    }];
}

@end
