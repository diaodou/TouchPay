//
//  HCSpecialLoanController.m
//  newHaierCash
//
//  Created by Will on 2017/5/27.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCSpecialLoanController.h"
#import "HCMacro.h"

#import "HCSpecialLoanTableViewCell.h"
#import "HCEducationListController.h"
@interface HCSpecialLoanController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *exclusiveLoanTableView;
@property (nonatomic,strong) NSMutableArray * titleArray;      //标题数组
@property (nonatomic,strong) NSMutableArray * introduceArray;  //介绍数组
@property (nonatomic,strong) NSMutableArray * imageArray;      //图片数组
@property (nonatomic,strong) NSMutableArray * applyArray;      //立即申请

@end

@implementation HCSpecialLoanController
#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"大额专享";

    [self setUI];
    
    [self setData];
    
    [self setFootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - private Methods
- (void)setUI{

    _exclusiveLoanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 114) style:UITableViewStylePlain];
    _exclusiveLoanTableView.delegate = self;
    _exclusiveLoanTableView.dataSource = self;
    _exclusiveLoanTableView.showsVerticalScrollIndicator = NO;
    _exclusiveLoanTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _exclusiveLoanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_exclusiveLoanTableView];
}
- (void)setFootView{

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 9)];
    if (iphone6P) {
        view.frame = CGRectMake(0, 0, DeviceWidth, 10);
    }
    view.backgroundColor = [UIColor whiteColor];
    
    _exclusiveLoanTableView.tableFooterView = view;
}
- (void)setData{

    _titleArray = [[NSMutableArray alloc]initWithObjects:@"0首付家电分期",@"教育分期",@"旅游分期",@"商用冷柜分期",nil];
    _introduceArray = [[NSMutableArray alloc]initWithObjects:@"海尔专卖店分期专享，提前家电带回家",@"先上课，后付费，充电永不停止",@"身体和心灵，总有一个在路上，0元出发",@"产业与金融结合，一起赚钱", nil];
    _imageArray = [[NSMutableArray alloc]initWithObjects:@"a1.JPG",@"a2.JPG",@"a3.JPG",@"a4.JPG",nil];
    _applyArray = [[NSMutableArray alloc]initWithObjects:@"家电分期",@"教育分期",@"旅游分期",@"冷柜分期", nil];
    
}
#pragma mark - custom Methods
- (void)applianceStaging{

    NSLog(@"家电分期");
}
- (void)educationStages{

    NSLog(@"教育分期");
}
- (void)tourismStaging{

    NSLog(@"旅游分期");
}
- (void)commercialStaging{

    NSLog(@"商用冷柜分期");
}
#pragma mark - tableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iphone6P) {
        
        return 152;
    }else{
    
        return 138;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCSpecialLoanTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        
        cell = [[HCSpecialLoanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.titleLabel.text = _titleArray[indexPath.row];
    cell.introduceLabel.text = _introduceArray[indexPath.row];
    cell.bottomImage.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    [cell.applyBtn setBackgroundImage:[UIImage imageNamed:_applyArray[indexPath.row]] forState:UIControlStateNormal];
    
    if (indexPath.row == 0) {
        cell.titleLabel.textColor = UIColorFromRGB(0xfff5d4, 1.0);
        [cell.applyBtn addTarget:self action:@selector(applianceStaging) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.row == 1){
        cell.titleLabel.textColor = UIColorFromRGB(0xcefcef, 1.0);
        [cell.applyBtn addTarget:self action:@selector(educationStages) forControlEvents:UIControlEventTouchUpInside];
    }else if (indexPath.row == 2){
        cell.titleLabel.textColor = UIColorFromRGB(0xd9eafe, 1.0);
        [cell.applyBtn addTarget:self action:@selector(tourismStaging) forControlEvents:UIControlEventTouchUpInside];
    }else{
        cell.titleLabel.textColor = UIColorFromRGB(0xd6f2ff, 1.0);
        [cell.applyBtn addTarget:self action:@selector(commercialStaging) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //教育分期二级页面
    HCEducationListController *con = [HCEducationListController new];
    con.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:con animated:YES];
    
    
}
@end
