//
//  CompanyViewController.m
//  personMerchants
//
//  Created by LLM on 2017/1/5.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "CompanyViewController.h"

#import "HCMacro.h"
#import "CompanyInfo.h"
#import "UITypeClass.h"
#import "SearchCityOrCode.h"
#import "RMUniversalAlert.h"
#import "UIButton+UnifiedStyle.h"

#import "PeoPleInfoTableViewCell.h"

@interface CompanyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *companyTV;            //单位信息的视图

@property (nonatomic,strong) NSArray <NSArray *>*dataArray;     //数据源数组

@property (nonatomic,strong) CompanyInfo *companyInfo;          //数据管理类

@end

@implementation CompanyViewController
{
    NSIndexPath *_selectIndexPath;      //当前点击的位置
    
    UITextField *_editTF;               //正在编辑的输入框
}

#pragma mark - lifecircle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //创建数据源
    [self initDataArray];
    //创建视图
    [self initCompanyTv];
}

#pragma mark - 初始化视图
- (void)initCompanyTv
{
    _companyTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-154) style:UITableViewStylePlain];
    _companyTV.delegate = self;
    _companyTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _companyTV.dataSource = self;
    [self.view addSubview:_companyTV];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 75*scaleAdapter)];
    footView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(11*scaleAdapter, 15*scaleAdapter, DeviceWidth-22*scaleAdapter, 45*scaleAdapter)];
    [nextBtn setButtonTitle:@"下一步" titleFont:14 buttonHeight:45*scaleAdapter];
    [nextBtn addTarget:self action:@selector(creatNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:nextBtn];
    
    _companyTV.tableFooterView = footView;
}

#pragma mark - TableView Deledate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray[section].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45*scaleAdapter;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 1)
    {
        return 10*scaleAdapter;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"LabelCell";
    PeoPleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil)
    {
        cell = [[PeoPleInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.tf.text = @"";
    cell.tf.delegate = nil;
    //左边label
    ((UILabel *)cell.tf.leftView).text = ((UITypeClass *)_dataArray[indexPath.section][indexPath.row]).controlShowName;
    
    if(((UITypeClass *)_dataArray[indexPath.section][indexPath.row]).canEdit)
    {
        cell.tf.rightViewMode = UITextFieldViewModeNever;
        //textfield代理
        cell.tf.delegate = self;
        cell.tf.userInteractionEnabled = YES;
    }
    else
    {
        cell.tf.rightViewMode = UITextFieldViewModeAlways;
        cell.tf.userInteractionEnabled = NO;
    }
    
    if(((UITypeClass *)_dataArray[indexPath.section][indexPath.row]).keyBoardType == KeyBoardTypeNum)
    {
        cell.tf.keyboardType = UIKeyboardTypeNumberPad;
    }
    else if (((UITypeClass *)_dataArray[indexPath.section][indexPath.row]).keyBoardType == KeyBoardTypeDefault)
    {
        cell.tf.keyboardType = UIKeyboardTypeDefault;
    }
    
    cell.tf.text = ((UITypeClass *)_dataArray[indexPath.section][indexPath.row]).value;
    cell.tf.placeholder = ((UITypeClass *)_dataArray[indexPath.section][indexPath.row]).placeholder;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //记录当前选择的位置
    _selectIndexPath = indexPath;
    //调用block,创建PikerView,将type传过去
     if(((UITypeClass *)_dataArray[indexPath.section][indexPath.row]).canEdit == NO)
     {
         self.showPikerViewShow(((UITypeClass *)_dataArray[indexPath.section][indexPath.row]).showType);
     }
}

#pragma mark - uitextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell;
    if([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell *)textField.superview.superview;
    }
    else
    {
        cell = (UITableViewCell *)textField.superview.superview.superview;
    }
    
    NSIndexPath *indexPath = [_companyTV indexPathForCell:cell];
    
    _selectIndexPath = indexPath;
    
    _editTF = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = StringOrNull(textField.text);
    
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 点击事件
- (void)creatNextAction:(UIButton *)nextBtn
{
    [_editTF resignFirstResponder];
    //判断当前页面信息是否完善
    [self judgeCompanyInfoCompelete];
}

#pragma mark - privateMethods
- (void)initDataArray
{
    _companyInfo = [[CompanyInfo alloc] initWithType];
    //创建数据源
    [_companyInfo modelToInfo:self.companyBody];
    //得到数据源
    _dataArray = [_companyInfo arrayCompanyData];
}

//处理选择完数据
- (void)reloadTableViewWithDictionary:(NSDictionary *)dict andType:(ShowPickViewType)type
{
    if(type == WorkAddressCityPickType)
    {
        NSString *companyAddr = [dict objectForKey:@"单位地址"];
        NSString *privonceCode = [dict objectForKey:@"privonceCode"];
        NSString *cityCode = [dict objectForKey:@"cityCode"];
        NSString *areaCode = [dict objectForKey:@"areaCode"];
        NSArray *codeArr = @[StringOrNull(privonceCode),StringOrNull(cityCode),StringOrNull(areaCode)];
        
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = companyAddr;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    else if (type == JobType)
    {
        NSString *position = [dict objectForKey:@"职务"];
        NSString *positionCode = [dict objectForKey:@"positionCode"];
        NSArray *codeArr = @[StringOrNull(positionCode)];
        
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = position;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    else if (type == IndustryType)
    {
        NSString *comKind = [dict objectForKey:@"行业性质"];
        NSString *comKindCode = [dict objectForKey:@"comKindCode"];
        NSArray *codeArr = @[StringOrNull(comKindCode)];
        
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = comKind;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    else if (type == WorkType)
    {
        NSString *positionOPT = [dict objectForKey:@"从业性质"];
        NSString *positionOPTCode = [dict objectForKey:@"positionOPTCode"];
        NSArray *codeArr = @[StringOrNull(positionOPTCode)];
        
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = positionOPT;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    
    //刷新
    [_companyTV reloadData];
}

//供判断当前view信息是否填完的方法
- (BOOL)judgeCompanyInfoCompelete
{
    if(_editTF)
    {
        [_editTF resignFirstResponder];
    }
    //判断数据是否完善
    NSString *statusStr = [_companyInfo strInfoJudge];
    if([statusStr isEqualToString:@"success"])
    {
        NSDictionary *parmDict = [_companyInfo infoToJsonWithType];
        
        //将参数字典传回peopelView中
        self.sendParmDict(parmDict);
        
        return YES;
    }
    else
    {
        [self showAlertWithMessage:statusStr];
        
        return NO;
    }
}

//刷新数据源
- (void)reloadCompanyInfo
{
    //创建数据源
    [_companyInfo modelToInfo:self.companyBody];
    //得到数据源
    _dataArray = [_companyInfo arrayCompanyData];
    
    [_companyTV reloadData];
}

- (void)showAlertWithMessage:(NSString *)message
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:message cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex)
     {
         STRONGSELF
         if (strongSelf)
         {
             if (buttonIndex == 0)
             {
             }
         }
     }];
}
@end
