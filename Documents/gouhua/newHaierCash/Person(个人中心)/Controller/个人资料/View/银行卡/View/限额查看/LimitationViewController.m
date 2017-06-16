//
//  LimitationViewController.m
//  personMerchants
//
//  Created by 史长硕 on 17/3/15.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "LimitationViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import <MJRefresh.h>

static CGFloat const  GetBankList = 101;//获取银行卡列表
@interface LimitationViewController ()<UITableViewDelegate,UITableViewDataSource,BSVKHttpClientDelegate>
{
    
    UITableView *_bankTableView;//银行卡列表视图
    
    
    
}

@end

@implementation LimitationViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"限额查看";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self creatBankTable];
    
    if (![_model.head.retFlag isEqualToString:@"00000"]) {
     
        [self getBankList];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> private Methods
//创建银行卡表视图
-(void)creatBankTable{
    
    _bankTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,DeviceWidth, DeviceHeight-64) style:UITableViewStylePlain];
    
    _bankTableView.dataSource = self;
    
    _bankTableView.delegate = self;
    
    _bankTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_bankTableView];
    
}

#pragma mark --> tableView 代理协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _model.body.info.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jack"];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jack"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 2.5, DeviceWidth-15, 20)];
        
        nameLab.tag = 10;
        
        nameLab.font = [UIFont appFontRegularOfSize:15];
        
        [cell.contentView addSubview:nameLab];
        
        UILabel *moneyLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 22.5, DeviceWidth-15, 20)];
        
        moneyLab.tag = 20;
        
        moneyLab.font = [UIFont appFontRegularOfSize:13];
        
        [cell.contentView addSubview:moneyLab];
        
    }
    
    BankInfo *info = _model.body.info[indexPath.row];
    
    UILabel *nameLab = (UILabel *)[cell.contentView viewWithTag:10];
    
    nameLab.text = info.bankName;
    
    UILabel *moneyLab = (UILabel *)[cell.contentView viewWithTag:20];
    
    if ([info.singleCollLimited isEqualToString:@"-1"]) {
        
       moneyLab.text = @"不限额";
        
    }else{
        
     moneyLab.text = [NSString stringWithFormat:@"单笔限额%@万元",info.singleCollLimited];
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
    
}

#pragma mark --> 发起的网络请求
- (void)getBankList {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [BSVKHttpClient shareInstance].delegate = self;
    
    [[BSVKHttpClient shareInstance]getInfo:@"app/appserver/crm/cust/getBankCard" requestArgument:@{@"custNo":StringOrNull([AppDelegate delegate].userInfo.custNum)} requestTag:GetBankList requestClass:NSStringFromClass([self class])];
}

#pragma mark --> 网络请求代理协议

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == GetBankList) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
//             BankLIstMode *model = [BankLIstMode mj_objectWithKeyValues:responseObject];
            
//            [self buildHandleGetBank:model];
            
        }
        
    }
    
}

- (void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className {
    
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

#pragma mark --> 网络请求成功后的处理
//请求银行卡列表
-(void)buildHandleGetBank:(BankLIstMode *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        _model = model;
        
        [_bankTableView reloadData];
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_bankTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_bankTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_bankTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_bankTableView setLayoutMargins:UIEdgeInsetsZero];
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
