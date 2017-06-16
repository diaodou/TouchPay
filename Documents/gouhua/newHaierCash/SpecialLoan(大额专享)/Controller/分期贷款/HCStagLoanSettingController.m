//
//  HCStagLoanSettingController.m
//  newHaierCash
//
//  Created by Will on 2017/6/5.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

#import <MJRefresh.h>

#import "HCStagLoanSettingController.h"
#import "HCChangeNumCell.h"
#import "HCTextInfoCell.h"


@interface HCStagLoanSettingController ()<UITableViewDataSource, UITableViewDelegate> {
    UITableView *_loanInfoTable;
    UIButton *_applyBtn;
    
    NSMutableDictionary *_orderDic;
    NSArray *_dataSource;
    CGFloat _viewScale;
}

@end

@implementation HCStagLoanSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor UIColorWithHexColorString:TableView_BackColor AndAlpha:1];
    self.title = NSLocalizedString(@"分期申请", nil);
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    
    _dataSource = @[@[@"分期方式",@"优惠券"],@[@"还款计划"]];
    
    _loanInfoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64 - 45 * _viewScale) style:UITableViewStylePlain];
    _loanInfoTable.backgroundColor = [UIColor clearColor];
    _loanInfoTable.separatorStyle = UITableViewCellSelectionStyleNone;
    _loanInfoTable.dataSource = self;
    _loanInfoTable.delegate = self;
    [_loanInfoTable registerClass:[HCChangeNumCell class] forCellReuseIdentifier:NSStringFromClass([HCChangeNumCell class])];
    [_loanInfoTable registerClass:[HCTextInfoCell class] forCellReuseIdentifier:NSStringFromClass([HCTextInfoCell class])];
    [self.view addSubview:_loanInfoTable];
    _loanInfoTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(_loadNewData)];
    _loanInfoTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(_getMoreInfo)];
    
    _applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _applyBtn.backgroundColor = [UIColor UIColorWithHexColorString:App_MainColor AndAlpha:1];
    [_applyBtn setTitle:NSLocalizedString(@"立即申请", nil) forState:UIControlStateNormal];
    [_applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_applyBtn addTarget:self action:@selector(_applyBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    _applyBtn.titleLabel.font = [UIFont appFontRegularOfSizePx:21 * _viewScale];
    [self.view addSubview:_applyBtn];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _applyBtn.frame = CGRectMake(0, DeviceHeight - 45 * _viewScale - 64, DeviceWidth, 45 * _viewScale);
}

#pragma mark - Button Event
- (void)_applyBtnDidClick {

}


#pragma mark - Get Web Data
- (void)_loadNewData {
    _dataSource = @[@[@"分期方式",@"优惠券"],@[@"还款计划"]];
    [_loanInfoTable reloadData];
    [_loanInfoTable.mj_header endRefreshing];
}

- (void)_getMoreInfo {
    _dataSource = @[@[@{@"title":@"商品名称",@"value":@"",@"place":@"家电套餐(冰箱、洗衣机、空调)",@"type":@"1"},@{@"title":@"分期金额",@"value":@"12000",@"place":@"请输入金额",@"type":@"1"},@{@"title":@"购买数量",@"value":@"1",@"place":@"",@"type":@"2"},@"分期方式",@"优惠券"],@[@"还款计划"]];
    
    [_loanInfoTable reloadData];
    [_loanInfoTable.mj_footer resetNoMoreData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *secArray = _dataSource[section];
    return secArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10 * _viewScale;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  50 * _viewScale;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 10 * _viewScale)];
    footerView.backgroundColor = [UIColor UIColorWithHexColorString:@"#f6f6f9" AndAlpha:1];
    if (section != _dataSource.count - 1) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * _viewScale - thinLineHeight, DeviceWidth, thinLineHeight)];
        lineView.backgroundColor = [UIColor grayColor];
        [footerView addSubview:lineView];
    }
    
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sectionArray = _dataSource[indexPath.section];
    id obj = sectionArray[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        HCTextInfoCell *moreCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCTextInfoCell class]) forIndexPath:indexPath];
        [moreCell generateCellWithTitle:(NSString *)obj andInfo:@"信息"];
        return moreCell;
    } else {
        NSDictionary *model = (NSDictionary *)obj;
        if ([model[@"type"] isEqualToString:@"1"]) {
            HCTextInfoCell *textCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCTextInfoCell class]) forIndexPath:indexPath];
            [textCell generateCellWithModel:model];
            return textCell;
        } else {
            HCChangeNumCell *numCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HCChangeNumCell class]) forIndexPath:indexPath];
            [numCell generateCellWithModel:model];
            return numCell;
        }
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
@end
