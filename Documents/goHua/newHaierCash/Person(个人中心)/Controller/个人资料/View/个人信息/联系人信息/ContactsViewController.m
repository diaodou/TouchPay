//
//  ContactsViewController.m
//  personMerchants
//
//  Created by 百思为科 on 17/1/10.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactRootViewController.h"
#import "AddressFailsViewController.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import "ContactInfoManager.h"
#import "HCMacro.h"
#import "UITypeClass.h"
#import "RMUniversalAlert.h"
#import "ReadManager.h"
#import "AppDelegate.h"
#import "UIFont+AppFont.h"
#import "UIButton+UnifiedStyle.h"

#import "PeoPleInfoTableViewCell.h"

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SendPhoneNumDelegate>

@property (nonatomic,strong) ContactInfoManager *contactInfo;  //联系人信息管理类

@property (nonatomic,strong) UITableView *contactTV;            //单位信息的视图

@property (nonatomic,strong) NSArray <NSArray *>*dataArray;     //数据源数组

@property (nonatomic,strong) UITextField *editTF;               //正在编辑的输入框

@property (nonatomic,assign) NSInteger warnCount;//提示次数

@end

@implementation ContactsViewController
{
    NSIndexPath *_selectIndexPath;      //当前点击的位置
}

#pragma mark - lifecircle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _warnCount = 0;
    
    //创建数据源
    [self initDataArray];
    //创建视图
    [self initContactTv];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canWrite) name:@"canWrite" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"canWrite" object:nil];
}

#pragma mark - 初始化视图
- (void)initContactTv
{
    _contactTV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight-154) style:UITableViewStylePlain];
    _contactTV.delegate = self;
    _contactTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    _contactTV.dataSource = self;
    [self.view addSubview:_contactTV];
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 75*scaleAdapter)];
    footView.backgroundColor = UIColorFromRGB(0xf6f6f6, 1.0);
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(11*scaleAdapter, 15*scaleAdapter, DeviceWidth-22*scaleAdapter, 45*scaleAdapter)];
    [nextBtn setButtonTitle:@"下一步" titleFont:14 buttonHeight:45 *scaleAdapter];
    [nextBtn addTarget:self action:@selector(creatNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:nextBtn];
    
    _contactTV.tableFooterView = footView;
}

#pragma mark - 点击事件
- (void)creatNextAction:(UIButton *)nextBtn
{
    [_editTF resignFirstResponder];
    //判断数据是否完善
    NSString *statusStr = [_contactInfo strInfoJudgeWithType];
    
    if([statusStr isEqualToString:@"success"])
    {
        NSArray *parmArray = [_contactInfo infoToJsonWithType];
        
        //将参数字典传回peopelView中
        self.sendParmDict(parmArray);
    }
    else
    {
        [self showAlertWithMessage:statusStr];
    }
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
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DeviceWidth, 30)];
    view.backgroundColor  = UIColorFromRGB(0xf6f6f6, 1.0);
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, DeviceWidth-20, 20)];
    titleLab.font = [UIFont systemFontOfSize:15.0f];
    if (_ifFromTE) {
        
        if(section == 0)
        {
            titleLab.text = @"联系人*一";
        }
        else if (section == 1)
        {
            titleLab.text = @"联系人*二";
        }
        else if (section == 2)
        {
            titleLab.text = @"联系人*三";
        }
    }else{
        
        if(section == 0)
        {
            titleLab.text = @"联系人*一";
        }
        else if (section == 1)
        {
            titleLab.text = @"联系人二";
        }
        else if (section == 2)
        {
            titleLab.text = @"联系人三";
        }
    }
    
    
    [view addSubview:titleLab];
    
    return view;
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
        [cell.tf setValue:[UIFont appFontRegularOfSize:10] forKeyPath:@"_placeholderLabel.font"];
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
    if(indexPath.row == 0)
    {
       self.showPikerViewShow(((UITypeClass *)_dataArray[indexPath.section][indexPath.row]).showType);
    }

    if(indexPath.row == 2)
    {
        _editTF = ((PeoPleInfoTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).tf;
        [self creatContactNum:indexPath.row indexPath:indexPath];
    }
}

