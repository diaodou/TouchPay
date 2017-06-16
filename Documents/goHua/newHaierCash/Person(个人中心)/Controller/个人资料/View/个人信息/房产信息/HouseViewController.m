//
//  HouseViewController.m
//  personMerchants
//
//  Created by 百思为科 on 17/1/10.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "HouseViewController.h"
#import "PeoPleInfoTableViewCell.h"
#import "HCMacro.h"
#import "HouseInfo.h"
#import "UITypeClass.h"
#import "SearchCityOrCode.h"
#import "RMUniversalAlert.h"
#import <MBProgressHUD.h>
#import "UIButton+UnifiedStyle.h"
@interface HouseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSIndexPath *_selectIndexPath;      //当前点击的位置
 
    NSString * _houseSituation;          //房产状况
    
    UITextField *_editTF;               //正在编辑的输入框
}

@property (nonatomic,strong) UITableView *houseTV;       //房产信息的视图

@property (nonatomic,strong) NSArray <NSArray *>*dataArray;           //数据源数组
@property (nonatomic,strong) HouseInfo *houseInfo;           //数据管理类

@end

@implementation HouseViewController

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
    _houseTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-144) style:UITableViewStylePlain];
    _houseTV.delegate = self;
    _houseTV.dataSource = self;
    _houseTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_houseTV];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 75*scaleAdapter)];
    footView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(11*scaleAdapter, 15*scaleAdapter, DeviceWidth-22*scaleAdapter, 45*scaleAdapter)];
    [nextBtn setButtonTitle:@"下一步" titleFont:14 buttonHeight:45*scaleAdapter];
    [nextBtn addTarget:self action:@selector(creatNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:nextBtn];
    _houseTV.tableFooterView = footView;
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
    static NSString * cellID = @"house";
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
    if (((UITypeClass *)_dataArray[indexPath.section][indexPath.row]).canEdit == NO) {
        //调用block,创建PikerView,将type传过去
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
    
    NSIndexPath *indexPath = [_houseTV indexPathForCell:cell];
    
    _selectIndexPath = indexPath;
    
    _editTF = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = StringOrNull(textField.text);
    
    [textField resignFirstResponder];
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
    NSString *statusStr = [_houseInfo strInfoJudge];
    if([statusStr isEqualToString:@"success"])
    {
        NSDictionary *parmDict = [[NSDictionary alloc]init];
        
        if ([((UITypeClass *)_dataArray[0][0]).value isEqualToString:@"自购现无贷款"])
        {
            parmDict = [_houseInfo infoToJsonWithType:HaveHouseNoLoan];
        }else if ([((UITypeClass *)_dataArray[0][0]).value isEqualToString:@"自购现有贷款"])
        {
            parmDict = [_houseInfo infoToJsonWithType:HaveHouseHaveLoan];
        }else
        {
            parmDict = [_houseInfo infoToJsonWithType:Other];
        }
        
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
    _houseSituation = [_houseInfo houseSituation:self.houseBody];
    
    [self reloadHouseInfoData];
    
}
//刷新数据源
- (void)reloadHouseInfo
{
    [self initDataArray];
}

- (void)reloadHouseInfoData{

    if ([_houseSituation isEqualToString:@"自购现无贷款"])
    {
        _houseInfo = [[HouseInfo alloc] initWithType:HaveHouseNoLoan];
        //创建数据源
        [_houseInfo modelToInfo:self.houseBody WithType:HaveHouseNoLoan];
    }
    else if ([_houseSituation isEqualToString:@"自购现有贷款"])
    {
        _houseInfo = [[HouseInfo alloc] initWithType:HaveHouseHaveLoan];
        //创建数据源
        [_houseInfo modelToInfo:self.houseBody WithType:HaveHouseHaveLoan];
    }
    else
    {
        _houseInfo = [[HouseInfo alloc] initWithType:Other];
        //创建数据源
        [_houseInfo modelToInfo:self.houseBody WithType:Other];
    }
    
    //得到数据源
    _dataArray = [_houseInfo arrayPersonData];
    
    [_houseTV reloadData];
}
- (void)OnlyReloadHouseState{
    if ([_houseSituation isEqualToString:@"自购现无贷款"])
    {
        _houseInfo = [[HouseInfo alloc] initWithType:HaveHouseNoLoan];
    }
    else if ([_houseSituation isEqualToString:@"自购现有贷款"])
    {
        _houseInfo = [[HouseInfo alloc] initWithType:HaveHouseHaveLoan];
    }
    else
    {
        _houseInfo = [[HouseInfo alloc] initWithType:Other];
    }
    //得到数据源
    _dataArray = [_houseInfo arrayPersonData];
}
- (void)reloadTableViewWithDictionary:(NSDictionary *)dict andType:(ShowPickViewType)type{
    //房产状况
    if (type == RealEstateSituationType)
    {
        NSString *liveInfo = [dict objectForKey:@"房产状况"];
        NSString *liveInfoCode = [dict objectForKey:@"liveInfoCode"];
        NSArray *codeArr = @[StringOrNull(liveInfoCode)];
        
        if (![_houseSituation isEqualToString:[dict objectForKey:@"房产状况"]])
        {
            _houseSituation = [dict objectForKey:@"房产状况"];
            [self OnlyReloadHouseState];
            //给数据源赋值
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = liveInfo;
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
            
        }
    }
    //房产地址
    else if (type == RealEstatePlaceType)
    {
        NSString *pptyliveAddr = [dict objectForKey:@"addressAddr"];
        NSString *pptyliveAddrInt = [dict objectForKey:@"addressAddrInt"];
        
        NSString *pptylive = [dict objectForKey:@"address"];
        NSString *pptylivePrivonce = [dict objectForKey:@"addressPrivonce"];
        NSString *pptyliveCity = [dict objectForKey:@"addressCity"];
        NSString *pptyliveArea = [dict objectForKey:@"addressArea"];
        NSString *pptyliveDetail = [dict objectForKey:@"addressDetail"];
        
        NSArray *codeArr;
        if(pptyliveAddrInt)//同现住房地址
        {
            codeArr = @[StringOrNull(pptyliveAddrInt)];
            //给数据源赋值
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = pptyliveAddr;
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
        }
        else
        {
            codeArr = @[StringOrNull(pptylivePrivonce),StringOrNull(pptyliveCity),StringOrNull(pptyliveArea),StringOrNull(pptyliveDetail),@"30"];
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = pptylive;
            ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
        }
    }
    //居住年限
    else if (type == ResidenceTimeType)
    {
        NSString *liveYear = [dict objectForKey:@"居住年限"];
        NSString *liveYearCode = [dict objectForKey:@"liveYearCode"];
        NSArray *codeArr = @[StringOrNull(liveYearCode)];
        
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = liveYear;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    
    [_houseTV reloadData];
}
//供判断当前view信息是否填完的方法
- (BOOL)judgePersonInfoCompelete
{
    if(_editTF)
    {
        [_editTF resignFirstResponder];
    }
    //判断数据是否完善
    NSString *statusStr = [_houseInfo strInfoJudge];
    if([statusStr isEqualToString:@"success"])
    {
        NSDictionary *parmDict = [[NSDictionary alloc]init];
        if ([((UITypeClass *)_dataArray[0][0]).value isEqualToString:@"自购现无贷款"])
        {
            parmDict = [_houseInfo infoToJsonWithType:HaveHouseNoLoan];
        }else if ([((UITypeClass *)_dataArray[0][0]).value isEqualToString:@"自购现有贷款"])
        {
            parmDict = [_houseInfo infoToJsonWithType:HaveHouseHaveLoan];
        }else
        {
            parmDict = [_houseInfo infoToJsonWithType:Other];
        }
        
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
