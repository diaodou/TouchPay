//
//  PersonViewController.m
//  personMerchants
//
//  Created by 百思为科 on 17/1/10.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "PersonViewController.h"
#import "PeoPleInfoTableViewCell.h"
#import "HCMacro.h"
#import "PersonInfo.h"
#import "UITypeClass.h"
#import "SearchCityOrCode.h"
#import "RMUniversalAlert.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>
#import "UIButton+UnifiedStyle.h"
@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSIndexPath *_selectIndexPath;      //当前点击的位置
    
    UITextField *_editTF;               //正在编辑的输入框
}

@property (nonatomic,strong) UITableView *personTV;       //单位信息的视图

@property (nonatomic,strong) NSArray <NSArray *>*dataArray;           //数据源数组

@property (nonatomic,strong) PersonInfo *personInfo;          //数据管理类

@end

@implementation PersonViewController

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
    _personTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-144) style:UITableViewStylePlain];
    _personTV.delegate = self;
    _personTV.dataSource = self;
    _personTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_personTV];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 75*scaleAdapter)];
    footView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(11*scaleAdapter, 15*scaleAdapter, DeviceWidth-22*scaleAdapter, 45*scaleAdapter)];
    [nextBtn setButtonTitle:@"下一步" titleFont:14 buttonHeight:45*scaleAdapter];
    [nextBtn addTarget:self action:@selector(creatNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:nextBtn];
    _personTV.tableFooterView = footView;
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
    if(section == 0)
    {
        return 0;
    }
    
    return 10*scaleAdapter;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"person";
    PeoPleInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[PeoPleInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
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
    
    NSIndexPath *indexPath = [_personTV indexPathForCell:cell];
    
    _selectIndexPath = indexPath;
    
    _editTF = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = StringOrNull(textField.text);
    [textField resignFirstResponder];
    _editTF = nil;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - 点击事件
- (void)creatNextAction:(UIButton *)nextBtn
{
    [_editTF resignFirstResponder];
    //判断数据是否完善
    NSString *statusStr = [_personInfo strInfoJudge];
    if([statusStr isEqualToString:@"success"])
    {
        NSDictionary *parmDict = [_personInfo infoToJsonWithType];
        
        //将参数字典传回peopelView中
        self.sendParmDict(parmDict);
    }
    else
    {
        [self showAlertWithMessage:statusStr];
    }
}
#pragma mark - privateMethods
- (void)initDataArray
{
    _personInfo = [[PersonInfo alloc] initWithType];
    //创建数据源
    [_personInfo modelToInfo:self.personBody];
    //得到数据源
    _dataArray = [_personInfo arrayPersonData];
}
//处理选择数据
- (void)reloadTableViewWithDictionary:(NSDictionary *)dict andType:(ShowPickViewType)type{
    //最高学历
    if (type == HighestDegreeType)
    {
        NSString *education = [dict objectForKey:@"最高学历"];
        NSString *educationCode = [dict objectForKey:@"educationCode"];
        NSArray *codeArr = @[StringOrNull(educationCode)];
        
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = education;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    //户口性质
    else if (type == ResidencePickType)
    {
        NSString *localResid = [dict objectForKey:@"户口性质"];
        NSString *localResidCode = [dict objectForKey:@"localResidCode"];
        NSArray *codeArr = @[StringOrNull(localResidCode)];
        
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = localResid;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    //居住地址
    else if(type == LiveAddressCityPickType)
    {
        NSString *liveAddr = [dict objectForKey:@"居住地址"];
        NSString *privonceCode = [dict objectForKey:@"privonceCode"];
        NSString *cityCode = [dict objectForKey:@"cityCode"];
        NSString *areaCode = [dict objectForKey:@"areaCode"];
        NSArray *codeArr = @[StringOrNull(privonceCode),StringOrNull(cityCode),StringOrNull(areaCode)];
        
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = liveAddr;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    //婚姻状况
    else if (type == MarriedPickType)
    {
        NSString *maritalStatus = [dict objectForKey:@"婚姻状况"];
        NSString *maritalStatusCode = [dict objectForKey:@"maritalStatusCode"];
        NSArray *codeArr = @[StringOrNull(maritalStatusCode)];
        
        [AppDelegate delegate].userInfo.marryStatues = maritalStatus;
        if([maritalStatus isEqualToString:@"已婚"])
        {
            [self showAlertWithMessage:@"您已已婚,联系人请选择夫妻"];
        }
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = maritalStatus;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    //供养人数
    else if (type == SupportNumberType)
    {
        NSString *providerNum = [dict objectForKey:@"供养人数"];
        NSString *providerNumCode = [dict objectForKey:@"providerNumCode"];
        NSArray *codeArr = @[StringOrNull(providerNumCode)];
        
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = providerNum;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    //信用卡数量
    else if (type == CreditCardsNumberType)
    {
        NSString *creditCount = [dict objectForKey:@"信用卡数量"];
        NSString *creditCountCode = [dict objectForKey:@"creditCountCode"];
        NSArray *codeArr = @[StringOrNull(creditCountCode)];
        
        if(creditCount.intValue == 0)
        {
            //将最高额度字段删除
             if(_dataArray[3].count == 2)
             {
                 _dataArray = [_personInfo deleteZGEDUIType];
                 [_personTV reloadData];
             }
        }
        else
        {
            if(_dataArray[3].count == 1)
            {
                //将最高额度重新插入
                _dataArray = [_personInfo insertZGEDUIType];
                [_personTV reloadData];
            }
        }
        
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = creditCount;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    //户籍地址
    else if (type == PermanentAddressType)
    {
        NSString *permanentAddr = [dict objectForKey:@"permanentAddr"];
        NSString *permanentAddrInt = [dict objectForKey:@"permanentAddrInt"];
        
        NSString *address = [dict objectForKey:@"address"];
        NSString *addressPrivonce = [dict objectForKey:@"addressPrivonce"];
        NSString *addressCity = [dict objectForKey:@"addressCity"];
        NSString *addressArea = [dict objectForKey:@"addressArea"];
        NSString *addressDetail = [dict objectForKey:@"addressDetail"];
        
        NSArray *codeArr;
        if(permanentAddrInt)//同住宅地址
        {
            codeArr = @[StringOrNull(permanentAddrInt)];
            //给数据源赋值
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = permanentAddr;
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
        }
        else
        {
            codeArr = @[StringOrNull(addressPrivonce),StringOrNull(addressCity),StringOrNull(addressArea),StringOrNull(addressDetail),@"N"];
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = address;
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
        }
    }
    //通讯地址
    else if (type == PostalAddressType)
    {
        NSString *postAddr = [dict objectForKey:@"postAddr"];
        NSString *postAddrInt = [dict objectForKey:@"postAddrInt"];
        
        NSString *address = [dict objectForKey:@"address"];
        NSString *addressPrivonce = [dict objectForKey:@"addressPrivonce"];
        NSString *addressCity = [dict objectForKey:@"addressCity"];
        NSString *addressArea = [dict objectForKey:@"addressArea"];
        NSString *addressDetail = [dict objectForKey:@"addressDetail"];
        
        NSArray *codeArr;
        if(postAddr)
        {
            codeArr = @[StringOrNull(postAddrInt)];
            //给数据源赋值
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = postAddr;
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
        }
        else
        {
            codeArr = @[StringOrNull(addressPrivonce),StringOrNull(addressCity),StringOrNull(addressArea),StringOrNull(addressDetail),@"O"];
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = address;
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
        }
    }
    else if (type == PersonEstateSituationType)
    {
        NSString *liveInfo = [dict objectForKey:@"房产状况"];
        NSString *liveInfoCode = [dict objectForKey:@"liveInfoCode"];
        NSArray *codeArr = @[StringOrNull(liveInfoCode)];
        
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = liveInfo;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }

    
    [_personTV reloadData];
}

//刷新数据源
- (void)reloadPersonInfo
{
    //创建数据源
    [_personInfo modelToInfo:self.personBody];
    //得到数据源
    _dataArray = [_personInfo arrayPersonData];
    
    [_personTV reloadData];
}

//供判断当前view信息是否填完的方法
- (BOOL)judgePersonInfoCompelete
{
    if (_editTF) {
        
        [_editTF resignFirstResponder];
        
    }
    
    //判断数据是否完善
    NSString *statusStr = [_personInfo strInfoJudge];
    if([statusStr isEqualToString:@"success"])
    {
        NSDictionary *parmDict = [_personInfo infoToJsonWithType];
        
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
