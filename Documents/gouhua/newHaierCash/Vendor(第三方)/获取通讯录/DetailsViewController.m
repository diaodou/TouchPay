//
//  DetailsViewController.m
//  读取通讯录
//
//  Created by 2 on 16/4/16.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIColor+DefineNew.h"
#import "PhoneModel.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
@interface DetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView *_tableView;
    
    NSArray *_dataArray;
    
    
}

@end

@implementation DetailsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

-(void)setAddress:(AddressBook *)address{
    
    _address = address;
    
    [self createTable];
    
}

- (void)OnBackBtn:(UIButton *)btn {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"canWrite" object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
  
    
}

-(void)createTable{
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    
    _tableView.delegate=self;
    
    _tableView.dataSource=self;
    
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.tag = 20;
    
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self.view addSubview:_tableView];
}

#pragma mark -- UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _address.phone.count;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *userCell=@"usercell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:userCell];
    
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:userCell];
        
        cell.layer.borderColor = [UIColor UIColorWithHexColorString:@"0xf6f6f6" AndAlpha:1.0].CGColor;
        
        
        cell.layer.borderWidth = 1;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 80, 20)];
        
        name.font = [UIFont appFontRegularOfSize:15];
        
        name.tag = 11;
        
        [cell.contentView addSubview:name];
        
        
        UILabel *_textLabel=[[UILabel alloc]initWithFrame:CGRectMake(120, 13,DeviceWidth-120, 20)];
        
        _textLabel.textColor= [UIColor UIColorWithHexColorString:@"0x232326" AndAlpha:1.0];
        
        _textLabel.textAlignment=NSTextAlignmentLeft;
        
        _textLabel.tag = 10;
        
        _textLabel.font=[UIFont systemFontOfSize:15];
        
        [cell.contentView addSubview:_textLabel];
        
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    
    UILabel *name = (UILabel *)[cell.contentView viewWithTag:11];
    
    
    PhoneModel *model = _address.phone[indexPath.row];
    
    name.text = model.telName;
    
    label.text = model.telNo;
    
    return cell;
}

#pragma mark --> 创建单元格的点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PhoneModel *model = _address.phone[indexPath.row];
    
    [_delegate sendPhone:model.telNo];
    
//    [self.navigationController popViewControllerAnimated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 46;
    
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 46)];
    
    view.backgroundColor=[UIColor whiteColor];
    
    UILabel* _buyLabel=[[UILabel alloc]initWithFrame:CGRectMake(23, 10, DeviceWidth-23, 20)];
    
    _buyLabel.text = _address.fullName;
    
    _buyLabel.textAlignment=NSTextAlignmentLeft;
    
    _buyLabel.textColor=[UIColor blackColor];
    
    _buyLabel.font = [UIFont systemFontOfSize:15];
    
    [view addSubview:_buyLabel];
    
    return view;
    
    
}

#pragma mark -->设置单元格高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 46;
    
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
