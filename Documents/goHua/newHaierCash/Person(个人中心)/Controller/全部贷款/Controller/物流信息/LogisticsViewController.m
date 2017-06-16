//
//  LogisticsViewController.m
//  物流信息
//
//  Created by 史长硕 on 2017/4/14.
//  Copyright © 2017年 史长硕. All rights reserved.
//

#import "LogisticsViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "LogisticsView.h"
#import "LogisticsTableViewCell.h"
#import "BSVKHttpClient.h"
#import <MBProgressHUD.h>
#import "TimeActonModel.h"
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
static CGFloat const GetLogisticsInfo = 100;//获取订单物流信息
@interface LogisticsViewController ()<UITableViewDelegate,UITableViewDataSource,BSVKHttpClientDelegate>
{
    
    LogisticsView *_headerView;//头部视图
    
    UITableView *_logisticsTable;//物流表视图
    
    NSMutableArray *_dataArray;//数据数组
    
    float x ;

    float _height;//单元格高度
    
}

@end

@implementation LogisticsViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"物流信息";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (iphone6P) {
        
        x = 1;
        
    }else{
        
        x = scaleAdapter;
    }

    _dataArray = [NSMutableArray new];
    
    [self buildGetLogisticsDetail];
    
    [self setNavi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> private Methods
//设置导航
- (void)setNavi
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = ReturnRect;
    [backBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(OnBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
// 返回
- (void)OnBackBtn:(UIButton *)btn{
    [AppDelegate delegate].userInfo.bReturn = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
//创建头部视图
-(void)creatHederViewHidden:(BOOL)hidden{
    
    if (hidden) {
      
        _headerView = [[LogisticsView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 145*x)];
        
        _headerView.backgroundColor = [UIColor whiteColor];

        [self.view addSubview:_headerView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 65 * x + (DeviceHeight-64-50)/2 , DeviceWidth, 50)];
        
        label.text = @"暂无物流信息~请稍后再试吧~";
        
        label.font = [UIFont appFontRegularOfSize:20];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.textColor = [UIColor lightGrayColor];
        
        [self.view addSubview:label];
        
    }else{
      
        _headerView = [[LogisticsView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 145*x)];
        
        _headerView.backgroundColor = [UIColor whiteColor];
        
    }
    
    
}

//创建表视图

-(void)creatlogisticsTable{
    
    _logisticsTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64)style:UITableViewStylePlain];
    
    _logisticsTable.backgroundColor = [UIColor whiteColor];
    
    _logisticsTable.showsVerticalScrollIndicator = NO;
    
    _logisticsTable.dataSource = self;
    
    _logisticsTable.delegate =self;
    
    _logisticsTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _logisticsTable.tableHeaderView = _headerView;
    
    _logisticsTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_logisticsTable];
    
}

#pragma mark --> tableView代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LogisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jack"];
    
    if (!cell) {
        
        cell = [[LogisticsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jack"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    TimeActionDetail *detail = _dataArray[indexPath.row];
    
    
   _height = [cell insertLogisticsModel:detail number:indexPath.row];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _height;
    
}

#pragma mark --> 发起的网络请求

//获取物流信息
-(void)buildGetLogisticsDetail{
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [client getInfo:[NSString stringWithFormat:@"app/appserver/order/%@/sg/logisticsInfo",StringOrNull( _orderNo)] requestArgument:nil requestTag:GetLogisticsInfo requestClass:NSStringFromClass([self class])];
    
}

#pragma mark --> 网络代理协议

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == GetLogisticsInfo) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            TimeActonModel *model = [TimeActonModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleInfoModel:model];
        }
        
    }
    
}

-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(httpCode != 0){
            
            [self buildHeadError:[NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode]];
            
        }else{
            
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

#pragma mark --> 网络请求成功后的处理逻辑

//处理物流信息
-(void)buildHandleInfoModel:(TimeActonModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        if (model.body.lesShippingInfosList.count > 0) {
            
            for (int index = 0; index < model.body.lesShippingInfosList.count; index ++) {
                TimeActionDetail *detail  = model.body.lesShippingInfosList[0];
                if (detail.nodeTime.length > 0 || detail.nodeDesc.length > 0) {
                    [_dataArray addObject:detail];
                }
            }
            
            if (_dataArray.count <= 0) {
              
                [self creatHederViewHidden:YES];
                
            }else{
              
                [self creatHederViewHidden:NO];
                
                [self creatlogisticsTable];
                
            }
            
            TimeActionDetail *detail = model.body.lesShippingInfosList[0];
            
            _headerView.officeLabel.text = [NSString stringWithFormat:@"物流公司：%@",detail.expressName];
            
            _headerView.numberLabel.text = [NSString stringWithFormat:@"快递单号：%@",detail.invoiceNumber];
           
            
        }else{
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (DeviceHeight-64-50)/2, DeviceWidth, 50)];
            
            label.text = @"暂无物流信息~请稍后再试吧~";
            
            label.font = [UIFont appFontRegularOfSize:20];
            
            label.textAlignment = NSTextAlignmentCenter;
            
            label.textColor = [UIColor lightGrayColor];
            
            [self.view addSubview:label];
            
        }
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

@end
