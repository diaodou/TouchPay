//
//  HCFreeTicketController.m
//  newHaierCash
//
//  Created by Will on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import <MJRefresh.h>

#import "HCFreeTicketCell.h"
#import "HCFreeTicketController.h"

@interface HCFreeTicketController () <UITableViewDataSource,UITableViewDelegate>{
    UIView *_topView;
    UILabel *_infoTitleLbl;
    UILabel *_infoLbl;
    UITableView *_freeTicketTable;
    
    NSArray *_dataSource;
    CGFloat _viewScale;
}

@end

@implementation HCFreeTicketController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"免息券领取", nil);
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    self.view.backgroundColor = [UIColor UIColorWithHexColorString:TableView_BackColor AndAlpha:1];
    
    [self _createTopView];
    
    [self _createMonthTable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _freeTicketTable.tableHeaderView = _topView;
    _topView.frame = CGRectMake(0, 0, DeviceWidth, 140 * _viewScale);
    
    _infoTitleLbl.frame = CGRectMake(15 * _viewScale, 62 * _viewScale, 70 * _viewScale, 16 * _viewScale);
    
    _infoLbl.frame = CGRectMake(100 * _viewScale, 10 * _viewScale, DeviceWidth - 115 * _viewScale, 120 * _viewScale);
    
}

#pragma mark - Private Method
//绘制UI
- (void)_createTopView {
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_topView];
    
    _infoTitleLbl = [self _generateLblWithFont:[UIFont appFontRegularOfSize:16 * _viewScale]];
    [_topView addSubview:_infoTitleLbl];
    _infoTitleLbl.text = @"使用方法";
    
    _infoLbl = [self _generateLblWithFont:[UIFont appFontRegularOfSize:12 * _viewScale]];
    _infoLbl.textColor = [UIColor grayColor];
    _infoLbl.text = @"1.asfdjajsfdkja;sdfj;akjsdf;lajksdf;jkas;dfjk;asjkf;ajksfd;la  2.fjasdjf;ajksdf;ajk;sdfa";
    _infoLbl.numberOfLines = 6;
    [_topView addSubview:_infoLbl];
    
}

- (UILabel *)_generateLblWithFont:(UIFont *)font{
    UILabel *lbl = [UILabel new];
    lbl.numberOfLines = 1;
    lbl.font = font;
    lbl.textColor = [UIColor blackColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    
    return lbl;
}


- (void)_createMonthTable {
    _freeTicketTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight- 64 - 45 * _viewScale) style:UITableViewStylePlain];
    _freeTicketTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _freeTicketTable.dataSource = self;
    _freeTicketTable.delegate = self;
    _freeTicketTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_freeTicketTable registerClass:[HCFreeTicketCell class] forCellReuseIdentifier:NSStringFromClass([HCFreeTicketCell class])];
    _freeTicketTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _freeTicketTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_getMoreInfo)];
    _freeTicketTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_freeTicketTable];
    
}

#pragma mark - GET Web Data
- (void) _loadNewData {
    _dataSource = nil;
    
    [_freeTicketTable reloadData];
    [_freeTicketTable.mj_header endRefreshing];
    
}


- (void) _getMoreInfo {
    _dataSource = [NSMutableArray arrayWithArray:@[@{@"image":@"a1.jpg"},@{@"image":@"a2.jpg"},@{@"image":@"a3.jpg"},@{@"image":@"a1.jpg"},]];
    [_freeTicketTable reloadData];
    [_freeTicketTable.mj_footer resetNoMoreData];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_dataSource.count > 0) {
        return 10 * _viewScale;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  70 * _viewScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 10 * _viewScale)];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCFreeTicketCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCFreeTicketCell class]) forIndexPath:indexPath];
    
    [cell generateCellWithModel:_dataSource[indexPath.row] andAlreadyGet:NO];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
