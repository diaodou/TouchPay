//
//  ContactInfo.m
//  personMerchants
//
//  Created by LLM on 2017/1/12.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "ContactInfoManager.h"
#import "UITypeClass.h"
#import "AppDelegate.h"
#import "HCMacro.h"
#import "DefineSystemTool.h"

@implementation ContactInfoManager
{
    NSArray <NSArray*> *_arrData;
    
    NSMutableArray *_idArray;
}

- (instancetype)initWithType
{
    self = [super init];
    if (self)
    {
        [self initDataWithType];
    }
    
    return self;
}

- (NSArray <NSArray *>*)arrayCompanyData
{
    return _arrData;
}

- (void)initDataWithType
{
    _arrData = [NSArray array];


        UITypeClass *control1 = [[UITypeClass alloc]init];
        control1.controlShowName = @"关系";
        control1.canEdit = NO;
        control1.showType = ContactRelationType;
        control1.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,}$";
        control1.placeholder = @"";
        control1.errorTip = @"请选择联系人关系";
        control1.keyBoardType = KeyBoardTypeDefault;
        
        UITypeClass *control2 = [[UITypeClass alloc]init];
        control2.controlShowName = @"姓名";
        control2.canEdit = YES;
        control2.regular = @"[\u4E00-\u9FA5]{2,10}(?:(·|•)[\u4E00-\u9FA5]{2,10})*$";
        control2.placeholder = @"";
        control2.placeholder = @"请输入联系人姓名";
        control2.errorTip = @"请输入联系人姓名(不能包含字母，数字，特殊字符)";
        
        UITypeClass *control3 = [[UITypeClass alloc]init];
        control3.controlShowName = @"联系电话";
        control3.canEdit = NO;
        control3.regular = @"^[0-9]{11,12}$";
        control3.placeholder = @"";
        control3.errorTip = @"选择或输入11或12位的联系人电话";
        control3.keyBoardType = KeyBoardTypeDefault;
        
        UITypeClass *control4 = [[UITypeClass alloc]init];
        control4.controlShowName = @"关系";
        control4.canEdit = NO;
        control4.showType = ContactRelationType;
        control4.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,}$";
        control4.placeholder = @"";
        control4.errorTip = @"请选择联系人关系";
        control4.keyBoardType = KeyBoardTypeDefault;
        
        UITypeClass *control5 = [[UITypeClass alloc]init];
        control5.controlShowName = @"姓名";
        control5.canEdit = YES;
        control5.regular = @"[\u4E00-\u9FA5]{2,10}(?:(·|•)[\u4E00-\u9FA5]{2,10})*$";
        control5.placeholder = @"";
        control5.placeholder = @"请输入联系人姓名";
        control5.errorTip = @"请输入联系人姓名(不能包含字母，数字，特殊字符)";
        
        UITypeClass *control6 = [[UITypeClass alloc]init];
        control6.controlShowName = @"联系电话";
        control6.canEdit = NO;
        control6.regular = @"^[0-9]{11,12}$";
        control6.placeholder = @"";
        control6.errorTip = @"选择或输入11或12位的联系人电话";
        control6.keyBoardType = KeyBoardTypeDefault;
        
        UITypeClass *control7 = [[UITypeClass alloc]init];
        control7.controlShowName = @"关系";
        control7.canEdit = NO;
        control7.showType = ContactRelationType;
        control7.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5·]{1,}$";
        control7.placeholder = @"";
        control7.errorTip = @"请选择联系人关系";
        control7.keyBoardType = KeyBoardTypeDefault;
        
        UITypeClass *control8 = [[UITypeClass alloc]init];
        control8.controlShowName = @"姓名";
        control8.canEdit = YES;
        control8.regular = @"[\u4E00-\u9FA5]{2,10}(?:(·|•)[\u4E00-\u9FA5]{2,10})*$";
        control8.placeholder = @"";
        control8.placeholder = @"请输入联系人姓名";
        control8.errorTip = @"请输入联系人姓名(不能包含字母，数字，特殊字符)";
        
        UITypeClass *control9 = [[UITypeClass alloc]init];
        control9.controlShowName = @"联系电话";
        control9.canEdit = NO;
        control9.regular = @"^[0-9]{11,12}$";
        control9.placeholder = @"";
        control9.errorTip = @"选择或输入11或12位的联系人电话";
        control9.keyBoardType = KeyBoardTypeDefault;
        
        NSArray *arrData1 = [NSArray arrayWithObjects:control1,control2,control3,nil];
        NSArray *arrData2 = [NSArray arrayWithObjects:control4,control5,control6,nil];
        NSArray *arrData3 = [NSArray arrayWithObjects:control7,control8,control9,nil];
        
        _arrData = @[arrData1,arrData2,arrData3];
    }

