//
//  HCMonthRepayController.m
//  newHaierCash
//
//  Created by Will on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import <MJRefresh.h>

#import "HCMonthRepayCell.h"
#import "HCMonthRepayController.h"

@interface HCMonthRepayController ()<UITableViewDataSource,UITableViewDelegate> {
    UIView *_topView;
    UIImageView *_tBackImgView;
    UIButton *_tBackBtn;
    UILabel *_tTitleLbl;
    UILabel *_tMonthInfoLbl;
    UILabel *_tMonthMoneyLbl;
    UIView *_tLineView;
    
    UITableView *_monthRepayTable;
    UIButton *_repayBtn;
    
    NSArray *_dataSource;
    CGFloat _viewScale;
}

@end

@implementation HCMonthRepayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    self.view.backgroundColor = [UIColor UIColorWithHexColorString:TableView_BackColor AndAlpha:1];

    [self _createTopView];
    
    [self _createMonthTable];
        
    _repayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _repayBtn.backgroundColor = [UIColor UIColorWithHexColorString:App_MainColor AndAlpha:1];
    [_repayBtn setTitle:NSLocalizedString(@"一键还款", nil) forState:UIControlStateNormal];
    [_repayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_repayBtn addTarget:self action:@selector(_repayBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    _repayBtn.titleLabel.font = [UIFont appFontRegularOfSizePx:25 * _viewScale];
    [self.view addSubview:_repayBtn];
    
    _tMonthInfoLbl.text = @"6月还贷";
    NSString *maneyStr = @"0.00";
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",maneyStr]];
     [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24 * _viewScale] range:NSMakeRange(0, 1)];
    _tMonthMoneyLbl.attributedText = string;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _monthRepayTable.tableHeaderView = _topView;
    if (iphone6P) {
        _monthRepayTable.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight - 50);
        _topView.frame = CGRectMake(0, 0, DeviceWidth, 197 * _viewScale);
        
        _tBackBtn.frame = CGRectMake(19, 26, 12, 23);
        
        _tTitleLbl.frame = CGRectMake(50, 34, DeviceWidth - 100, 16);
        
        _tMonthInfoLbl.frame = CGRectMake(44, 72, DeviceWidth - 30, 14);
        
        _tMonthMoneyLbl.frame = CGRectMake(44, 97, DeviceWidth - 30, 50);
        
        _tLineView.frame = CGRectMake(0, 187, DeviceWidth, 10);
        
        _repayBtn.frame = CGRectMake(0, DeviceHeight - 50, DeviceWidth, 50);
    } else {
        _monthRepayTable.frame = CGRectMake(0, 0, DeviceWidth, DeviceHeight - 45 * _viewScale);
        _topView.frame = CGRectMake(0, 0, DeviceWidth, 179 * _viewScale);
        
        _tBackBtn.frame = CGRectMake(17 * _viewScale, 24 * _viewScale, 11 * _viewScale, 21 * _viewScale);
        
        _tTitleLbl.frame = CGRectMake(50 * _viewScale, 31 * _viewScale, DeviceWidth - 100 * _viewScale, 16 * _viewScale);
        
        _tMonthInfoLbl.frame = CGRectMake(40 * _viewScale, 65 * _viewScale, DeviceWidth - 80 * _viewScale, 14 * _viewScale);
        
        _tMonthMoneyLbl.frame = CGRectMake(40 * _viewScale, 89 * _viewScale, DeviceWidth - 80 * _viewScale, 45 * _viewScale);
        
        _tLineView.frame = CGRectMake(0, 169 * _viewScale, DeviceWidth, 10 * _viewScale);
        _repayBtn.frame = CGRectMake(0, DeviceHeight - 45 * _viewScale, DeviceWidth, 45 * _viewScale);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
//绘制UI
- (void)_createTopView {
    _topView = [UIView new];
    _topView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_topView];
    
    _tBackImgView = [UIImageView new];
    _tBackImgView.contentMode = UIViewContentModeScaleAspectFill;
    [_tBackImgView setImage:[UIImage imageNamed:@"本月待还_背景"]];
    [_topView addSubview:_tBackImgView];
    
    _tTitleLbl = [self _generateLblWithFont:[UIFont appFontRegularOfSize:15 * _viewScale]];
    _tTitleLbl.textAlignment = NSTextAlignmentCenter;
    _tTitleLbl.text = NSLocalizedString(@"本月待还", nil);
    [_topView addSubview:_tTitleLbl];
    
    _tBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _tBackBtn.backgroundColor = [UIColor clearColor];
    [_tBackBtn setImage:[UIImage imageNamed:@"返回_黑"] forState:UIControlStateNormal];
    [_tBackBtn addTarget:self action:@selector(_tBackBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_tBackBtn];
    
    
    _tMonthInfoLbl = [self _generateLblWithFont:[UIFont appFontRegularOfSize:13 * _viewScale]];
    [_topView addSubview:_tMonthInfoLbl];
    
    CGFloat fontSize = iphone6P ? 48 : 44;
    _tMonthMoneyLbl = [self _generateLblWithFont:[UIFont systemFontOfSize:fontSize * _viewScale]];
    [_topView addSubview:_tMonthMoneyLbl];
    
    _tLineView = [[UIView alloc] init];
    _tLineView.backgroundColor = [UIColor UIColorWithHexColorString:TableView_BackColor AndAlpha:1];
    [_topView addSubview:_tLineView];
    
}

- (UILabel *)_generateLblWithFont:(UIFont *)font{
    UILabel *lbl = [UILabel new];
    lbl.numberOfLines = 1;
    lbl.font = font;
    lbl.textColor = [UIColor whiteColor];
    lbl.textAlignment = NSTextAlignmentLeft;
    
    return lbl;
}


- (void)_createMonthTable {
    _monthRepayTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _monthRepayTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _monthRepayTable.dataSource = self;
    _monthRepayTable.delegate = self;
    _monthRepayTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_monthRepayTable registerClass:[HCMonthRepayCell class] forCellReuseIdentifier:NSStringFromClass([HCMonthRepayCell class])];
    _monthRepayTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _monthRepayTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_getMoreInfo)];
    _monthRepayTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_monthRepayTable];
    
}

