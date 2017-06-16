//
//  PayHistoryViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/18.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "PayHistoryViewController.h"
#import "PayHistoryTableViewCell.h"
#import "HCMacro.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "RepaymentHistoryModel.h"
#import <MJExtension.h>
#import "AppDelegate.h"
#import <MJRefresh.h>
#import "MJRefreshGifHeader.h"
#import "UIFont+AppFont.h"
@interface PayHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,BSVKHttpClientDelegate>
{
    UITableView *PayTableView ;
    
    NSMutableArray *styleArray;//还款方式
    NSMutableArray *timeArray;//时间
    NSMutableArray *moneyArray;//钱数
    NSMutableArray *stateArray;//状态
    NSString *idNo;// 身份证号
    NSInteger page; // 页码
    NSMutableArray *dataArray1; //临时数据
    NSMutableArray *dataArray2;//临时数据
    NSMutableArray *dataArray3;
    NSMutableArray *dataArray;
    NSMutableArray *titleArray;
    CGFloat _viewScale;//适配比例

}
@property(nonatomic,strong)NSMutableArray *cellArray;
@end

@implementation PayHistoryViewController
#pragma mark -lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"还款记录";
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;

    
    dataArray1 = [[NSMutableArray alloc] initWithObjects:@"代扣", @"交存", @"还款", nil];//临时数据
    
    dataArray2 = [[NSMutableArray alloc] initWithObjects:@"代扣", @"交存", @"还款", @"定期", nil];//临时数据
    
    dataArray3 = [[NSMutableArray alloc]initWithObjects:@"定期", nil];
    
    titleArray = [[NSMutableArray alloc] initWithObjects:@"本月", @"3月",@"2月", nil];//临时数据
    
    dataArray = [[NSMutableArray alloc]initWithObjects:dataArray1,dataArray2,dataArray3, nil];
    
    [self UItableView];
   
    [self setNavi];
    
    page = 1;
    //6.49 检测查询还款记录接口
//    [self setRepaymentHistory];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void)UItableView{
    PayTableView = [[UITableView alloc]initWithFrame: CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64)];
    PayTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    PayTableView.delegate = self;
    PayTableView.dataSource = self;
    PayTableView.backgroundColor = UIColorFromRGB(0xeeeeee, 1);
    //    PayTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    //    PayTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [PayTableView registerClass:[PayHistoryTableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:PayTableView];
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
#pragma mark -- tableView delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 34*_viewScale)];
    
    view.backgroundColor = UIColorFromRGB(0xeeeeee, 1);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20*_viewScale, 2*_viewScale, 100*_viewScale, 30*_viewScale)];
    
    label.textColor = UIColorFromRGB(0x666666, 1);
    
    label.font = [UIFont appFontRegularOfSize:11];
    
    label.text = [titleArray objectAtIndex:section];
    
    [view addSubview:label];
    
    return view;
    
}

