//
//  HCOrderDetailViewController.m
//  newHaierCash
//
//  Created by BSVK on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCOrderDetailViewController.h"
#import "HCOrderDetailCell.h"
#import "HCInstallmentBillCell.h"
#import "HCMacro.h"
#import "UIColor+DefineNew.h"
@interface HCOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic , strong)UITableView *tableView;
@property(nonatomic , assign)CGFloat viewScale;
@property(nonatomic , strong)UILabel *repayAmountLbl;
@property(nonatomic , strong)UILabel *nameLbl;
@property(nonatomic , strong)UILabel *addressLbl;
@property(nonatomic , strong)UILabel *bankNameLbl;
@property(nonatomic , strong)UILabel *bankNumberLbl;
@property(nonatomic , strong)UILabel *orderStausLbl;
@end

@implementation HCOrderDetailViewController

#pragma mark --life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    [self creatTableView];
    [self creatBottomBtn];
    self.title = @"订单详情";
    // Do any additional setup after loading the view.
}

#pragma mark --creatUI

-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,DeviceWidth , DeviceHeight - 64 - 50 *_viewScale) style:UITableViewStylePlain];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 23*_viewScale)];
    footerView.backgroundColor = [UIColor UIColorWithHexColorString:@"#eeeeee" AndAlpha:1];
    _tableView.backgroundColor = [UIColor UIColorWithHexColorString:@"#eeeeee" AndAlpha:1];
    _tableView.tableFooterView = footerView;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

-(void)creatBottomBtn{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, DeviceHeight - 64- 50 * _viewScale, DeviceWidth, 50 * _viewScale)];
    backView.backgroundColor = [UIColor whiteColor];
    UIImageView *checkImgVC = [[UIImageView alloc]initWithFrame:CGRectMake(13, (50 * _viewScale - 21 *_viewScale)/2, 21 *_viewScale, 21 * _viewScale)];
    checkImgVC.image = [UIImage imageNamed:@"图标_选中"];
    [backView addSubview:checkImgVC];
    UILabel *checkLbl = [[UILabel alloc]initWithFrame:CGRectMake(13 + 30 * _viewScale, (50 * _viewScale - 12 )/2, 26,12 )];
    checkLbl.text = @"已选";
    checkLbl.font = [UIFont systemFontOfSize:12];
    [backView addSubview:checkLbl];
    _repayAmountLbl = [[UILabel alloc]initWithFrame:CGRectMake(13 + 30 * _viewScale + 30, (50 * _viewScale - 12 )/2, 150,12 )];
    _repayAmountLbl.textColor  = [UIColor UIColorWithHexColorString:@"#f15a4a" AndAlpha:1];
    _repayAmountLbl.text = @"¥247.00";
    [backView addSubview:_repayAmountLbl];
    UIButton *justPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(DeviceWidth - 125 * _viewScale, 0, 125 * _viewScale, 50 * _viewScale)];
    [justPayBtn setBackgroundColor:[UIColor UIColorWithHexColorString:@"#32beff" AndAlpha:1]];
    [justPayBtn setTitle:@"立即还款" forState:UIControlStateNormal];
    [backView addSubview:justPayBtn];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 0.5)];
    lineView.backgroundColor = [UIColor UIColorWithHexColorString:@"#dcdcdc" AndAlpha:1];
    [backView addSubview:lineView];
    [self.view addSubview:backView];
}

#pragma mark --getting and setting

-(UILabel *)nameLbl{
    if (!_nameLbl) {
        if (iphone6P) {
            _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 330, 15)];
            _nameLbl.font = [UIFont systemFontOfSize:15];
        }else{
            _nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(15*_viewScale, 15*_viewScale, 330*_viewScale, 14*_viewScale)];
            _nameLbl.font = [UIFont systemFontOfSize:14*_viewScale];
        }
        
    }
    return _nameLbl;
}

-(UILabel *)addressLbl{
    if (!_addressLbl) {
        if (iphone6P) {
            _addressLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 45, 330, 134)];
            _addressLbl.font = [UIFont systemFontOfSize:14];
        }
        _addressLbl = [[UILabel alloc]initWithFrame:CGRectMake(15*_viewScale, 40*_viewScale, 330*_viewScale, 13*_viewScale)];
        _addressLbl.font = [UIFont systemFontOfSize:13*_viewScale];
    }
    return _addressLbl;
}

-(UILabel *)bankNameLbl{
    if (!_bankNameLbl) {
        if (iphone6P) {
            _bankNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(114, 18, 135, 14)];
            _bankNameLbl.font = [UIFont systemFontOfSize:14];
        }else{
            _bankNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(104*_viewScale, 15.5*_viewScale, 135*_viewScale, 13*_viewScale)];
            _bankNameLbl.font = [UIFont systemFontOfSize:13*_viewScale];
        }
        _bankNameLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
    }
    return _bankNameLbl;
}

-(UILabel *)bankNumberLbl{
    if (!_bankNumberLbl) {
        if(iphone6P){
            _bankNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(318, 18, 70, 14)];
            _bankNumberLbl.font = [UIFont systemFontOfSize:14];
            
        }else{
            _bankNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(285*_viewScale, 15.5*_viewScale, 60*_viewScale, 13*_viewScale)];
            _bankNumberLbl.font = [UIFont systemFontOfSize:13*_viewScale];
        }
        
        _bankNumberLbl.textColor = [UIColor UIColorWithHexColorString:@"#999999" AndAlpha:1];
    }
    return _bankNumberLbl;
}