- (void)modelToInfo:(ContactBody *)contactBody
{
    _idArray = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",nil];
    
        if(contactBody.lxrList.count >= 3)
        {
            for (int i = 0; i < 3; i++)
            {
                if(contactBody.lxrList[i].relationType && contactBody.lxrList[i].relationType.length > 0)
                {
                    ((UITypeClass *)_arrData[i][0]).codeArr = @[contactBody.lxrList[i].relationType];
                    
                    ((UITypeClass *)_arrData[i][0]).value = [DefineSystemTool stringForCode:contactBody.lxrList[i].relationType WithType:@"RELATION"];
                }

                if(contactBody.lxrList[i].contactName.length > 0)
                {
                    ((UITypeClass *)_arrData[i][1]).value = contactBody.lxrList[i].contactName;
                }
                
                if(contactBody.lxrList[i].contactMobile.length > 0)
                {
                    ((UITypeClass *)_arrData[i][2]).value = contactBody.lxrList[i].contactMobile;
                }
                
                if(contactBody.lxrList[i].Id.length > 0)
                {
                    //存储标识
                    [_idArray replaceObjectAtIndex:i withObject:contactBody.lxrList[i].Id];
                }
            }
        }
        else
        {
            for (int i = 0; i < contactBody.lxrList.count; i++)
            {
                if(contactBody.lxrList[i].relationType.length > 0)
                {
                    ((UITypeClass *)_arrData[i][0]).codeArr = @[contactBody.lxrList[i].relationType];
                    
                    ((UITypeClass *)_arrData[i][0]).value = [DefineSystemTool stringForCode:contactBody.lxrList[i].relationType WithType:@"RELATION"];
                }
                
                if(contactBody.lxrList[i].contactName.length > 0)
                {
                    ((UITypeClass *)_arrData[i][1]).value = contactBody.lxrList[i].contactName;
                }
                
                if(contactBody.lxrList[i].contactMobile.length > 0)
                {
                    ((UITypeClass *)_arrData[i][2]).value = contactBody.lxrList[i].contactMobile;
                }
                
                if(contactBody.lxrList[i].Id.length > 0)
                {
                    //存储标识
                    [_idArray replaceObjectAtIndex:i withObject:contactBody.lxrList[i].Id];
                }
            }
        }
}

