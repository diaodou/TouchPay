//
//  BorrowingMethodsViewController.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/6.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCBorrowingMethodsViewController.h"
#import "HCMacro.h"
#import "NSString+CheckConvert.h"
#import "UIFont+AppFont.h"

#import "HCBorrowingMethodsTableViewCell.h"
@interface HCBorrowingMethodsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *typeTableView;         //表
@property (nonatomic, strong)NSMutableArray * timeArray;     //时间数据
@property (nonatomic, strong)NSMutableArray * typeArray;     //方式数据
@property (nonatomic, strong)NSMutableArray * interestArray; //利息数据

@end

@implementation HCBorrowingMethodsViewController
#pragma mark - lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"怎么还";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setLineView];
    [self setTableView];
    [self setDictionary];
    [self setNavi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Methods
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
- (void)setLineView{
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, .5)];
    lineView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self.view addSubview:lineView];
}
- (void)setTableView{

    self.typeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    self.typeTableView.delegate = self;
    self.typeTableView.dataSource = self;
    self.typeTableView.showsVerticalScrollIndicator = NO;
    self.typeTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.typeTableView];
}
- (void)setDictionary{

    _timeArray = [[NSMutableArray alloc]initWithObjects:@"90天",@"6期",@"12期", nil];
    _typeArray = [[NSMutableArray alloc]initWithObjects:@"随借随还",@"按期还本付费",@"按期还本付费", nil];
    _interestArray = [[NSMutableArray alloc]initWithObjects:@"0.04%/天",@"0.65%/月",@"0.65%/月", nil];
}
// 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([self.typeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.typeTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.typeTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.typeTableView setLayoutMargins:UIEdgeInsetsZero];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.typeTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_choiceCashloanTypedelegate && [_choiceCashloanTypedelegate respondsToSelector:@selector(choiceCashLoanType:)]) {
        
        [_choiceCashloanTypedelegate choiceCashLoanType:[NSString stringWithFormat:@"%@%@",_timeArray[indexPath.row],_typeArray[indexPath.row]]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - private Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _timeArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (iphone6P) {
        
        return 72;
    }else{
    
        return 65;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HCBorrowingMethodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        
        cell = [[HCBorrowingMethodsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    cell.timeLabel.text = _timeArray[indexPath.row];
    cell.typeLabel.text = _typeArray[indexPath.row];
    cell.interestLabel.text = _interestArray[indexPath.row];
    return cell;
}
@end
