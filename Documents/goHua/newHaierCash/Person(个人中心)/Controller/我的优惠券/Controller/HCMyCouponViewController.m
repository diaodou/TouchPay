//
//  HCMyCouponViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/8.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMyCouponViewController.h"
#import "HCChoiceTopView.h"
#import "HCMacro.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "UIFont+AppFont.h"
#import "CouponTableViewCell.h"
#import <MJRefresh.h>
static CGFloat const GetUseCouponHttp = 110;//请求可使用优惠券
static CGFloat const GetHasCouponHttp = 120;//请求已使用优惠券
static CGFloat const GetNoTimeCouponHttp = 130;//请求已使用优惠券
@interface HCMyCouponViewController ()<UITableViewDelegate,UITableViewDataSource,SendChoiceTypeDelegate,BSVKHttpClientDelegate>

{
    
    float x;
    
}

@property(nonatomic,strong)HCChoiceTopView *choiceView;//顶部选择视图

@property(nonatomic,strong)UITableView *couponTable;//优惠券展示table

@property(nonatomic,strong)NSMutableArray *modelArray;//数据数组

@end

@implementation HCMyCouponViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"我的优惠券";
    
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    [self creatDataArray];
    
    [self creatTopView];
    
    [self creatShowTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> private Methods

-(void)creatDataArray{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
        
    }
    
    _modelArray = [[NSMutableArray alloc]init];
    
    for (int i =0; i<4; i++) {
        
        CouponBody *body = [[CouponBody alloc]init];
        
        if (i == 0) {
            
            body.imgType = @"已使用";
            
             body.type = @"兑换券";
            
             body.name = @"兑换券";
            
        }else{
            
            body.imgType = @"可使用";
            
            body.type = @"免息券";
            
            body.name = @"免息券";
        }
        
        body.money = @"100";
        
        body.time = @"2017-08-19";
        
        body.condition = @"贷款慢500可用";
       
        body.scene = @"现金分期可用";
        
        [_modelArray addObject:body];
    }
    
}

//创建顶部选择视图
-(void)creatTopView{
    
    _choiceView = [[HCChoiceTopView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50*x)];
    
    _choiceView.nameArray = @[@"可使用",@"已过期",@"已使用"];
    
    _choiceView.delegate = self;
    
    _choiceView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_choiceView];
    
}

//创建表视图
-(void)creatShowTable{
    
    _couponTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, DeviceWidth, DeviceHeight-64-50*x) style:UITableViewStylePlain];
    
    _couponTable.showsVerticalScrollIndicator = NO;
    
    _couponTable.delegate = self;
    
    _couponTable.dataSource = self;
    
    _couponTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _couponTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _couponTable.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    _couponTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(buildRefreshAction)];
    
    [self.view addSubview:_couponTable];
    
}

#pragma mark --> event Methods

//下拉刷新方法
-(void)buildRefreshAction{
    
    
    
}

#pragma mark --> table代理协议

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _modelArray.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rose"];
    
    if (cell == nil) {
    
        cell = [[CouponTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rose"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    [cell insertModelInfo:_modelArray[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (iphone6P) {
        
        return 123*x;
        
    }else{
        
        return 102*x;
        
    }
    
}

#pragma mark -->顶部视图选择代理

-(void)sendChoiceType:(NSInteger)type{
    
    
}

#pragma mark --> 网络代理协议
//连接成功
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == GetUseCouponHttp) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }else if (requestTag == GetHasCouponHttp){
            
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }else if (requestTag == GetNoTimeCouponHttp){
            
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }
        
    }
    
}
//连接失败
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *errorStr;
        
        if(httpCode  != 0)
        {
            errorStr = [NSString stringWithFormat:@"网络环境异常，请检查网络并重试(%ld)",(long)httpCode ];
        }
        else
        {
            errorStr = @"网络环境异常，请检查网络并重试";
        }
        
        [self buildHeadError:errorStr];
        
    }
    
}

//连接服务器成功后，返回的报文头信息
-(void)buildHeadError:(NSString *)error{
    
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:error cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                return;
            }
        }
    }];
    
}


@end
