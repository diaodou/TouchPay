//
//  HCEducationListController.m
//  newHaierCash
//
//  Created by Will on 2017/6/12.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "UIColor+DefineNew.h"

#import <MJRefresh.h>

#import "HCEducationListController.h"

#import "HCHomeNormalCell.h"

@interface HCEducationListController ()<UITableViewDataSource,UITableViewDelegate> {
    UIView *_topView;
    UIImageView *_tImgView;
    UIView *_tLineView;
    
    UITableView *_educationTable;
    
    NSArray *_dataSource;
    CGFloat _viewScale;
    
}

@end

@implementation HCEducationListController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor UIColorWithHexColorString:@"#eeeeee" AndAlpha:1];;
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    
    [self _createTopView];
    
    _educationTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _educationTable.backgroundColor = [UIColor clearColor];
    _educationTable.separatorStyle = UITableViewCellSelectionStyleNone;
    _educationTable.delegate = self;
    _educationTable.dataSource = self;
    [_educationTable registerClass:[HCHomeNormalCell class] forCellReuseIdentifier:NSStringFromClass([HCHomeNormalCell class])];
    [self.view addSubview:_educationTable];

    _educationTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewInfo)];
    _educationTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_getMoreInfo)];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (iphone6P) {
        _topView.frame = CGRectMake(0, 0, DeviceWidth, 155);
        _tImgView.frame = CGRectMake(0, 0, DeviceWidth, 145);
        _tLineView.frame = CGRectMake(0, 145, DeviceWidth, 10);
    } else {
        _topView.frame = CGRectMake(0, 0, DeviceWidth, 150 * _viewScale);
        _tImgView.frame = CGRectMake(0, 0, DeviceWidth, 140 * _viewScale);
        _tLineView.frame = CGRectMake(0, 14 * _viewScale, DeviceWidth, 10 * _viewScale);
    }
    
    _educationTable.frame = self.view.bounds;
    _educationTable.tableHeaderView = _topView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)_createTopView {
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topView];
    
    _tImgView = [UIImageView new];
    _tImgView.backgroundColor = [UIColor yellowColor];
    [_topView addSubview:_tImgView];
    
    _tLineView = [UIView new];
    _tLineView.backgroundColor = [UIColor clearColor];
    [_topView addSubview:_tLineView];
    
}

#pragma mark - Get Web Data
- (void)_loadNewInfo {
    _dataSource = nil;

    [_educationTable reloadData];
    [_educationTable.mj_header endRefreshing];
}

- (void)_getMoreInfo {
    _dataSource = [NSMutableArray arrayWithArray:@[@{@"title":@"MBA教育分期",@"info":@"0首付 ￥3333 × 3 期"},@{@"title":@"泰山教育分期",@"info":@"0首付 ￥2600 × 3 期"}]];
    [_educationTable reloadData];
    [_educationTable.mj_footer resetNoMoreData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iphone6P) {
        return 95;
    } else {
        return 87 * _viewScale;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCHomeNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCHomeNormalCell class]) forIndexPath:indexPath];
    
    [cell generateCellWithModel:_dataSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_educationTable deselectRowAtIndexPath:indexPath animated:YES];
    
}

//155/95  1.6p
//138/
//95
//85

@end
