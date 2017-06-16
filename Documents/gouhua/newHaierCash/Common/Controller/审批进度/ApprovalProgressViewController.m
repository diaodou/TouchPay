//
//  ApprovalProgressViewController.m
//  newHaierCash
//
//  Created by 张久健 on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "ApprovalProgressViewController.h"
#import "ApprovalProgressTableViewCell.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import <MJRefresh.h>
#import "MBProgressHUD.h"
#import "BSVKHttpClient.h"
#import "AppDelegate.h"
#import "RMUniversalAlert.h"
#import "ApprovalProcessModel.h"
#import <MJExtension.h>
@interface ApprovalProgressViewController ()<UITableViewDelegate,UITableViewDataSource,BSVKHttpClientDelegate>
{
    UITableView *ApprovalProgressTableView ;
    UIView *headerView;
    UILabel *nodeLabel;//审批节点
    UILabel *stateLabel;//审批状态
    UILabel *reasonLabel;//拒绝原因
    NSString *nodeStr;//最新节点
    NSMutableArray *dataArray;//临时数据
//    NSMutableArray *timeArray;//临时数据
}
@end

@implementation ApprovalProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =@"审批进度";
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController setNavigationBarHidden:NO];
    dataArray = [[NSMutableArray alloc]init];
    _applseq = @"262561";
    [self headerView];
    [self UITableView];
    [self loadData];
    
    
}

#pragma mark - getting and setting
-(void)headerView{
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 123)];
    headerView.hidden = YES;
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 113)];
    showView.backgroundColor = UIColorFromRGB(0x329cff, 1);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 18, 66, 74)];
    imageView.backgroundColor = [UIColor whiteColor];
    [showView addSubview:imageView];
    
    nodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(106, 26, DeviceWidth-120, 17)];
    nodeLabel.font = [UIFont appFontRegularOfSize:16];
    nodeLabel.textAlignment = NSTextAlignmentLeft;
    nodeLabel.textColor = UIColorFromRGB(0xffffff, 1);
    [showView addSubview:nodeLabel];
    
    stateLabel = [[UILabel alloc]initWithFrame:CGRectMake(106, 57, DeviceWidth-120, 13)];
    stateLabel.font = [UIFont appFontRegularOfSize:12];
    stateLabel.textAlignment = NSTextAlignmentLeft;
    stateLabel.textColor = UIColorFromRGB(0xdcecff, 1);
    [showView addSubview:stateLabel];
    
    reasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(106, 78, DeviceWidth-120, 13)];
    reasonLabel.font = [UIFont appFontRegularOfSize:12];
    reasonLabel.textAlignment = NSTextAlignmentLeft;
    reasonLabel.textColor = UIColorFromRGB(0xdcecff, 1);
    [showView addSubview:reasonLabel];
    
    [headerView addSubview:showView];
}

-(void)UITableView{
    ApprovalProgressTableView = [[UITableView alloc]initWithFrame: CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64 - 10)];
    ApprovalProgressTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    ApprovalProgressTableView.delegate = self;
    ApprovalProgressTableView.dataSource = self;
    ApprovalProgressTableView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
    ApprovalProgressTableView.separatorStyle = NO;
    [ApprovalProgressTableView setAllowsSelection:NO];
    ApprovalProgressTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    ApprovalProgressTableView.tableHeaderView = headerView;
    [ApprovalProgressTableView registerClass:[ApprovalProgressTableViewCell class] forCellReuseIdentifier:@"cellAll"];
    [self.view addSubview:ApprovalProgressTableView];
}

