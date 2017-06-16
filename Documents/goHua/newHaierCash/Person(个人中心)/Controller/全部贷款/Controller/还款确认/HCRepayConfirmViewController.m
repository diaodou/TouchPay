//
//  HCRepayConfirmViewController.m
//  newHaierCash
//
//  Created by BSVK on 2017/6/15.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCRepayConfirmViewController.h"
#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"
#import "HCInputPaymentPSView.h"
@interface HCRepayConfirmViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic ,strong)UITableView *tableView;
@property(nonatomic ,strong)UITextField *moneyTF;
@property(nonatomic ,assign)CGFloat viewScale;
@end

@implementation HCRepayConfirmViewController

#pragma mark --life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;

    [self creatUI];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    backView.backgroundColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:0.3];
    [self.navigationController.view addSubview:backView];
    HCInputPaymentPSView *view = [[HCInputPaymentPSView alloc]initWithFrame:CGRectMake(0, 0, 317*_viewScale, 322*_viewScale)];
    view.center = backView.center;
    [view setViewData];
    [backView addSubview:view];

    // Do any additional setup after loading the view.
}

#pragma mark --creatUI

-(void)creatUI{
    self.title = @"还款确认";
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight - 64) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

-(UITextField *)moneyTF{
    if (!_moneyTF) {
        if (iphone6P) {
            _moneyTF = [[UITextField alloc]initWithFrame:CGRectMake(48, 50, 360, 28)];
            _moneyTF.font = [UIFont systemFontOfSize:28];
        }else{
            _moneyTF = [[UITextField alloc]initWithFrame:CGRectMake(46*_viewScale, 50*_viewScale, 300*_viewScale, 25*_viewScale)];
            _moneyTF.font = [UIFont systemFontOfSize:25*_viewScale];
        }
        _moneyTF.keyboardType = UIKeyboardTypeDecimalPad;
    }
    return _moneyTF;
}

#pragma  mark --tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iphone6P) {
        return 0;
    }else{
        if (indexPath.section == 0) {
            if (iphone6P) {
                return 104;
            }else
                return 94;
        }else{
            if (iphone6P) {
                return 50;
            }else
                return 45;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10*_viewScale;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10*_viewScale)];
        headerView.backgroundColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
        return headerView;
    }else
        return [[UIView alloc]initWithFrame:CGRectZero];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * const repayMoenyCellID = @"repayMoenyCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:repayMoenyCellID];
        if (!cell) {
            if (iphone6P) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:repayMoenyCellID];
                UILabel *moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 30, 14)];
                moneyLbl.textColor = [UIColor UIColorWithHexColorString:@"6b6b6b" AndAlpha:1];
                moneyLbl.font = [UIFont systemFontOfSize:13*_viewScale];
                moneyLbl.text = @"金额";
                [cell.contentView addSubview:moneyLbl];
                UILabel *rmbLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 28, 28)];
                rmbLbl.font = [UIFont systemFontOfSize:28];
                rmbLbl.text = @"¥";
                [cell.contentView addSubview:rmbLbl];
                [cell.contentView addSubview:self.moneyTF];
            }else{
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:repayMoenyCellID];
                UILabel *moneyLbl = [[UILabel alloc]initWithFrame:CGRectMake(15*_viewScale, 12*_viewScale, 30, 13*_viewScale)];
                moneyLbl.textColor = [UIColor UIColorWithHexColorString:@"6b6b6b" AndAlpha:1];
                moneyLbl.font = [UIFont systemFontOfSize:13*_viewScale];
                moneyLbl.text = @"金额";
                [cell.contentView addSubview:moneyLbl];
                UILabel *rmbLbl = [[UILabel alloc]initWithFrame:CGRectMake(15*_viewScale, 46*_viewScale, 25*_viewScale, 25*_viewScale)];
                rmbLbl.font = [UIFont systemFontOfSize:25*_viewScale];
                rmbLbl.text = @"¥";
                [cell.contentView addSubview:rmbLbl];
                [cell.contentView addSubview:self.moneyTF];
            }
        }
        _moneyTF.text = @"11111";
        return cell;
    }else{
        static NSString * const normalCellID = @"normalCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalCellID];
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
