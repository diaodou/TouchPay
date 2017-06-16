//
//  HCMerchandiseController.m
//  newHaierCash
//
//  Created by Will on 2017/5/27.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMerchandiseController.h"
#import "HCChoiceTopView.h"
#import "HCMacro.h"
#import "AppDelegate.h"
#import "UnlockAccountViewController.h"
#import "MerchTableViewCell.h"
#import "WareDetailViewController.h"
@interface HCMerchandiseController ()<SendChoiceTypeDelegate,UITableViewDelegate,UITableViewDataSource>

{
    
    HCChoiceTopView *_choiceTopView;//顶部选择视图
    
    float _height;
    
}

@property(nonatomic,strong)UITableView *merchTable;//商品展示视图

@property(nonatomic,strong)NSMutableArray *dataArray;//数据数组

@end

@implementation HCMerchandiseController
#pragma mark --> life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"精选商品";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _height = 100;
    
    [self creatChoiceTopView];
    
    [self creatData];
    
    [self creatMerchTable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --> priavte Methods
//创建顶部选择视图
-(void)creatChoiceTopView{
    
    _choiceTopView = [[HCChoiceTopView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 45)];
    
    _choiceTopView.delegate = self;
    
    _choiceTopView.nameArray = @[@"全部",@"精品",@"家电",@"旅游"];
    
    [self.view addSubview:_choiceTopView];
    
}

//创建商品展示视图
-(void)creatMerchTable{
    
    _merchTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 45, DeviceWidth, DeviceHeight-153) style:UITableViewStylePlain];
    
    _merchTable.delegate = self;
    
    _merchTable.dataSource = self;
    
    _merchTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    _merchTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _merchTable.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_merchTable];
    
}

//创建数据
-(void)creatData{
    
    _dataArray = [[NSMutableArray alloc]init];
    
    for (int i =0; i<6; i++) {
        
        HCMerchBody *body = [[HCMerchBody alloc]init];
        
        body.name = @"不要脸";
        
        if (i == 1) {
            
            body.option = @"结算时老师上课书框框思考思考思考思考思考思考思考开始看是可是商家商家商家商家商家商家就是就是";
            
        }else{
            
            body.option = @"臭狗熊";
            
        }
        
        [_dataArray addObject:body];
        
        
    }
    
}

-(void)buildToPerson{
    
    UnlockAccountViewController *hc = [[UnlockAccountViewController alloc]init];
    
    [AppDelegate delegate].userInfo.busFlowName = QuotaApply;
    
    hc.showType = ShowPerAndFaceInfo;
    
    hc.startType = FromFace;
    
    hc.personInfoSuccess = YES;
    
    hc.faceInfoSuccess = FaceNotDo;
    
    hc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:hc animated:YES];
    
//    WareDetailViewController *wareVc = [[WareDetailViewController alloc]init];
//    
//    wareVc.hidesBottomBarWhenPushed = YES;
//    
//    wareVc.goodsCode = @"2310557";
//    
//    wareVc.ifOnLine = YES;
//    
//    [self.navigationController pushViewController:wareVc animated:YES];
    
}

#pragma mark --> table代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MerchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jack"];
    
    if (cell == nil) {
        
        cell = [[MerchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"jack"];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    HCMerchBody *body = _dataArray[indexPath.row];
    
    _height = [cell insertMerchModel:body];
    
    return cell;
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _height;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self buildToPerson];
    
}
#pragma mark --> 顶部选择视图代理方法

-(void)sendChoiceType:(ChoiceType)type{
    
    NSLog(@"%ld",(long)type);
    
}

@end