#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return _cellArray.count;
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellAll";
    ApprovalProgressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.roundView.backgroundColor = UIColorFromRGB(0xd8d8d8, 1);
    if (indexPath.row == 0) {
        cell.oneView.hidden = YES;
        cell.roundView.backgroundColor = UIColorFromRGB(0x32beff, 1);
    }
    ApprovalProcessBody *body = dataArray[indexPath.row];
    cell.wfiNodeName.text = [NSString stringWithFormat:@"%@ %@",body.wfiNodeName,body.appConclusionDesc];
    cell.timeLabel.text = body.operateTime;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
    
}
#pragma mark - request Methods
// 通过姓名+身份证号查询额度申请审批进度
- (void)getMoneySpeed{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    // [BSVKHttpClient shareInstance].delegate = self;
    
    [client getInfo:@"app/appserver/cmis/approvalProcessByCust" requestArgument:@{@"name":StringOrNull([AppDelegate delegate].userInfo.realName),@"idNo":StringOrNull([AppDelegate delegate].userInfo.realId)} requestTag:10 requestClass:NSStringFromClass([self class])];
}
//通过流水号查询贷款或额度申请审批进度
-(void)creatDataArray{
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
    
    if (_applseq.length>0) {
        
        [parmDic setObject:_applseq forKey:@"applSeq"];
        
    }
    
    [client getInfo:@"app/appserver/cmis/approvalProcessBySeq" requestArgument:parmDic requestTag:10 requestClass:NSStringFromClass([self class])];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
#pragma mark - BSVK delegate

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 10){
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            ApprovalProcessModel *model = [ApprovalProcessModel mj_objectWithKeyValues:responseObject];
            
            [self analySisApprovalProcessModel:model];
            
        }
    }
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [ApprovalProgressTableView.mj_header endRefreshing];
        
        NSLog(@"%@",error);
        
        NSLog(@"%ld",(long)requestTag);
        
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
//提示
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
#pragma mark - Model解析
- (void)analySisApprovalProcessModel:(ApprovalProcessModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        [ApprovalProgressTableView.mj_header endRefreshing];
        [dataArray addObjectsFromArray:model.body];
        if (dataArray.count>0) {
            nodeStr = model.body[0].wfiNodeName;
            headerView.hidden = NO;
            nodeLabel.text = [NSString stringWithFormat:@"审批节点：%@",nodeStr];
            NSString *stateStr = [[NSString alloc]init];
            if ([model.body[0].appConclusion isEqualToString:@"10"]) {
                stateStr = @"同意";
            }else if ([model.body[0].appConclusion isEqualToString:@"11"]) {
                stateStr = @"转办";
            }else if ([model.body[0].appConclusion isEqualToString:@"20"]) {
                stateStr = @"拒绝";
            }else if ([model.body[0].appConclusion isEqualToString:@"21"]) {
                stateStr = @"协办";
            }else if ([model.body[0].appConclusion isEqualToString:@"30"]) {
                stateStr = @"打回";
            }else if ([model.body[0].appConclusion isEqualToString:@"31"]) {
                stateStr = @"催办";
            }else if ([model.body[0].appConclusion isEqualToString:@"40"]) {
                stateStr = @"退回";
            }else if ([model.body[0].appConclusion isEqualToString:@"50"]) {
                stateStr = @"补件";
            }else if ([model.body[0].appConclusion isEqualToString:@"60"]) {
                stateStr = @"拿回";
            }else if ([model.body[0].appConclusion isEqualToString:@"61"]) {
                stateStr = @"追回";
            }else if ([model.body[0].appConclusion isEqualToString:@"70"]) {
                stateStr = @"撤办";
            }else if ([model.body[0].appConclusion isEqualToString:@"80"]) {
                stateStr = @"挂起";
            }else if ([model.body[0].appConclusion isEqualToString:@"90"]) {
                stateStr = @"唤醒";
            }else if ([model.body[0].appConclusion isEqualToString:@"91"]) {
                stateStr = @"激活";
            }else if ([model.body[0].appConclusion isEqualToString:@"92"]) {
                stateStr = @"取消";
            }else if ([model.body[0].appConclusion isEqualToString:@"93"]) {
                stateStr = @"疑似欺诈";
            }else if ([model.body[0].appConclusion isEqualToString:@"99"]) {
                stateStr = @"转人工审批";
            }
            stateLabel.text = [NSString stringWithFormat:@"审批状态：%@",stateStr];
            NSString *reasonStr =model.body[0].appConclusionDesc;
            reasonLabel.text = [NSString stringWithFormat:@"拒绝原因：%@",reasonStr];
            [dataArray removeObjectAtIndex:0];
            [ApprovalProgressTableView reloadData];
        }
        
      
    }else{
        [ApprovalProgressTableView.mj_header endRefreshing];
        [self buildHeadError:model.head.retMsg];
    }
}

#pragma mark - private methods
-(void)loadData{
    
    if (_applseq.length>0) {
        [self creatDataArray];
    }else{
        [self getMoneySpeed];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
