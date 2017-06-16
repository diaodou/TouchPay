//
//  CompanyModel.m
//  TestC
//
//  Created by xuxie on 17/1/3.
//  Copyright © 2017年 chinaredstar. All rights reserved.
//

#import "CompanyInfo.h"
#import "UITypeClass.h"
#import "AppDelegate.h"
#import "SearchCityOrCode.h"
#import "HCMacro.h"
#import <UIKit/UIKit.h>
#import "DefineSystemTool.h"
#import "NSString+CheckConvert.h"
@interface CompanyInfo()
{
    NSArray <NSArray*> *_arrData;
    
    NSArray *_dictArr;             //字典项数组
}
@end

@implementation CompanyInfo

#pragma mark - lift Cycle
- (instancetype)initWithType
{
    self = [super init];
    if (self)
    {
        [self initDataWithType];
    }
    
    return self;
}

- (void)dealloc {
    
}

#pragma mark - private Method

- (NSArray <NSArray *>*)arrayCompanyData
{
    return _arrData;
}

- (void)initDataWithType
{
    _arrData = [NSArray array];
    
 
        NSArray *arrData1 = [NSArray array];
        NSArray *arrData2 = [NSArray array];
        
        UITypeClass *control1 = [[UITypeClass alloc]init];
        control1.controlShowName = @"工作单位";
        control1.controlClassName = NSStringFromClass([UITextField class]);
        control1.canEdit = YES;
        control1.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{2,50}$";
        control1.placeholder = @"请输入工作单位";
        control1.errorTip = @"请输入2-50字的工作单位,且不能含有特殊字符或空格";
        control1.keyBoardType = KeyBoardTypeDefault;
        
        UITypeClass *control2 = [[UITypeClass alloc]init];
        control2.controlShowName = @"单位地址";
        control2.showType = WorkAddressCityPickType;
        control2.controlClassName = NSStringFromClass([UITextField class]);
        control2.canEdit = NO;
        control2.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,}$";
        control2.placeholder = @"";
        control2.errorTip = @"请选择单位地址";
        
        UITypeClass *control3 = [[UITypeClass alloc]init];
        control3.controlShowName = @"详细地址";
        control3.controlClassName = NSStringFromClass([UITextField class]);
        control3.canEdit = YES;
        control3.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,50}$";
        control3.placeholder = @"请输入详细地址";
        control3.errorTip = @"请输入详细地址,且不能含有特殊字符或空格";
        control3.keyBoardType = KeyBoardTypeDefault;
        
        UITypeClass *control4 = [[UITypeClass alloc]init];
        control4.controlShowName = @"职务";
        control4.showType = JobType;
        control4.controlClassName = NSStringFromClass([UITextField class]);
        control4.canEdit = NO;
        control4.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,}$";
        control4.placeholder = @"";
        control4.errorTip = @"请选择职务";
        
        UITypeClass *control5 = [[UITypeClass alloc]init];
        control5.controlShowName = @"单位电话";
        control5.controlClassName = NSStringFromClass([UITextField class]);
        control5.canEdit = YES;
        control5.regular = @"^\\d{11,12}$";
        control5.placeholder = @"请输入单位电话";
        control5.errorTip = @"请输入11或12位的单位电话";
        control5.keyBoardType = KeyBoardTypeNum;
        
        arrData1 = [NSArray arrayWithObjects:control1,control2,control3,control4,control5, nil];
        
        
        UITypeClass *control6 = [[UITypeClass alloc]init];
        control6.controlShowName = @"行业性质";
        control6.controlClassName = NSStringFromClass([UITextField class]);
        control6.canEdit = NO;
        control6.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5/]{1,}$";
        control6.placeholder = @"";
        control6.showType = IndustryType;
        control6.errorTip = @"请选择行业性质";
        
        UITypeClass *control7 = [[UITypeClass alloc]init];
        control7.controlShowName = @"所在部门";
        control7.controlClassName = NSStringFromClass([UITextField class]);
        control7.canEdit = YES;
        control7.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,}$";
        control7.placeholder = @"请输入所在部门";
        control7.errorTip = @"请输入所在部门,且不能含有特殊字符或空格";
        control7.keyBoardType = KeyBoardTypeDefault;
        
        UITypeClass *control8 = [[UITypeClass alloc]init];
        control8.controlShowName = @"从业性质";
        control8.controlClassName = NSStringFromClass([UITextField class]);
        control8.canEdit = NO;
        control8.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,}$";
        control8.showType = WorkType;
        control8.placeholder = @"";
        control8.errorTip = @"请选择从业性质";
        
        UITypeClass *control9 = [[UITypeClass alloc]init];
        control9.controlShowName = @"月收入";
        control9.controlClassName = NSStringFromClass([UITextField class]);
        control9.canEdit = YES;
        control9.regular = @"^[0-9.]{1,9}$";
        control9.placeholder = @"请输入月收入";
        control9.errorTip = @"请输入1到9位数字的月收入";
        control9.keyBoardType = KeyBoardTypeDefault;
        
        arrData2 = [NSArray arrayWithObjects:control6,control7,control8,control9, nil];
        
        _arrData = [NSArray arrayWithObjects:arrData1, arrData2, nil];
 }

- (NSString *)strInfoJudge
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
        }
    }
    return @"success";
}