//创建上传数据的参数字典数组
- (NSMutableArray *)infoToJsonWithType;
{
    
    NSMutableArray *dictArray = [[NSMutableArray alloc] init];
    
    if(_ifFromTE)
    {
        for(int i = 0; i < _arrData.count; i++)
        {
            NSMutableDictionary *parmDict = [[NSMutableDictionary alloc] init];
            
            if ([AppDelegate delegate].userInfo.custNum && [AppDelegate delegate].userInfo.custNum.length > 0)
            {
                [parmDict setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
            }
            
            NSString *relationType = ((UITypeClass *)_arrData[i][0]).codeArr[0];
            [parmDict setObject:relationType forKey:@"relationType"];
            
            NSString *contactName = ((UITypeClass *)_arrData[i][1]).value;
            [parmDict setObject:contactName forKey:@"contactName"];
            
            NSString *contactMobile = ((UITypeClass *)_arrData[i][2]).value;
            [parmDict setObject:contactMobile forKey:@"contactMobile"];
            
            [parmDict setObject:StringOrNull(_idArray[i]) forKey:@"id"];
            
            [parmDict setObject:@"app_person" forKey:@"dataFrom"];
            
            [dictArray addObject:parmDict];
        }
    }
    else
    {
        for(int i = 0; i < _arrData.count; i++)
        {
            if(((UITypeClass *)_arrData[i][0]).value.length > 0)
            {
                NSMutableDictionary *parmDict = [[NSMutableDictionary alloc] init];
                
                if ([AppDelegate delegate].userInfo.custNum && [AppDelegate delegate].userInfo.custNum.length > 0)
                {
                    [parmDict setObject:[AppDelegate delegate].userInfo.custNum forKey:@"custNo"];
                }
                
                NSString *relationType = ((UITypeClass *)_arrData[i][0]).codeArr[0];
                [parmDict setObject:relationType forKey:@"relationType"];
                
                NSString *contactName = ((UITypeClass *)_arrData[i][1]).value;
                [parmDict setObject:contactName forKey:@"contactName"];
                
                NSString *contactMobile = ((UITypeClass *)_arrData[i][2]).value;
                [parmDict setObject:contactMobile forKey:@"contactMobile"];
                
                [parmDict setObject:StringOrNull(_idArray[i]) forKey:@"id"];
                
                [parmDict setObject:@"app_person" forKey:@"dataFrom"];
                
                [dictArray addObject:parmDict];
            }
        }
    }
    
    return dictArray;
}

//判断数据是否符合要求
- (NSString *)strInfoJudgeWithType
{
 
    if(_ifFromTE)
    {
        for (NSArray *arr in _arrData)
        {
            for (UITypeClass *model in arr)
            {
                NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",model.regular];
                if (![numberPre evaluateWithObject:model.value])
                {
                    return model.errorTip;
                }
                
                NSString *string = [AppDelegate delegate].userInfo.realTel;
                
                if ([model.controlShowName isEqualToString:@"联系电话"] && [model.controlShowName isEqualToString:string]) {
                    
                    return @"联系人手机号不能与申请人手机号一样，请修改";
                    
                }
            }
        }
    }
    else
    {
        NSInteger num = 0;    //记录总共有几条是完善的
        for(NSArray *arr in _arrData)
        {
            if(((UITypeClass *)arr[0]).value.length > 0 && ((UITypeClass *)arr[1]).value.length > 0 && ((UITypeClass *)arr[2]).value.length > 0)
            {
                
                NSString *string = [AppDelegate delegate].userInfo.realTel;
                
                if ([((UITypeClass *)arr[2]).value isEqualToString:string]) {
                    
                    return @"联系人手机号不能与申请人手机号一样，请修改";
                    
                }
                
                //这一条是完善的
                num ++;
            }
            else
            {
                if(((UITypeClass *)arr[0]).value.length != 0 || ((UITypeClass *)arr[1]).value.length != 0 || ((UITypeClass *)arr[2]).value.length != 0)
                {
                    for (UITypeClass *model in arr)
                    {
                        NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",model.regular];
                        if (![numberPre evaluateWithObject:model.value])
                        {
                            return model.errorTip;
                        }
                    }
                }
            }
            
            if(num > 0)
            {
                if(((UITypeClass *)arr[0]).value.length != 0 || ((UITypeClass *)arr[1]).value.length != 0 || ((UITypeClass *)arr[2]).value.length != 0)
                {
                    for (UITypeClass *model in arr)
                    {
                        NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",model.regular];
                        if (![numberPre evaluateWithObject:model.value])
                        {
                            return model.errorTip;
                        }
                    }
                }
                else
                {
                    break;
                }
                
            }
            
            
        }
        
        if (num == 0) {
            
            return @"请填写联系人信息";
            
        }
        
    }
    
    if([[AppDelegate delegate].userInfo.marryStatues isEqualToString:@"已婚"])
    {
        int count = 0;
        for(NSArray *arr in _arrData)
        {
            if([((UITypeClass *)arr[0]).value isEqualToString:@"夫妻"])
            {
                break;
            }
            count ++;
        }
        
        if(count == _arrData.count)
        {
            return @"您是已婚状态,请选择一个关系为夫妻的联系人";
        }
    }
    
    return @"success";}


@end
