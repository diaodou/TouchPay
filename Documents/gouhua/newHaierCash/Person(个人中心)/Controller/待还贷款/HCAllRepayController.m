//
//  HCAllRepayController.m
//  newHaierCash
//
//  Created by Will on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"

#import <MJRefresh.h>

#import "HCAllRepayCell.h"
#import "HCAllRepayController.h"

@interface HCAllRepayController ()<UITableViewDataSource,UITableViewDelegate> {

    UIView *_lineView;
    UITableView *_allRepayTable;

    NSArray *_dataSource;
    CGFloat _viewScale;
}

@end

@implementation HCAllRepayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"全部待还";
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    self.view.backgroundColor = [UIColor UIColorWithHexColorString:TableView_BackColor AndAlpha:1];
    
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, thinLineHeight)];
    _lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_lineView];
    
    [self _createAllRepayTable];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];


}

#pragma mark - Private Method
//绘制UI
- (void)_createAllRepayTable {
    _allRepayTable = [[UITableView alloc] initWithFrame:CGRectMake(0, thinLineHeight, DeviceWidth, DeviceHeight- 64 - thinLineHeight) style:UITableViewStylePlain];
    _allRepayTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _allRepayTable.dataSource = self;
    _allRepayTable.delegate = self;
    _allRepayTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_allRepayTable registerClass:[HCAllRepayCell class] forCellReuseIdentifier:NSStringFromClass([HCAllRepayCell class])];
    _allRepayTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _allRepayTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_getMoreInfo)];
    _allRepayTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_allRepayTable];
}

#pragma mark - GET Web Data
- (void) _loadNewData {
    _dataSource = nil;
    
    [_allRepayTable reloadData];
    [_allRepayTable.mj_header endRefreshing];
    
}


- (void) _getMoreInfo {
    _dataSource = [NSMutableArray arrayWithArray:@[@{@"type":@"现金分期",@"name":@"12期按期还本付费",@"info":@"剩余3000未还",@"date":@"2017-06-10"},@{@"type":@"现金分期",@"name":@"90天随借随还",@"info":@"剩余6000未还",@"date":@"2017-06-20"},@{@"type":@"商品分期",@"name":@"海尔电冰箱分期付款",@"info":@"剩余7000未还",@"date":@"2017-07-06"},@{@"type":@"商品分期",@"name":@"12期自定义商品分期",@"info":@"剩余2600未还",@"date":@"2017-08-18"}]];
    [_allRepayTable reloadData];
    [_allRepayTable.mj_footer resetNoMoreData];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iphone6P) {
        return 70;
    }
    return  65 * _viewScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCAllRepayCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCAllRepayCell class]) forIndexPath:indexPath];
    
    [cell generateCellWithModel:_dataSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
@end