- (void)modelToInfo:(CompanyBody *)companybody{

        //工作单位
        if (companybody.officeName.length > 0)
        {
            ((UITypeClass *)_arrData[0][0]).value = companybody.officeName;
        }
        
        //单位地址
        if ((companybody.officeProvince.length > 0) && (companybody.officeCity.length > 0) && (companybody.officeArea.length > 0))
        {
            //将code存入数组
            ((UITypeClass *)_arrData[0][1]).codeArr = @[companybody.officeProvince,companybody.officeCity,companybody.officeArea];
            
            SearchCityOrCode *transf = [[SearchCityOrCode alloc]init];
            NSString *provinceString = [transf searchName:companybody.officeProvince provinceCode:@"" cityCode:@"" type:typeProvince ] ;
            NSString *cityString = [transf searchName:companybody.officeCity provinceCode:companybody.officeProvince cityCode:@"" type:typeCity];
            NSString *areaString = [transf searchName:companybody.officeArea provinceCode:companybody.officeProvince cityCode:companybody.officeCity type:typeArea];
            
            NSString *addr = [NSString stringWithFormat:@"%@%@%@",provinceString,cityString,areaString];
            if (!isEmptyString(provinceString) && !isEmptyString(cityString) && !isEmptyString(areaString))
            {
                ((UITypeClass *)_arrData[0][1]).value = addr;
            }
        }
        
        //详细地址
        if (companybody.officeAddr.length > 0)
        {
            ((UITypeClass *)_arrData[0][2]).value = companybody.officeAddr;
        }
        
        //职务
        if (companybody.position.length > 0)
        {
            //将code存入数组
            ((UITypeClass *)_arrData[0][3]).codeArr = @[companybody.position];
            
            companybody.position = [DefineSystemTool stringForCode:companybody.position WithType:@"POSITION"];
            ((UITypeClass *)_arrData[0][3]).value = companybody.position;
        }
        
        //单位电话
        if (companybody.officeTel.length > 0)
        {
            NSString *str = [companybody.officeTel stringByReplacingOccurrencesOfString:@"-" withString:@""];
            ((UITypeClass *)_arrData[0][4]).value = [str deleteSpeaceString];
        }
        
        //行业性质
        if (companybody.custIndtry.length > 0 )
        {
            //将code存入数组
            ((UITypeClass *)_arrData[1][0]).codeArr = @[companybody.custIndtry];
            
            companybody.custIndtry = [DefineSystemTool stringForCode:companybody.custIndtry WithType:@"COM_KIND"];
            
            ((UITypeClass *)_arrData[1][0]).value = companybody.custIndtry;
        }
        
        //所在部门
        if (companybody.officeDept.length > 0)
        {
            ((UITypeClass *)_arrData[1][1]).value = companybody.officeDept;
        }
        
        //从业性质
        if (companybody.positionType.length > 0)
        {
            //将code存入数组
            ((UITypeClass *)_arrData[1][2]).codeArr = @[companybody.positionType];
            
            companybody.positionType = [DefineSystemTool stringForCode:companybody.positionType WithType:@"POSITION_OPT"];
            ((UITypeClass *)_arrData[1][2]).value = companybody.positionType;
        }
        
        //月收入
        if (companybody.mthInc.length > 0)
        {
            ((UITypeClass *)_arrData[1][3]).value = companybody.mthInc;
        }
}

- (NSDictionary *)infoToJsonWithType
{
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
    

    [parmDic setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
    
     [parmDic setObject:@"app_person" forKey:@"dataFrom"];
    

        NSString *officeName = ((UITypeClass *)_arrData[0][0]).value;
        [parmDic setObject:officeName forKey:@"officeName"];
        
        NSString *provinceCode = ((UITypeClass *)_arrData[0][1]).codeArr[0];
        [parmDic setObject:StringOrNull(provinceCode) forKey:@"officeProvince"];
        
        NSString *cityCode = ((UITypeClass *)_arrData[0][1]).codeArr[1];
        [parmDic setObject:StringOrNull(cityCode) forKey:@"officeCity"];
        
        NSString *areaCode = ((UITypeClass *)_arrData[0][1]).codeArr[2];
        [parmDic setObject:StringOrNull(areaCode) forKey:@"officeArea"];
        
        NSString *officeAddr = ((UITypeClass *)_arrData[0][2]).value;;
        [parmDic setObject:officeAddr forKey:@"officeAddr"];
        
        NSString *position = ((UITypeClass *)_arrData[0][3]).codeArr[0];;
        [parmDic setObject:position forKey:@"position"];
        
        NSString *officeTel = ((UITypeClass *)_arrData[0][4]).value;;
        [parmDic setObject:officeTel forKey:@"officeTel"];
        
        NSString *custIndtry = ((UITypeClass *)_arrData[1][0]).codeArr[0];
        [parmDic setObject:custIndtry forKey:@"custIndtry"];
        
        NSString *officeDept = ((UITypeClass *)_arrData[1][1]).value;
        [parmDic setObject:officeDept forKey:@"officeDept"];
        
        NSString *positionType = ((UITypeClass *)_arrData[1][2]).codeArr[0];
        [parmDic setObject:positionType forKey:@"positionType"];
        
        NSString *mthInc = ((UITypeClass *)_arrData[1][3]).value;
        [parmDic setObject:mthInc forKey:@"mthInc"];
       
    
    return parmDic;
}

@end