#pragma mark - UITextFieldDelegate
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
    
    NSIndexPath *indexPath = [_contactTV indexPathForCell:cell];
    
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
#pragma mark - SendPhoneNumDelegate
//点击
- (void)sendPhone:(NSString *)number
{
    NSString *phoneNum = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = StringOrNull(phoneNum);
    
    [_contactTV reloadRowsAtIndexPaths:@[_selectIndexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)sendPhoneNumBack
{
    if([AppDelegate delegate].userInfo.whiteType == WhiteA)
    {
        _editTF.userInteractionEnabled = YES;
        _editTF.delegate = self;
        [_editTF becomeFirstResponder];
    }
}
#pragma mark - 联系人详情页面返回的通知
- (void)canWrite
{
    if([AppDelegate delegate].userInfo.whiteType == WhiteA)
    {
        _editTF.userInteractionEnabled = YES;
        _editTF.delegate = self;
        [_editTF becomeFirstResponder];
    }
}

#pragma mark - privateMethods
- (void)initDataArray
{
    _contactInfo = [[ContactInfoManager alloc] initWithType];
    //创建数据源
    [_contactInfo modelToInfo:self.contectBody];
    //得到数据源
    _dataArray = [_contactInfo arrayCompanyData];
}

//处理选择完数据
- (void)reloadTableViewWithDictionary:(NSDictionary *)dict andType:(ShowPickViewType)type
{
    if(type == ContactRelationType)
    {
        NSString *contactRelationType = [dict objectForKey:@"关系"];
        NSString *contactRelationTypeCode = [dict objectForKey:@"contactRelationTypeCode"];
        NSArray *codeArr = @[StringOrNull(contactRelationTypeCode)];
        
        //给数据源赋值
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).value = contactRelationType;
        ((UITypeClass *)_dataArray[_selectIndexPath.section][_selectIndexPath.row]).codeArr = codeArr;
    }
    
    [_contactTV reloadData];
}

//刷新数据源
- (void)reloadContactInfo
{
    //创建数据源
    [_contactInfo modelToInfo:self.contectBody];
    //得到数据源
    _dataArray = [_contactInfo arrayCompanyData];
    
    [_contactTV reloadData];
}

//读取通讯录,请求通讯录权限
- (void)creatContactNum:(NSInteger)laker indexPath:(NSIndexPath *)indexPah
{
    WEAKSELF
    [ReadManager shouquan:^(bool bGrant)
    {
        STRONGSELF
        if ([AppDelegate delegate].userInfo.whiteType == WhiteA)
        {
            if (strongSelf)
            {
                if (bGrant)
                {
                    [strongSelf judgeContact:laker indexPath:indexPah];
                }
                else
                {
                    
                    if([AppDelegate delegate].userInfo.whiteType == WhiteA && strongSelf.warnCount > 0)
                    {
                        dispatch_async(dispatch_get_main_queue(),^{
                            strongSelf.editTF.userInteractionEnabled = YES;
                            strongSelf.editTF.delegate = self;
                            [strongSelf.editTF becomeFirstResponder];
                        });
                    }
                    else
                    {
                        
                         strongSelf.warnCount++;
                        
                        [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请允许访问您的通讯录，否则会影响您的后续操作" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex)
                         {
                             if (strongSelf)
                             {
                                 if (buttonIndex == 1)
                                 {
                                     [strongSelf showSettingContactCont];
                                 }
                                 else
                                 {
                                     ((UITypeClass *)strongSelf.dataArray[indexPah.section][indexPah.row]).canEdit = YES;
                                     
                                     [strongSelf.contactTV reloadRowsAtIndexPaths:@[indexPah] withRowAnimation:UITableViewRowAnimationNone];
                                 }
                             }
                         }];
                    }
                }
            }
            
        }
        else
        {
            if (strongSelf)
            {
                if (bGrant)
                {
                     [strongSelf judgeContact:laker indexPath:indexPah];
                }
                else
                {
                    [RMUniversalAlert showAlertInViewController:self withTitle:@"提示" message:@"请允许访问您的通讯录，否则会影响您的后续操作" cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
                        if (strongSelf)
                        {
                            
                            if (buttonIndex == 1) {
                                
                                [self showSettingContactCont];
                                
                            }
                        }
                    }];
                    
                    
                }
            }
        }
    }];
    
}