-(UILabel *)orderStausLbl{
    if (!_orderStausLbl) {
        if (iphone6P) {
            _orderStausLbl = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth-115, 16, 100*_viewScale, 15)];
            _orderStausLbl.font = [UIFont systemFontOfSize:15];
        }else{
            _orderStausLbl = [[UILabel alloc]initWithFrame:CGRectMake(DeviceWidth-113*_viewScale, 14*_viewScale, 100*_viewScale, 14*_viewScale)];
            _orderStausLbl.font = [UIFont systemFontOfSize:14*_viewScale];
        }
        
        _orderStausLbl.textColor = [UIColor whiteColor];
        _orderStausLbl.textAlignment = NSTextAlignmentRight;
    }
    return _orderStausLbl;
}

#pragma mark --tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.section == 0 ) { //section == 0
        static NSString *  const firstCellID = @"firstCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:firstCellID];
            [cell.contentView addSubview:self.nameLbl];
            [cell.contentView addSubview:self.addressLbl];
            UIImageView *bottomView;
            if (iphone6P) {
                bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 78, DeviceWidth, 5)];

            }else{
                bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 74 * _viewScale - 5 * _viewScale, DeviceWidth, 5*_viewScale)];

            }
            bottomView.image = [UIImage imageNamed:@"地址花边"];
            [cell.contentView addSubview:bottomView];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        _nameLbl.text = @"收货人:徐凯丽";
        _addressLbl.text = @"收货地址:山东省青岛市崂山区海尔路178号";
        return cell;
    }else if (indexPath.row == 0 && indexPath.section == 1){ //section == 1
        static NSString * const secondCellID = @"secondCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:secondCellID];
            UILabel *defaultCardLbl;
            if (iphone6P) {
                defaultCardLbl =[[UILabel alloc]initWithFrame:CGRectMake(15, 17, 80, 15)];
                defaultCardLbl.font = [UIFont systemFontOfSize:15];

            }else{
                defaultCardLbl = [[UILabel alloc]initWithFrame:CGRectMake(14*_viewScale, 15*_viewScale, 72*_viewScale, 14*_viewScale)];
                defaultCardLbl.font = [UIFont systemFontOfSize:14*_viewScale];
            }
            defaultCardLbl.text = @"默认还款卡";
            [cell.contentView addSubview:defaultCardLbl];
            [cell.contentView addSubview:self.bankNumberLbl];
            [cell.contentView addSubview:self.bankNameLbl];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        _bankNameLbl.text = @"中国工商银行";
        _bankNumberLbl.text = @"****5678";
        return cell;
    }else if (indexPath.row == 0 && indexPath.section == 2){ //section == 2
        static NSString *  const orderDetailCellID = @"orderDetailCellID";
        HCOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:orderDetailCellID];
        if (!cell) {
            cell = [[HCOrderDetailCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:orderDetailCellID];
        }
        [cell setMethod];
        cell.applyRefundBlock = ^(NSString *orderNumber){  //申请退款block
            NSLog(@"申请退款");
        };
        return cell;
    }else{
        static NSString * const installmentBillCellID = @"installmentBillCellID";
        HCInstallmentBillCell *cell = [tableView dequeueReusableCellWithIdentifier:installmentBillCellID];
        if (!cell) {
            cell = [[HCInstallmentBillCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:installmentBillCellID];
        }
        [cell setMethod];
        return cell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 1;
    }else if(section == 2){
        return 1;
    }else
        return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if(iphone6P){
            return 82;
        }else{
            return 74 * _viewScale;
        }
        
    }else if(indexPath.section == 1){
        if (iphone6P) {
            return 50;
        }else{
            return 44 * _viewScale;
        }
    }else if(indexPath.section == 2){
        if (iphone6P) {
            return 242;
        }else{
            return 218 * _viewScale;
        }
    }else{
        if (iphone6P) {
            return 72;
        }else{
            return 65 * _viewScale;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (iphone6P) {
            return 47;
        }else{
            return 42 * _viewScale;
        }
    }else
        return 10 * _viewScale;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (iphone6P) {
            UIImageView *imgVC = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 47)];
            [imgVC setImage:[UIImage imageNamed:@"本月待还_背景"]];
            UIImageView *orderImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 11, 25, 25)];
            [orderImg setImage:[UIImage imageNamed:@""]];
            [imgVC addSubview:orderImg];
            UILabel *statusLbl  = [[UILabel alloc]initWithFrame:CGRectMake(50, 16, 70, 15)];
            statusLbl.textColor = [UIColor whiteColor];
            statusLbl.text = @"订单详情";
            statusLbl.font = [UIFont systemFontOfSize:15];
            [imgVC addSubview:statusLbl];
            [imgVC addSubview:self.orderStausLbl];
            self.orderStausLbl.text = @"已放款";
            return imgVC;
        }else{
            UIImageView *imgVC = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 42 * _viewScale)];
            [imgVC setImage:[UIImage imageNamed:@"本月待还_背景"]];
            UIImageView *orderImg = [[UIImageView alloc]initWithFrame:CGRectMake(13*_viewScale, 10*_viewScale, 22*_viewScale, 22*_viewScale)];
            [orderImg setImage:[UIImage imageNamed:@""]];
            [imgVC addSubview:orderImg];
            UILabel *statusLbl  = [[UILabel alloc]initWithFrame:CGRectMake(45*_viewScale, 14*_viewScale, 60*_viewScale, 14*_viewScale)];
            statusLbl.textColor = [UIColor whiteColor];
            statusLbl.text = @"订单详情";
            statusLbl.font = [UIFont systemFontOfSize:14*_viewScale];
            [imgVC addSubview:statusLbl];
            [imgVC addSubview:self.orderStausLbl];
            self.orderStausLbl.text = @"已放款";
            return imgVC;
        }
        
    }else{
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10 * _viewScale)];
        grayView.backgroundColor = [UIColor UIColorWithHexColorString:@"#eeeeee" AndAlpha:1];
        return grayView;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
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