//指定有多少个分区

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [titleArray count];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSArray *array = [dataArray objectAtIndex:section];
    
    return [array count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 34*_viewScale;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 72*_viewScale;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString *cellID = @"cellID";
    PayHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

    if (indexPath.row == 0) {
        cell.returnMoneyLabel.text = dataArray1[indexPath.row];
        if ([cell.returnMoneyLabel.text isEqualToString:@"代扣"]) {
            cell.returnMoneyLabel.textColor = UIColorFromRGB(0xf15a4a, 1);
        }else if ([cell.returnMoneyLabel.text isEqualToString:@"交存"]){
            cell.returnMoneyLabel.textColor = UIColorFromRGB(0x3eddb2, 1);
        }else if ([cell.returnMoneyLabel.text isEqualToString:@"还款"]){
            cell.returnMoneyLabel.textColor = UIColorFromRGB(0xfda253, 1);
        }else if ([cell.returnMoneyLabel.text isEqualToString:@"定期"]){
            cell.returnMoneyLabel.textColor = UIColorFromRGB(0x32beff, 1);
        }else{
             cell.returnMoneyLabel.textColor = UIColorFromRGB(0x999999, 1);
        }
        cell.timeLabel.text = @"2015-08-14";
        cell.moneyLabel.text = @"5000";
        cell.stateLabel.text = @"成功";
        cell.typeImageView.image = [UIImage imageNamed:dataArray1[indexPath.row]];
    }else{
        cell.returnMoneyLabel.text = dataArray2[indexPath.row];
        if ([cell.returnMoneyLabel.text isEqualToString:@"代扣"]) {
            cell.returnMoneyLabel.textColor = UIColorFromRGB(0xf15a4a, 1);
        }else if ([cell.returnMoneyLabel.text isEqualToString:@"交存"]){
            cell.returnMoneyLabel.textColor = UIColorFromRGB(0x3eddb2, 1);
        }else if ([cell.returnMoneyLabel.text isEqualToString:@"还款"]){
            cell.returnMoneyLabel.textColor = UIColorFromRGB(0xfda253, 1);
        }else if ([cell.returnMoneyLabel.text isEqualToString:@"定期"]){
            cell.returnMoneyLabel.textColor = UIColorFromRGB(0x32beff, 1);
        }else{
            cell.returnMoneyLabel.textColor = UIColorFromRGB(0x999999, 1);
        }
        cell.timeLabel.text = @"2015-08-14";
        cell.moneyLabel.text = @"5000";
        cell.stateLabel.text = @"成功";
        cell.typeImageView.image = [UIImage imageNamed:dataArray2[indexPath.row]];
    }
    

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [PayTableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([PayTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [PayTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([PayTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [PayTableView setLayoutMargins:UIEdgeInsetsZero];
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
#pragma mark -检测查询还款记录接口
- (void)setRepaymentHistory{
    
    // 在此处验证查询还款接口
    NSMutableDictionary *repaymentHistDict = [NSMutableDictionary dictionary];

    [repaymentHistDict setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    [repaymentHistDict setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [repaymentHistDict setObject:@"15" forKey:@"pageSize"];
    
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [client getInfo:@"app/appserver/cmis/querySetlList" requestArgument:repaymentHistDict requestTag:100 requestClass:NSStringFromClass([self class])];
}
#pragma mark - 下拉刷新
- (void)loadData{
    page = 1;
    NSMutableDictionary *repaymentHistDict = [NSMutableDictionary dictionary];
    [repaymentHistDict setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    [repaymentHistDict setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [repaymentHistDict setObject:@"15" forKey:@"pageSize"];
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appserver/cmis/querySetlList" requestArgument:repaymentHistDict requestTag:200 requestClass:NSStringFromClass([self class])];

}
#pragma mark - 上拉加载
- (void)loadMoreData{
    
    page = page + 1;
    
    NSMutableDictionary *repaymentHistDict = [NSMutableDictionary dictionary];
    [repaymentHistDict setObject:[AppDelegate delegate].userInfo.realId forKey:@"idNo"];
    [repaymentHistDict setObject:[NSString stringWithFormat:@"%zd",page] forKey:@"page"];
    [repaymentHistDict setObject:@"15" forKey:@"pageSize"];
    
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    
    [client getInfo:@"app/appserver/cmis/querySetlList" requestArgument:repaymentHistDict requestTag:300 requestClass:NSStringFromClass([self class])];

}
- (void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {

        if (requestTag == 100) {
            
                _repaymentHistoryModel = [RepaymentHistoryModel mj_objectWithKeyValues:responseObject];
                NSLog(@"%@",responseObject);
                if ([_repaymentHistoryModel.head.retFlag isEqualToString:@"00000"]) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    _cellArray = [[NSMutableArray alloc] init];
                    if (_repaymentHistoryModel.body.count != 0) {
                        [_cellArray addObjectsFromArray:_repaymentHistoryModel.body];
                        
                        [PayTableView reloadData];
                    }else {
                        WEAKSELF
                        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"暂无还款记录" cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                            STRONGSELF
                            if (buttonIndex == 0) {
                                [strongSelf backViewController];
                            }
                        }];
                    }
                    
                    [PayTableView.mj_header endRefreshing];
                    
                    
                }else {
                    NSString *str = _repaymentHistoryModel.head.retMsg;
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                    WEAKSELF
                    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:str cancelButtonTitle:@"我知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                        STRONGSELF
                        if (strongSelf) {
                            if (buttonIndex == 0) {
                                
                            }
                        }
                    }];
                    
                }

                }
    if (requestTag == 200) {
        
            _repaymentHistoryModel = [RepaymentHistoryModel mj_objectWithKeyValues:responseObject[@"response"]];
            NSLog(@"%@",responseObject);
            if ([_repaymentHistoryModel.head.retFlag isEqualToString:@"00000"]) {
                if (_repaymentHistoryModel.body!= nil ) {
                    if (_cellArray) {
                        [_cellArray removeAllObjects];
                    }else{
                        _cellArray = [[NSMutableArray alloc] init];
                    }
                    [_cellArray addObjectsFromArray:_repaymentHistoryModel.body];
                    [PayTableView reloadData];
                    [PayTableView.mj_header endRefreshing];
                    [PayTableView.mj_footer resetNoMoreData];
                
            }else{
                [PayTableView.mj_header endRefreshing];
                
            }
                
            }else{
              [PayTableView.mj_header endRefreshing];
               [PayTableView.mj_footer resetNoMoreData];
            }
    }

    if (requestTag == 300) {
        
            _repaymentHistoryModel = [RepaymentHistoryModel mj_objectWithKeyValues:responseObject[@"response"]];
            NSLog(@"%@",responseObject);
            if ([_repaymentHistoryModel.head.retFlag isEqualToString:@"00000"]) {
                if (_repaymentHistoryModel.body) {
                    
                    [_cellArray addObjectsFromArray:_repaymentHistoryModel.body];
                    [PayTableView reloadData];
                    [PayTableView.mj_footer endRefreshing];
                }else{
                    page --;
                     [PayTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
                
            }else {
                
                page --;
                [PayTableView.mj_footer endRefreshing];
                [PayTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }
}
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        NSLog(@"%@",error);
        
        NSLog(@"%ld",(long)requestTag);
        if (requestTag == 300) {
        
            page --;
        }
        [PayTableView.mj_header endRefreshing];
        [PayTableView.mj_footer endRefreshing];
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
- (void)backViewController{

    [self.navigationController popViewControllerAnimated:YES];
}
@end
