//
//  HCShippingAddressViewController.m
//  newHaierCash
//
//  Created by BSVK on 2017/6/12.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCShippingAddressViewController.h"
#import "HCShippingAddressCell.h"
#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "HCNewShippingAddressViewController.h"
#import "HCRepayConfirmViewController.h"

@interface HCShippingAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *bottomBtn;
@property(nonatomic,assign)CGFloat viewScale;
@end

@implementation HCShippingAddressViewController

#pragma mark --life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    self.title = @"收货地址";
    [self creatRightBtn];   //设置右btn
    [self creatTableView];
    [self creatBottomBtn];
    // Do any additional setup after loading the view.
}


#pragma mark --creatUI
- (void)creatRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 20, 20);
    [rightBtn addTarget:self action:@selector(skipToSet:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setImage:[UIImage imageNamed:@"右上角设置"] forState:UIControlStateNormal];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = btn;
    
}

-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-50*_viewScale-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor UIColorWithRed:238 green:238 blue:238 alpha:1];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    
}

-(void)creatBottomBtn{
    _bottomBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    _bottomBtn.adjustsImageWhenHighlighted = NO;
    _bottomBtn.frame = CGRectMake(0, DeviceHeight-64-50*_viewScale, DeviceWidth, 50*_viewScale);
    [_bottomBtn setTitle:@"点击新增地址"forState:UIControlStateNormal];
    [_bottomBtn setImage:[UIImage imageNamed:@"地址_添加"] forState:UIControlStateNormal];
    _bottomBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10 , 0, 0);
    [_bottomBtn setBackgroundColor:[UIColor UIColorWithHexColorString:@"#32beff" AndAlpha:1]];
    [_bottomBtn addTarget:self action:@selector(skipToNewAddress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bottomBtn];
}

//跳转设置页面
- (void)skipToSet:(UIButton *)sender{
    HCRepayConfirmViewController *orderDetailVC = [[HCRepayConfirmViewController alloc]init];
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    NSLog(@"跳转设置");
}

-(void)skipToNewAddress:(UIButton *)sender{
    HCNewShippingAddressViewController *newAddressVC = [[HCNewShippingAddressViewController alloc]init];
    newAddressVC.title = @"新增收货地址";
    [self.navigationController pushViewController:newAddressVC animated:YES];
}

#pragma mark --tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iphone6P) {
        return 80;
    }else
        return 70*_viewScale;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (iphone6P) {
        return 10;
    }else{
        return 10*_viewScale;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const shippingAddressCellID = @"shippingAddressCellID";
    HCShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:shippingAddressCellID];
    if (!cell) {
        cell = [[HCShippingAddressCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:shippingAddressCellID];
    }
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    [cell setMethod];
    if (indexPath.section == _selectIndex) {
        if (![cell.contentView.subviews containsObject:cell.defaultImgV]) {
            [cell.contentView addSubview:cell.defaultImgV];
        }
        if (![cell.contentView.subviews containsObject:cell.bottomImgV]) {
            [cell.contentView addSubview:cell.bottomImgV];
        }
    }else{
        if ([cell.contentView.subviews containsObject:cell.defaultImgV]) {
            [cell.defaultImgV removeFromSuperview];
        }
        if ([cell.contentView.subviews containsObject:cell.bottomImgV]) {
            [cell.bottomImgV removeFromSuperview];
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HCNewShippingAddressViewController *newAddressVC = [[HCNewShippingAddressViewController alloc]init];
    newAddressVC.title = @"修改收货地址";
    [self.navigationController pushViewController:newAddressVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10*_viewScale)];
    [headerView setBackgroundColor:[UIColor UIColorWithRed:238 green:238 blue:238 alpha:1]];
    return headerView;
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
