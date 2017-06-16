//
//  HCWeekRepayController.m
//  newHaierCash
//
//  Created by Will on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import <MJRefresh.h>

#import "HCWeekRepayCell.h"
#import "HCWeekRepayController.h"

static NSString *HCWeekRepayCellIden = @"HCWeekRepayCellIden";

@interface HCWeekRepayController ()<HCWeekRepayCellDelegate,UITableViewDataSource,UITableViewDelegate> {
    UITableView *_weekRepayTable;
    
    UIView *_bottomView;
    UIButton *_selectAllBtn;
    UILabel *_moneyNumLbl;
    UIButton *_repayBtn;
    
    
    //数据
    NSInteger _page; //页数
    NSMutableArray *_selectModels;//选择的数组
    NSMutableArray *_dataSource;
    CGFloat _viewScale;

}

@end

@implementation HCWeekRepayController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"近7日待还";
    self.view.backgroundColor = [UIColor UIColorWithHexColorString:TableView_BackColor AndAlpha:1];
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    _selectModels = [NSMutableArray new];
    
    [self _createTableView];
    
    [self _createBottomView];

    NSString *maneyStr = @"0.00";
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已选￥%@",maneyStr]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, string.length - 2)];
    _moneyNumLbl.attributedText =  string;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (iphone6P) {
        _weekRepayTable.frame = CGRectMake(0, 1, DeviceWidth, DeviceHeight- 64 - 50);
        
        _bottomView.frame = CGRectMake(0, DeviceHeight - 64 - 49, DeviceWidth, 49);
        _selectAllBtn.frame = CGRectMake(15, 16, 18, 18);
        _repayBtn.frame = CGRectMake(DeviceWidth - 130, 0, 130, 49);
        _moneyNumLbl.frame = CGRectMake(40, 0, DeviceWidth - 180, 49);
    } else {
        _weekRepayTable.frame = CGRectMake(0, 1 * _viewScale, DeviceWidth, DeviceHeight- 64 - 46 * _viewScale);
        _bottomView.frame = CGRectMake(0, DeviceHeight - 64 - 45 * _viewScale, DeviceWidth, 45 * _viewScale);
        _selectAllBtn.frame = CGRectMake(15 * _viewScale, 14 * _viewScale, 17 * _viewScale, 17 * _viewScale);
        _repayBtn.frame = CGRectMake(DeviceWidth - 121 * _viewScale, 0, 121 * _viewScale, 45 * _viewScale);
        _moneyNumLbl.frame = CGRectMake(40 * _viewScale, 0, DeviceWidth - 171 * _viewScale, 45 * _viewScale);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_createTableView{
    _weekRepayTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _weekRepayTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _weekRepayTable.dataSource = self;
    _weekRepayTable.delegate = self;
    _weekRepayTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [_weekRepayTable registerClass:[HCWeekRepayCell class] forCellReuseIdentifier:HCWeekRepayCellIden];
    _weekRepayTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _weekRepayTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_getMoreInfo)];
    _weekRepayTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_weekRepayTable];
}

- (void)_createBottomView {
    _bottomView = [UIView new];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    _selectAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectAllBtn setSelected:NO];
    [_selectAllBtn setBackgroundImage:[UIImage imageNamed:@"图标_未选中"] forState:UIControlStateNormal];
    [_selectAllBtn addTarget:self action:@selector(_selectAll) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_selectAllBtn];
    
    _moneyNumLbl = [UILabel new];
    _moneyNumLbl.font = [UIFont appFontRegularOfSize:15 * _viewScale];
    [_bottomView addSubview:_moneyNumLbl];
    
    _repayBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [_repayBtn setTitle:@"立即还款" forState:UIControlStateNormal];
    _repayBtn.titleLabel.font = [UIFont appFontRegularOfSize:16 * _viewScale];
    [_repayBtn setBackgroundColor:[UIColor UIColorWithHexColorString:@"0x028de5" AndAlpha:1]];
    [_repayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_repayBtn addTarget:self action:@selector(_repayBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_repayBtn];
}

#pragma mark - Button Event
- (void)_selectAll {
    if (!_selectAllBtn.isSelected && _dataSource.count > 0) {
        [_selectAllBtn setBackgroundImage:[UIImage imageNamed:@"图标_选中"] forState:UIControlStateNormal];
        _selectModels = nil;
        _selectModels = [NSMutableArray arrayWithArray:_dataSource];
        [_selectAllBtn setSelected:YES];
        [_weekRepayTable reloadData];
    } else if(_selectAllBtn.isSelected && _dataSource.count > 0) {
        [_selectAllBtn setBackgroundImage:[UIImage imageNamed:@"图标_未选中"] forState:UIControlStateNormal];
        _selectModels = nil;
        _selectModels = [NSMutableArray new];
        [_selectAllBtn setSelected:NO];
        [_weekRepayTable reloadData];
    }
}

- (void)_repayBtnDidClick {

}

#pragma mark - Get Web Data
- (void)_loadNewData {
    _dataSource = [NSMutableArray arrayWithArray:@[@{@"repay":@"78.90元",@"name":@"【1/12期】日韩5日游",@"info":@"剩余5天"},@{@"repay":@"100.09元",@"name":@"【1/10期】教育分期付",@"info":@"剩余2天"},@{@"repay":@"200.00元",@"name":@"【1/3期】现金只用",@"info":@"剩余6天"},@{@"repay":@"1200.00元",@"name":@"【1/8期】海尔冰箱分期付",@"info":@"剩余1天"}]];
    [_weekRepayTable reloadData];
    NSString *maneyStr = @"1578.99";
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已选￥%@",maneyStr]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, string.length - 2)];
    _moneyNumLbl.attributedText =  string;

    [_weekRepayTable.mj_header endRefreshing];
}

- (void)_getMoreInfo {
    _dataSource = nil;
    
    [_weekRepayTable reloadData];
    NSString *maneyStr = @"0.00";
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已选￥%@",maneyStr]];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, string.length - 2)];
    _moneyNumLbl.attributedText =  string;
    [_weekRepayTable.mj_footer resetNoMoreData];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  64 * _viewScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HCWeekRepayCell *cell  = [tableView dequeueReusableCellWithIdentifier:HCWeekRepayCellIden forIndexPath:indexPath];
    cell.delegate = self;
    NSDictionary *model = _dataSource[indexPath.row];
    [cell generateCellWithModel:model];
    [cell changeSelectBtnState:[_selectModels containsObject:model]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - HCWeekRepayCellDelegate

- (void)HCWeekReplayCellGetModel:(NSDictionary *)model withIsSelect:(BOOL)isSelect {
    if (isSelect && ![_selectModels containsObject:model]) {
        [_selectModels addObject:model];
    } else if (!isSelect && [_selectModels containsObject:model]) {
        [_selectModels removeObject:model];
    }
}

@end
