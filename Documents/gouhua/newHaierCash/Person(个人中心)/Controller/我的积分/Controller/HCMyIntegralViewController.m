//
//  HCMyIntegralViewController.m
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMyIntegralViewController.h"
#import "UIFont+AppFont.h"
#import "HCMacro.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "IntegralTableViewCell.h"
#import "UILabel+SizeForStr.h"
static CGFloat const GetIntegral = 110;//请求我的积分
@interface HCMyIntegralViewController ()<UITableViewDelegate,UITableViewDataSource,BSVKHttpClientDelegate>

{
    
    float x;//适配比例
    
}

@property(nonatomic,strong)UITableView *integralTable;//积分表视图

@property(nonatomic,strong)NSMutableArray *modelArray;//数据数组

@property(nonatomic,strong)UIView *headerView;   //头部视图

@property(nonatomic,strong)UILabel *integralLabel;    //积分label

@end
#pragma mark --> life Cycle
@implementation HCMyIntegralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title = @"我的积分";
    
    self.view.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self creatHederView];
    
    [self creatIntegralTable];
    
    [self buildGetIntegralHttp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --> private Methods

//创建头部视图
-(void)creatHederView{
    
    if (iphone6P) {
        
        x = scale6PAdapter;
        
    }else{
        
        x = scaleAdapter;
        
    }
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 178*x)];
    
    _headerView.backgroundColor = UIColorFromRGB(0xeeeeee, 1.0);

    
   UIImageView *headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 132*x)];
    
    headerImg.image = [UIImage imageNamed:@"渐变背景"];
    
    [_headerView addSubview:headerImg];
    
    UILabel *warnLab = [[UILabel alloc]initWithFrame:CGRectMake(40*x, 20*x, DeviceWidth-40*x, 20*x)];
    
    warnLab.text = @"当前可用积分:";
    
    warnLab.font = [UIFont appFontRegularOfSize:12*x];
    
    warnLab.textColor = [UIColor whiteColor];
    
    [_headerView addSubview:warnLab];
    
    _integralLabel = [[UILabel alloc]initWithFrame:CGRectMake(40*x, 41*x, 200*x, 48*x)];
    
    _integralLabel.font = [UIFont appFontRegularOfSize:42*x];
    
    _integralLabel.textColor = [UIColor whiteColor];
    
    _integralLabel.text = @"5000";
    
    [_headerView addSubview:_integralLabel];
    
    UIButton *recordBtn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth-105*x, 81*x, 80*x, 30*x)];
    
    recordBtn.layer.cornerRadius = 15*x;
    
    recordBtn.backgroundColor = UIColorFromRGB(0x32beff, 1.0);
    
    [recordBtn setTitle:@"收支记录" forState:UIControlStateNormal];
    
    recordBtn.titleLabel.font = [UIFont appFontRegularOfSize:14*x];
    
    [recordBtn addTarget:self action:@selector(buildTouchRecordAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [recordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_headerView addSubview:recordBtn];
    
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 144*x, DeviceWidth, 34*x)];
    
    whiteView.backgroundColor = [UIColor whiteColor];
    
    [_headerView addSubview:whiteView];
    
    UIImageView *inteImg = [[UIImageView alloc]init];
    
    inteImg.image = [UIImage imageNamed:@"积分权益"];
    
    [whiteView addSubview:inteImg];
    
    UILabel *titleLab = [[UILabel alloc]init];
    
    titleLab.font = [UIFont appFontRegularOfSize:14*x];
    
    titleLab.textColor = UIColorFromRGB(0x32beff, 1.0);
    
    titleLab.text = @"积分权益";
    
    CGSize size = [titleLab boundingRectWithSize:CGSizeMake(NSIntegerMax, 40*x)];
    
    inteImg.frame = CGRectMake((DeviceWidth-26*x-size.width)/2, 10*x, 14*x, 14*x);
    
    titleLab.frame = CGRectMake((DeviceWidth-26*x-size.width)/2+26*x, 0, size.width, 34*x);
    
    [whiteView addSubview:titleLab];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 33.5*x, DeviceWidth, 0.5*x)];
    
    lineView.backgroundColor = UIColorFromRGB(0xdddddd, 1.0);
    
    [whiteView addSubview:lineView];
}

//创建表视图
-(void)creatIntegralTable{
    
    _integralTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64) style:UITableViewStylePlain];
    
    _integralTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _integralTable.showsVerticalScrollIndicator = NO;
    
    _integralTable.delegate = self;
    
    _integralTable.tableHeaderView = _headerView;
    
    _integralTable.dataSource = self;
    
    [self.view addSubview:_integralTable];
    
}

#pragma mark --> event Methods
//点击收支记录
-(void)buildTouchRecordAction:(UIButton *)sender{
    
    
}

#pragma mark --> table代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return _modelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IntegralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kill"];
    
    if (cell == nil) {
        
        cell = [[IntegralTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kill"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    [cell insertModelInfo:_modelArray[indexPath.row]];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100*x;
    
}

#pragma mark --> 发起网络请求

//请求我的积分
-(void)buildGetIntegralHttp{
    
//    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
//    
//    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
//    
//    client.delegate = self;
//    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _modelArray = [[NSMutableArray alloc]init];
    
    for (int i =0; i<5; i++) {
        
        IntegralBody *body = [[IntegralBody alloc]init];
        
        body.name = @"5元还款优惠券";
        
        body.secne = @"贷款满1000时使用";
        
        body.money = @"6000";
        
        [_modelArray addObject:body];
        
    }
    
    [_integralTable reloadData];
    
}

#pragma mark --> 网络代理协议

-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == GetIntegral) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            IntegralModel *model = [IntegralModel mj_objectWithKeyValues:responseObject];
            
            [self buildHandleIntegralModel:model];
            
        }
        
    }
    
}

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

#pragma mark --> 处理网络请求成功后的逻辑
-(void)buildHandleIntegralModel:(IntegralModel *)model{
    
    if ([model.head.retFlag isEqualToString:@"00000"]) {
        
        
        
    }else{
        
        [self buildHeadError:model.head.retMsg];
        
    }
    
}

#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_integralTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [_integralTable setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_integralTable respondsToSelector:@selector(setLayoutMargins:)]) {
        [_integralTable setLayoutMargins:UIEdgeInsetsZero];
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