#pragma mark - Button Event
- (void)_repayBtnDidClick {

}

- (void)_tBackBtnDidClick {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - GET Web Data
- (void) _loadNewData {
    _dataSource = nil;
    
    [_monthRepayTable reloadData];
    NSString *maneyStr = @"0.00";
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",maneyStr]];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24 * _viewScale] range:NSMakeRange(0, 1)];
    _tMonthMoneyLbl.attributedText = string;
    [_monthRepayTable.mj_header endRefreshing];

}


- (void) _getMoreInfo {
    _dataSource = [NSMutableArray arrayWithArray:@[@{@"repay":@"78.90元",@"name":@"【1/12期】日韩5日游",@"info":@"6-12待还"},@{@"repay":@"100.09元",@"name":@"【1/10期】教育分期付",@"info":@"6-17待还"},@{@"repay":@"200.00元",@"name":@"【1/3期】现金支用",@"info":@"6-22待还"},@{@"repay":@"1200.00元",@"name":@"【1/8期】海尔冰箱分期付",@"info":@"6-28待还"}]];
    [_monthRepayTable reloadData];
    NSString *maneyStr = @"2323.12";
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"¥%@",maneyStr]];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24 * _viewScale] range:NSMakeRange(0, 1)];
    _tMonthMoneyLbl.attributedText = string;
    [_monthRepayTable.mj_footer resetNoMoreData];

}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (_dataSource.count > 0 ) {
        if (iphone6P) {
            return 50;
        } else {
            return 45 * _viewScale;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (iphone6P) {
        return  72;
    } else {
        return  65 * _viewScale;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    UILabel *nameLbl = [[UILabel alloc] init];
    nameLbl.font = [UIFont systemFontOfSize:17 * _viewScale];
    nameLbl.textColor = UIColorFromRGB(0x333333, 1);
    nameLbl.text = @"账单详情";
    [headerView addSubview:nameLbl];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = UIColorFromRGB(0xeeeeee, 1);
    [headerView addSubview:lineView];
    if (iphone6P) {
        headerView.frame = CGRectMake(0, 0, DeviceWidth, 50);
        nameLbl.frame = CGRectMake(15, 0, DeviceWidth - 30, 50);
        lineView.frame = CGRectMake(0, 50 - thinLineHeight, DeviceWidth, thinLineHeight);
        
    } else {
        headerView.frame = CGRectMake(0, 0, DeviceWidth, 45 * _viewScale);
        nameLbl.frame = CGRectMake(15 * _viewScale, 0, DeviceWidth - 30 * _viewScale, 45 * _viewScale);
        lineView.frame = CGRectMake(0, 45 * _viewScale - thinLineHeight, DeviceWidth, thinLineHeight);
    }

    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HCMonthRepayCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCMonthRepayCell class]) forIndexPath:indexPath];
    
    [cell generateCellWithModel:_dataSource[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

@end
