//
//  HCNewShippingAddressViewController.m
//  newHaierCash
//
//  Created by BSVK on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCNewShippingAddressViewController.h"
#import "HCMacro.h"
#import "UIColor+DefineNew.h"
#import "UIFont+AppFont.h"

@interface HCNewShippingAddressViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)UITextField *phoneNumberTF;
@property(nonatomic,strong)UITextField *detailAddressTF;
@property(nonatomic,assign)CGFloat viewScale;
@property(nonatomic,strong)UISwitch *defaultAddressSwitch;
@end

@implementation HCNewShippingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewScale = iphone6P ? scale6PAdapter : scaleAdapter;
    [self creatTableView];
    [self creatBottomBtn];
    // Do any additional setup after loading the view.
}

#pragma mark --creatUI

-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-64) style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor UIColorWithHexColorString:@"#eeeeee" AndAlpha:1]];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

-(void)creatBottomBtn{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 35)];
    UIButton *bottomBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.frame = CGRectMake(43*_viewScale, 36*_viewScale, DeviceWidth-86*_viewScale, 45*_viewScale);
    [bottomBtn setBackgroundColor:[UIColor UIColorWithHexColorString:@"#32beff" AndAlpha:1]];
    bottomBtn.layer.cornerRadius = 22.5*_viewScale;
    [bottomBtn.layer masksToBounds];
    [bottomBtn setTitle:@"确认" forState:UIControlStateNormal];
    [bottomView addSubview:bottomBtn];
    _tableView.tableFooterView = bottomView;
}

#pragma mark --getting and setting

-(UITextField *)nameTF{
    if (!_nameTF) {
        if (iphone6P) {
            _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(DeviceWidth-300, 0, 285, 50)];
            _nameTF.font = [UIFont systemFontOfSize:16];
        }else{
            _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(DeviceWidth-270*_viewScale, 0, 255*_viewScale, 45*_viewScale)];
            _nameTF.font = [UIFont systemFontOfSize:15*_viewScale];
        }
        _nameTF.textAlignment = NSTextAlignmentRight;
    }
    return _nameTF;
}

-(UITextField *)phoneNumberTF{
    if (!_phoneNumberTF) {
        if (iphone6P) {
            _phoneNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(DeviceWidth-300, 0, 285, 50)];
            _phoneNumberTF.font = [UIFont systemFontOfSize:16];
        }else{
            _phoneNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(DeviceWidth-270*_viewScale, 0, 255*_viewScale, 45*_viewScale)];
            _phoneNumberTF.font = [UIFont systemFontOfSize:15*_viewScale];
            }
        _phoneNumberTF.textAlignment = NSTextAlignmentRight;
        _phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _phoneNumberTF;
}

-(UITextField *)detailAddressTF{
    if (!_detailAddressTF) {
        if (iphone6P) {
            _detailAddressTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, DeviceWidth-30, 50)];
            _detailAddressTF.font = [UIFont systemFontOfSize:14];
        }else{
            _detailAddressTF = [[UITextField alloc]initWithFrame:CGRectMake(15*_viewScale, 0, DeviceWidth-30*_viewScale, 45*_viewScale)];
            _detailAddressTF.font = [UIFont appFontRegularOfSize:14 * _viewScale];
        }
        _detailAddressTF.placeholder = @"请输出详细地址";
    }
    return _detailAddressTF;
}

-(UISwitch *)defaultAddressSwitch{
    if (!_defaultAddressSwitch) {
        _defaultAddressSwitch = [[UISwitch alloc]init];
//        _defaultAddressSwitch.layer.position = CGPointMake(0.5, 0.5);
        _defaultAddressSwitch.onTintColor = [UIColor UIColorWithHexColorString:@"#3eddb2" AndAlpha:1];
        _defaultAddressSwitch.transform =  CGAffineTransformMakeScale(_viewScale*0.75,_viewScale*0.75);
    }
    return _defaultAddressSwitch;
}

#pragma mark --tableViewDelegate DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else{
        return 1;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 10*_viewScale)];
    [headerView setBackgroundColor:[UIColor UIColorWithRed:238 green:238 blue:238 alpha:1]];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10*_viewScale;
    }else
        return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(iphone6P){
        return 50;
    }else
        return 45*_viewScale;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row < 2) {
        static  NSString * const textCellID = @"textCellID";
        UITableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:textCellID];
        if (!textCell) {
            textCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:textCellID];
            if (iphone6P) {
                textCell.textLabel.font = [UIFont systemFontOfSize:16];
            }else{
                textCell.textLabel.font = [UIFont appFontRegularOfSize:15 * _viewScale];
            }

        }
        if (indexPath.row == 0) {
            textCell.textLabel.text = @"收货人";
            [textCell.contentView addSubview:self.nameTF];
            self.nameTF.delegate = self;
        }else if (indexPath.row == 1){
            textCell.textLabel.text = @"联系电话";
            self.phoneNumberTF.delegate = self;
            [textCell.contentView addSubview:self.phoneNumberTF];
        }

        return textCell;
    }else if(indexPath.section == 0 && indexPath.row >=2 && indexPath.row < 4){
        static  NSString * const moreInfoCellID = @"moreInfoCellID";
        UITableViewCell *moreInfoCell = [tableView dequeueReusableCellWithIdentifier:moreInfoCellID];
        if (!moreInfoCell) {
            moreInfoCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:moreInfoCellID];
            if (iphone6P) {
                moreInfoCell.textLabel.font = [UIFont systemFontOfSize:16];
            }else{
                moreInfoCell.textLabel.font = [UIFont appFontRegularOfSize:15 * _viewScale];
            }
        }
        if (indexPath.row == 2) {
            moreInfoCell.textLabel.text = @"所在地区";
        }
        if (indexPath.row == 3) {
            moreInfoCell.textLabel.text = @"街道";
        }
        moreInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return  moreInfoCell;
    }else if (indexPath.row == 4){
        UITableViewCell *cell;
        if (iphone6P) {
            cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 45*_viewScale)];
        }else{
            cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 45*_viewScale)];
        }
        [cell.contentView addSubview:self.detailAddressTF];
        self.detailAddressTF.delegate = self;
        _defaultAddressSwitch.center = cell.contentView.center;
        return cell;
    }else{
        UITableViewCell *cell;
        if (iphone6P) {
           cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 50)];
        }else{
            cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 45*_viewScale)];
        }
    cell.textLabel.text = @"设为默认地址";
    cell.textLabel.font =[UIFont appFontRegularOfSize:15 * _viewScale];
    [cell.contentView addSubview:self.defaultAddressSwitch];
    CGFloat switchH = _defaultAddressSwitch.frame.size.height;
        if (iphone6P) {
            _defaultAddressSwitch.frame = CGRectMake(DeviceWidth - 50 * _viewScale, (55 - switchH) / 2, 89, 29);
        }else{
            _defaultAddressSwitch.frame = CGRectMake(DeviceWidth - 50 * _viewScale, (45 * _viewScale - switchH) / 2, 89, 29);
                }
        [_defaultAddressSwitch addTarget:self action:@selector(isDefaultAddress:) forControlEvents:UIControlEventValueChanged];
    return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark --textFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField isEqual:_nameTF]) {
        
    }else if ([textField isEqual:_phoneNumberTF]){
        
    }else if ([textField isEqual:_detailAddressTF]){
        
    }
}

#pragma mark --UISwitchMethod
-(void)isDefaultAddress:(UISwitch *)sender{
    if (sender.isOn == YES) {
        
    }else{
        
    }
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