//通讯录中联系人个数的风险控制
- (void)judgeContact:(NSInteger)laker indexPath:(NSIndexPath *)indexPah {
    
    if (IOS9_OR_LATER) {
        
        // 3.1.创建联系人仓库
        CNContactStore *store = [[CNContactStore alloc] init];
        // keys决定这次要获取哪些信息,比如姓名/电话
        NSArray *fetchKeys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
        
        NSError *error = nil;
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        [store enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            // stop是决定是否要停止
            // 1.获取姓名
            
            AddressBook* addressBook = [[AddressBook alloc]init];
            NSString *firstname = contact.givenName;
            NSString *lastname = contact.familyName;
            addressBook.fullName = [NSString stringWithFormat:@"%@%@",lastname,firstname];
            
            // 2.获取电话号码
            NSArray *phones = contact.phoneNumbers;
            
            NSMutableArray *jack = [[NSMutableArray alloc]init];
            
            // 3.遍历电话号码
            for (CNLabeledValue *labelValue in phones) {
                PhoneModel *model = [[PhoneModel alloc]init];
                
                NSString *test = [CNLabeledValue localizedStringForLabel:labelValue.label];
                model.telName =test;
                CNPhoneNumber *phoneNumber = labelValue.value;
                model.telNo = phoneNumber.stringValue;
                
                [jack addObject:model];
            }
            
            addressBook.phone = [NSArray arrayWithArray:jack];
            
            [array addObject:addressBook];
            
        }];
        
        int judget = 0;
        
        if ([AppDelegate delegate].userInfo.whiteType == WhiteB)
        {
            judget = 3;
            
        }
        else if ([AppDelegate delegate].userInfo.whiteType == WhiteSocityReason || [AppDelegate delegate].userInfo.whiteType == WhiteSocityNoReason)
        {
            judget = 10;
        }
        else if ([AppDelegate delegate].userInfo.whiteType == WhiteCReason || [AppDelegate delegate].userInfo.whiteType == WhiteCNoReason)
        {
            judget = 20;
        }
        else
        {
            judget = 0;
        }
        

        if (array.count >= judget) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                ContactRootViewController *rootVc = [[ContactRootViewController alloc]init];
                rootVc.newaArray = array;
                rootVc.delegate = self;
                rootVc.kiss = 2;   //传2表示选择手机号(传1表示选择名字,已被废弃)
                
                HCRootNavController *nav = [[HCRootNavController alloc] initWithRootViewController:rootVc];
                
                [self presentViewController:nav animated:YES completion:nil];
            });
            
            }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showAlertWithMessage:@"您暂不符合业务准入标准，请稍后进行申请"];
            });
        }
        
        
        return;
        
    }

    
    if ([ReadManager readUserPhoneAddress])
    {
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        [array addObjectsFromArray:[ReadManager readUserPhoneAddress]];
        
        int judget = 0;
        
        if ([AppDelegate delegate].userInfo.whiteType == WhiteB)
        {
            judget = 3;
            
        }
        else if ([AppDelegate delegate].userInfo.whiteType == WhiteSocityReason || [AppDelegate delegate].userInfo.whiteType == WhiteSocityNoReason)
        {
            judget = 10;
        }
        else if ([AppDelegate delegate].userInfo.whiteType == WhiteCReason || [AppDelegate delegate].userInfo.whiteType == WhiteCNoReason)
        {
            judget = 20;
        }
        else
        {
            judget = 0;
        }
        
        if (array.count >= judget)
        {
            
            ContactRootViewController *rootVc = [[ContactRootViewController alloc]init];
            rootVc.newaArray = array;
            rootVc.delegate = self;
            rootVc.kiss = 2;   //传2表示选择手机号(传1表示选择名字,已被废弃)
            
            HCRootNavController *nav = [[HCRootNavController alloc] initWithRootViewController:rootVc];
            
            [self presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            [self showAlertWithMessage:@"您暂不符合业务准入标准，请稍后进行申请"];
        }
    }
}

- (void)showSettingContactCont
{
    AddressFailsViewController *addrVc =[[AddressFailsViewController alloc]init];
    
    addrVc.title = @"联系人";
    HCRootNavController *nav = [[HCRootNavController alloc] initWithRootViewController:addrVc];
    
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

//判断当前view信息是否填完的方法
- (BOOL)judgeContactInfoCompelete
{
    if(_editTF)
    {
        [_editTF resignFirstResponder];
    }
    //判断数据是否完善
    NSString *statusStr = [_contactInfo strInfoJudgeWithType];
    if([statusStr isEqualToString:@"success"])
    {
        NSArray *parmDictArray = [_contactInfo infoToJsonWithType];
        
        //将参数字典传回peopelView中
        self.sendParmDict(parmDictArray);
        
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
