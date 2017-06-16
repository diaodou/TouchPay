//
//  HelpViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/16.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "HelpViewController.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "FeedbackViewController.h"
#import "BSVKHttpClient.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "HelpDetailViewController.h"

#import "HelpCustModel.h"
@interface HelpViewController ()<UITableViewDataSource,UITableViewDelegate,BSVKHttpClientDelegate>

{
    
    UITableView *_questionTable;//问题列表
    
    UIButton    *_feedBackBtn;//意见反馈按钮;
    
    UIView *_footView;//足部视图
    
    UIView *_headerView;//头部视图
    
    NSMutableArray *_dataArray;
    
    float x;//屏幕比例适配
    
    
}

@end

@implementation HelpViewController

#pragma mark --> life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationItem.title = @"帮助中心";
    
    x = DeviceWidth/375.0;
    
    _dataArray = [[NSMutableArray alloc]init];
 
    [self creatHeaderView];
    
    [self creatQuestionTable];
    
    [self creatFeedBackBtn];
    
    [self creatDataArray];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
}
#pragma mark --> private Methods

//创建意见反馈按钮
-(void)creatFeedBackBtn{

    _footView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight - 128, DeviceWidth, 64)];

    _footView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    _feedBackBtn = [[UIButton alloc]init];
    if (iphone6P) {
        _feedBackBtn.frame = CGRectMake(48, 10, DeviceWidth-96, 50);
        _feedBackBtn.layer.cornerRadius = 25.f;
    }else{
        _feedBackBtn.frame=CGRectMake(48, 10, DeviceWidth-96, 45);
        _feedBackBtn.layer.cornerRadius = 22.5f;
    }
    _feedBackBtn.backgroundColor=UIColorFromRGB(0x32beff, 1);
    
    [_feedBackBtn setTitle:@"意见反馈" forState:UIControlStateNormal];
    
    [_feedBackBtn addTarget:self action:@selector(creatFeedBackAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_footView addSubview:_feedBackBtn];
    
    [self.view addSubview:_footView];
}

//创建头部视图
-(void)creatHeaderView{
    
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50*x)];
    _headerView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 5*x, DeviceWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xf8f8f8, 1.0);
    [_headerView addSubview:lineView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 8*x, DeviceWidth-100, 30)];
    label.text = @"常见问题";
    label.font = [UIFont systemFontOfSize:14];
    [lineView addSubview:label];
    
    
}
//创建问题列表表示图
-(void)creatQuestionTable{
    
    _questionTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight- 128) style:UITableViewStylePlain];
    
    _questionTable.delegate = self;
    
    _questionTable.dataSource = self;
    
    _questionTable.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    _questionTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _questionTable.showsVerticalScrollIndicator = NO;
    
    _questionTable.tableHeaderView = _headerView;
    
    _questionTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_questionTable];
    
    
}


#pragma mark --> event Methods

-(void)creatFeedBackAction:(UIButton *)sender{
    
    FeedbackViewController *co = [[FeedbackViewController alloc]init];
    [self.navigationController pushViewController:co animated:YES];
    
}



#pragma mark --> tableView的代理方法


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *gucci = @"gucci_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:gucci];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gucci];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView *ligthView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, DeviceWidth, 1)];
        
        ligthView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
        
        [cell.contentView addSubview:ligthView];
        
        UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(20,0, DeviceWidth-47,45)];
        
        nameLab.tag = 12;
        
        nameLab.numberOfLines = 0;
        
        nameLab.textColor = UIColorFromRGB(0x232326, 1.0);
        
        nameLab.font = [UIFont appFontRegularOfSize:15];
        
        [cell.contentView addSubview:nameLab];
        
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(DeviceWidth-27, 14, 10, 15)];
        
        img.image  = [UIImage imageNamed:@"灰色箭头"];
        
        img.tag = 12;
        
        [cell.contentView addSubview:img];
    }
    
    UILabel *label1 = (UILabel *)[cell.contentView viewWithTag:12];
    
    HelpData *data = _dataArray[indexPath.row];
    
    label1.text = [NSString stringWithFormat:@"%@、%@",data.rownum,data.helpTitle];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HelpData *data = _dataArray[indexPath.row];
    
    HelpDetailViewController *helpVc = [[HelpDetailViewController alloc]init];
    
    helpVc.dataModel = data;
    
    [self.navigationController pushViewController:helpVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    
    
    [super didReceiveMemoryWarning];
    
    
}




//请求数据
-(void)creatDataArray{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *park = [[NSMutableDictionary alloc]init];
    
    [park setObject:@"customer" forKey:@"helpType"];
    
    [park setObject:@"30" forKey:@"limit"];
    
    [park setObject:@"0" forKey:@"offset"];
    
    BSVKHttpClient *client = [BSVKHttpClient shareInstance];
    
    client.delegate = self;
    
    [client getInfo:@"app/appmanage/help/pageByHelpType" requestArgument:park requestTag:10 requestClass:NSStringFromClass([self class])];
    
    
}

#pragma mark --> 网络代理协议
-(void)requestSucess:(NSInteger)requestTag requestResult:(id)responseObject requestClass:(NSString *)className{
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
        if (requestTag == 10) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            HelpCustModel *model = [HelpCustModel mj_objectWithKeyValues:responseObject];
            
            if ([model.head.retFlag isEqualToString:@"00000"]) {
                
                if (model.body.data.count > 0) {
                    
                    [_dataArray addObjectsFromArray:model.body.data];
                    
                    
                    [_questionTable reloadData];
                }
                
            }else{
                
                [self buildHeadError:model.head.retMsg];
                
            }
        }
    }
}

//返回的错误信息
-(void)requestFail:(NSInteger)requestTag requestError:(NSError *)error httpCode:(NSInteger)httpCode requestClass:(NSString *)className{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    if ([className isEqualToString:NSStringFromClass([self class])]) {
        
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
                nil;
            }
        }
    }];
    
    
}



@end
