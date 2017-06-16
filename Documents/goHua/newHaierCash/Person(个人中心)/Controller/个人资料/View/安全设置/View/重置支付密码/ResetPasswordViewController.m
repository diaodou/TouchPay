//
//  ResetPasswordViewController.m
//  personMerchants
//
//  Created by Apple on 16/3/24.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "HCMacro.h"
#import "RememberPasswordViewController.h"
#import "RealNameViewController.h"
#import "UIFont+AppFont.h"
@interface ResetPasswordViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *resetTableView;
@end

@implementation ResetPasswordViewController
#pragma mark -- lift cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改支付密码";
    self.view.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self setTableView];
    [self setNavi];
}
#pragma mark - setting and getting
- (void)setTableView{
    _resetTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 9, DeviceWidth, DeviceHeight) style:UITableViewStylePlain];
    _resetTableView.delegate = self;
    _resetTableView.dataSource = self;
    _resetTableView.tableFooterView = [[UITableView alloc]initWithFrame:CGRectZero];
    _resetTableView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    [self.view addSubview:_resetTableView];
}
//设置导航
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
#pragma mark -- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (iphone6P) {
       
        return 50;
    }else{
    
        return 45;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = @[@"我记得支付密码",@"我忘记支付密码了"];
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.textColor = UIColorFromRGB(0x333333, 1.0);
        cell.textLabel.font = [UIFont appFontRegularOfSize:14];
        cell.textLabel.text = array[indexPath.row];
        cell.accessoryType = UITableViewCellStyleValue1;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_resetTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
       
        [self toRememberPasswordViewController];
    }else if (indexPath.row == 1){
        
        [self toRealNameViewController];
    }
}
#pragma mark - private Methods
- (void)toRememberPasswordViewController{
    //        记得支付密码
    RememberPasswordViewController *vc = [[RememberPasswordViewController alloc]init];
//    vc.flowName = changeDealPwdByRemeber;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)toRealNameViewController{
    //        不记得支付密码
    RealNameViewController *vc = [[RealNameViewController alloc]init];
    vc.realNameChageBindPhoneNumType = RealNameChangeDealPwdByNoRemeber;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 分割线
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([_resetTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_resetTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([_resetTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_resetTableView setLayoutMargins:UIEdgeInsetsZero];
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

@end
