//
//  HouseInfo.m
//  personMerchants
//
//  Created by 百思为科 on 17/1/11.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "HouseInfo.h"
#import "UITypeClass.h"
#import "SearchCityOrCode.h"
#import "HCMacro.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface HouseInfo()
{
    NSArray <NSArray*> *_arrData;
    
    NSArray *_dictArr;             //字典项数组
}
@end
@implementation HouseInfo
#pragma mark - lift cycle
- (instancetype)initWithType:(HouseType)type{
    
    self = [super init];
    if (self) {
        [self initDataWithType:type];
    }
    return self;
}
- (void)dealloc{
    
}
#pragma mark - private Methods
- (NSString *)houseSituation:(HouseBody *)houseBody{
    
    NSString * situation;
    
    if (houseBody.liveInfo && houseBody.liveInfo.length > 0)
    {
       situation = [self stringForCode:houseBody.liveInfo WithType:@"CURR_SITUATION"];
    }else
    {
        situation = @"自购房无贷款";
    }
    return situation;
}
- (NSArray <NSArray *>*)arrayPersonData
{
    return _arrData;
}
- (void)initDataWithType:(HouseType)type
{
    _arrData = [[NSArray alloc]init];
    
    NSArray *arrData1 = [NSArray array];
    NSArray *arrData2 = [NSArray array];
    NSArray *arrData3 = [NSArray array];
    
    UITypeClass *control1 = [[UITypeClass alloc]init];
    control1.controlShowName = @"房产状况";
    control1.controlClassName = NSStringFromClass([UITextField class]);
    control1.canEdit = NO;
    control1.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,}$";
    control1.showType = RealEstateSituationType;
    //    control1.placeholder = @"";
    control1.errorTip = @"请选择房产状况";
    
    UITypeClass *control2 = [[UITypeClass alloc]init];
    control2.controlShowName = @"房产地址";
    control2.controlClassName = NSStringFromClass([UITextField class]);
    control2.canEdit = NO;
    control2.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,}$";
    control2.showType = RealEstatePlaceType;
    //    control2.placeholder = @"请选择单位地址";
    control2.errorTip = @"请选择房产地址";
    
    UITypeClass *control3 = [[UITypeClass alloc]init];
    control3.controlShowName = @"房产产权人";
    control3.controlClassName = NSStringFromClass([UITextField class]);
    control3.canEdit = YES;
    control3.regular = @"^[\u4E00-\u9FA5]{2,20}$";
    control3.placeholder = @"默认申请人(可变更)";
    control3.errorTip = @"请输入2-20位房产产权人中文名";
    
    UITypeClass *control4 = [[UITypeClass alloc]init];
    control4.controlShowName = @"购买价格";
    control4.controlClassName = NSStringFromClass([UITextField class]);
    control4.canEdit = YES;
    control4.regular = @"^\\d{1,12}";
    control4.placeholder = @"请输入购买价格";
    control4.keyBoardType = KeyBoardTypeNum;
    control4.errorTip = @"请输入12位以内的购买价格";
    
    UITypeClass *control5 = [[UITypeClass alloc]init];
    control5.controlShowName = @"居住年限";
    control5.controlClassName = NSStringFromClass([UITextField class]);
    control5.canEdit = NO;
    control5.regular = @"^\\d{1,}";
    control5.showType = ResidenceTimeType;
//    control5.placeholder = @"请输入住宅电话";
    control5.errorTip = @"请选择居住年限";
    
    
    UITypeClass *control6 = [[UITypeClass alloc]init];
    control6.controlShowName = @"按揭比例";
    control6.controlClassName = NSStringFromClass([UITextField class]);
    control6.canEdit = YES;
    control6.regular = @"^(([1-9]\\d?)|100)$";
    control6.placeholder = @"请输入1-100的数字";
    control6.keyBoardType = KeyBoardTypeNum;
    control6.errorTip = @"请输入正确的按揭比例";
    
    UITypeClass *control7 = [[UITypeClass alloc]init];
    control7.controlShowName = @"按揭周期(年)";
    control7.controlClassName = NSStringFromClass([UITextField class]);
    control7.canEdit = YES;
    control7.regular = @"^(([1-9]\\d?)|100)$";
    control7.placeholder = @"请输入按揭周期";
    control7.keyBoardType = KeyBoardTypeNum;
    control7.errorTip = @"请输入正确的按揭周期";
    
    UITypeClass *control8 = [[UITypeClass alloc]init];
    control8.controlShowName = @"按揭参与人";
    control8.controlClassName = NSStringFromClass([UITextField class]);
    control8.canEdit = YES;
    control8.regular = @"^[\u4E00-\u9FA5]{2,20}$|无";
    control8.placeholder = @"没有填写 无";
    control8.errorTip = @"请输入2-20位按揭参与人中文名";
    
    UITypeClass *control9 = [[UITypeClass alloc]init];
    control9.controlShowName = @"按揭银行";
    control9.controlClassName = NSStringFromClass([UITextField class]);
    control9.canEdit = YES;
    control9.regular = @"^[a-zA-Z0-9\u4e00-\u9fa5]{1,}$";
    control9.placeholder = @"请输入按揭银行";
    control9.errorTip = @"请填写按揭银行";
    
    //自购现无贷款
    if (type == HaveHouseNoLoan)
    {
        arrData1 = [NSArray arrayWithObjects:control1, control2, control3, control4, control5, nil];
        _arrData = [NSArray arrayWithObjects:arrData1, nil];
   
    }
    //自购现有贷款
    else if (type == HaveHouseHaveLoan)
    {
        arrData2 = [NSArray arrayWithObjects:control1, control2, control3, control4, control6, control7, control8, control9, control5, nil];
        _arrData = [NSArray arrayWithObjects:arrData2, nil];
    }
    //其他
    else
    {
        arrData3 = [NSArray arrayWithObjects:control1, control5, nil];
        _arrData = [NSArray arrayWithObjects:arrData3, nil];
    }
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
- (void)modelToInfo:(HouseBody *)housebody WithType:(HouseType)type
{
    SearchCityOrCode *serch = [[SearchCityOrCode alloc]init];
    //房产状况
    if (housebody.liveInfo.length > 0 && housebody.liveInfo)
    {
        ((UITypeClass *)_arrData[0][0]).value = [self stringForCode:housebody.liveInfo WithType:@"CURR_SITUATION"];
        ((UITypeClass *)_arrData[0][0]).codeArr = @[housebody.liveInfo];
    }
    if (type == HaveHouseNoLoan)
    {
        //房产地址
        if (housebody.pptyLiveInd.length > 0)
        {
            
            NSString * pptyProvince = [serch searchName:StringOrNull(housebody.pptyProvince) provinceCode:@"" cityCode:@"" type:typeProvince];
            
            
            NSString *pptyCity = [serch searchName:StringOrNull(housebody.pptyCity) provinceCode:StringOrNull(housebody.pptyProvince) cityCode:@"" type:typeCity];
            
            
            NSString *pptyArea = [serch searchName:StringOrNull(housebody.pptyArea) provinceCode:StringOrNull(housebody.pptyProvince) cityCode:StringOrNull(housebody.pptyCity) type:typeArea];
            
            NSString *pptyAddress = housebody.pptyAddr;
            
            NSString *kiss;
            if(!isEmptyString(pptyProvince) && !isEmptyString(pptyCity))
            {
                kiss = [NSString stringWithFormat:@"%@%@%@%@",pptyProvince,pptyCity,pptyArea,pptyAddress];
            }
            
            if (kiss.length > 0 && kiss)
            {
                ((UITypeClass *)_arrData[0][1]).value = kiss;
                ((UITypeClass *)_arrData[0][1]).codeArr = @[StringOrNull(housebody.pptyProvince),StringOrNull(housebody.pptyCity),StringOrNull(housebody.pptyArea),StringOrNull(housebody.pptyAddr)];
            }
            
            if ([housebody.pptyLiveInd isEqualToString:@"10"])
            {
                ((UITypeClass *)_arrData[0][1]).value = @"同现住房地址";
                ((UITypeClass *)_arrData[0][1]).codeArr = @[@"10"];
            }
        }
        //房产产权人
        if (housebody.pptyRighName && housebody.pptyRighName.length > 0)
        {
            ((UITypeClass *)_arrData[0][2]).value = housebody.pptyRighName;
        }else if ([AppDelegate delegate].userInfo.realName.length > 0)
        {
            ((UITypeClass *)_arrData[0][2]).value = [AppDelegate delegate].userInfo.realName;
        }
        //购买价格
        if (housebody.pptyAmt && housebody.pptyAmt.length > 0)
        {
            ((UITypeClass *)_arrData[0][3]).value = housebody.pptyAmt;
        }
        //居住年限
        if (housebody.liveYear && housebody.liveYear.length > 0)
        {
            ((UITypeClass *)_arrData[0][4]).value = housebody.liveYear;
        }
    }else if (type == HaveHouseHaveLoan)
    {
        //房产地址
        if (housebody.pptyLiveInd.length > 0)
        {
            
            NSString * pptyProvince = [serch searchName:StringOrNull(housebody.pptyProvince) provinceCode:@"" cityCode:@"" type:typeProvince];
            
            
            NSString *pptyCity = [serch searchName:StringOrNull(housebody.pptyCity) provinceCode:StringOrNull(housebody.pptyProvince) cityCode:@"" type:typeCity];
            
            
            NSString *pptyArea = [serch searchName:StringOrNull(housebody.pptyArea) provinceCode:StringOrNull(housebody.pptyProvince) cityCode:StringOrNull(housebody.pptyCity) type:typeArea];
            
            NSString *pptyAddress = housebody.pptyAddr;
            
            NSString *kiss;
            if(!isEmptyString(pptyProvince) && !isEmptyString(pptyCity))
            {
                kiss = [NSString stringWithFormat:@"%@%@%@%@",pptyProvince,pptyCity,pptyArea,pptyAddress];
            }
            
            if (kiss.length > 0 && kiss)
            {
                ((UITypeClass *)_arrData[0][1]).value = kiss;
                ((UITypeClass *)_arrData[0][1]).codeArr = @[StringOrNull(housebody.pptyProvince),StringOrNull(housebody.pptyCity),StringOrNull(housebody.pptyArea),StringOrNull(housebody.pptyAddr)];
            }
            
            if ([housebody.pptyLiveInd isEqualToString:@"10"])
            {
                ((UITypeClass *)_arrData[0][1]).value = @"同现住房地址";
                ((UITypeClass *)_arrData[0][1]).codeArr = @[@"10"];
            }
        }
        
        //房产产权人
        if (housebody.pptyRighName && housebody.pptyRighName.length > 0)
        {
            ((UITypeClass *)_arrData[0][2]).value = housebody.pptyRighName;
        }else if ([AppDelegate delegate].userInfo.realName.length > 0)
        {
            ((UITypeClass *)_arrData[0][2]).value = [AppDelegate delegate].userInfo.realName;
        }
        
        //购买价格
        if (housebody.pptyAmt && housebody.pptyAmt.length > 0)
        {
            ((UITypeClass *)_arrData[0][3]).value = housebody.pptyAmt;
        }
        //按揭比例
        if (housebody.mortgageRatio.length > 0 && !([housebody.mortgageRatio isEqualToString:@"null"]))
        {
            ((UITypeClass *)_arrData[0][4]).value = housebody.mortgageRatio;
        }
        
        //按揭周期(年)
        if (housebody.pptyLoanYear.length > 0 && (![housebody.pptyLoanYear isEqualToString:@"null"]))
        {
            ((UITypeClass *)_arrData[0][5]).value = housebody.pptyLoanYear;
        }
        
        //按揭参与人
        if (housebody.mortgagePartner.length > 0 && housebody.mortgagePartner)
        {
            ((UITypeClass *)_arrData[0][6]).value = housebody.mortgagePartner;
        }

        //按揭银行
        if (housebody.pptyLoanBank.length > 0 && housebody.pptyLoanBank)
        {
            ((UITypeClass *)_arrData[0][7]).value = housebody.pptyLoanBank;
        }
        //居住年限
        if (housebody.liveYear && housebody.liveYear.length > 0)
        {
            ((UITypeClass *)_arrData[0][8]).value = housebody.liveYear;
        }
    }else
    {
        //居住年限
        if (housebody.liveYear && housebody.liveYear.length > 0)
        {
            ((UITypeClass *)_arrData[0][1]).value = housebody.liveYear;
        }
    }
}
- (NSDictionary *)infoToJsonWithType:(HouseType)type
{
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
    

    [parmDic setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
    //房产状况
    NSString *liveInfo = ((UITypeClass *)_arrData[0][0]).codeArr[0];
    [parmDic setObject:liveInfo forKey:@"liveInfo"];
    [parmDic setObject:@"app_person" forKey:@"dataFrom"];
    if (type == HaveHouseNoLoan)
    {
        //房产地址
        if(((UITypeClass *)_arrData[0][1]).codeArr.count == 1)
        {
            [parmDic setObject:@"10" forKey:@"pptyLiveInd"];
        }
        else
        {
            [parmDic setObject:@"30" forKey:@"pptyLiveInd"];
            
            NSString *pptyProvinceCode = ((UITypeClass *)_arrData[0][1]).codeArr[0];
            [parmDic setObject:pptyProvinceCode forKey:@"pptyProvince"];
            
            NSString *pptyCityCode = ((UITypeClass *)_arrData[0][1]).codeArr[1];
            [parmDic setObject:pptyCityCode forKey:@"pptyCity"];
            
            NSString *pptyAreaCode = ((UITypeClass *)_arrData[0][1]).codeArr[2];
            [parmDic setObject:pptyAreaCode forKey:@"pptyArea"];
            
            NSString *pptyAddr = ((UITypeClass *)_arrData[0][1]).codeArr[3];
            [parmDic setObject:pptyAddr forKey:@"pptyAddr"];
        }
        //房产产权人
        NSString *pptyRighName = ((UITypeClass *)_arrData[0][2]).value;
        [parmDic setObject:pptyRighName forKey:@"pptyRighName"];
        //购买价格
        NSString *pptyAmt = ((UITypeClass *)_arrData[0][3]).value;
        [parmDic setObject:pptyAmt forKey:@"pptyAmt"];
        //居住年限
        NSString *liveYear = ((UITypeClass *)_arrData[0][4]).value;
        [parmDic setObject:liveYear forKey:@"liveYear"];
        
        [parmDic setObject:@"app_person" forKey:@"dataFrom"];
    }else if (type == HaveHouseHaveLoan)
    {
        //房产地址
        if(((UITypeClass *)_arrData[0][1]).codeArr.count == 1)
        {
            [parmDic setObject:@"10" forKey:@"pptyLiveInd"];
        }
        else
        {
            [parmDic setObject:@"30" forKey:@"pptyLiveInd"];
            
            NSString *pptyProvinceCode = ((UITypeClass *)_arrData[0][1]).codeArr[0];
            [parmDic setObject:pptyProvinceCode forKey:@"pptyProvince"];
            
            NSString *pptyCityCode = ((UITypeClass *)_arrData[0][1]).codeArr[1];
            [parmDic setObject:pptyCityCode forKey:@"pptyCity"];
            
            NSString *pptyAreaCode = ((UITypeClass *)_arrData[0][1]).codeArr[2];
            [parmDic setObject:pptyAreaCode forKey:@"pptyArea"];
            
            NSString *pptyAddr = ((UITypeClass *)_arrData[0][1]).codeArr[3];
            [parmDic setObject:pptyAddr forKey:@"pptyAddr"];
        }
        //房产产权人
        NSString *pptyRighName = ((UITypeClass *)_arrData[0][2]).value;
        [parmDic setObject:pptyRighName forKey:@"pptyRighName"];
        //购买价格
        NSString *pptyAmt = ((UITypeClass *)_arrData[0][3]).value;
        [parmDic setObject:pptyAmt forKey:@"pptyAmt"];
        //按揭比例
        NSString *mortgageRatio = ((UITypeClass *)_arrData[0][4]).value;
        [parmDic setObject:mortgageRatio forKey:@"mortgageRatio"];
        //按揭周年(年)
        NSString *pptyLoanYear = ((UITypeClass *)_arrData[0][5]).value;
        [parmDic setObject:pptyLoanYear forKey:@"pptyLoanYear"];
        //按揭参与人
        NSString *mortgagePartner = ((UITypeClass *)_arrData[0][6]).value;
        [parmDic setObject:mortgagePartner forKey:@"mortgagePartner"];
        //按揭银行
        NSString *pptyLoanBank = ((UITypeClass *)_arrData[0][7]).value;
        [parmDic setObject:pptyLoanBank forKey:@"pptyLoanBank"];
        //居住年限
        NSString *liveYear = ((UITypeClass *)_arrData[0][8]).value;
        [parmDic setObject:liveYear forKey:@"liveYear"];
    }else{
        //居住年限
        NSString *liveYear = ((UITypeClass *)_arrData[0][1]).value;
        [parmDic setObject:liveYear forKey:@"liveYear"];
    }
    return parmDic;

}
//将string转换成code
-(NSString *)stringForCode:(NSString *)code WithType:(NSString *)oneType{
    NSString *string = [NSString string];
    NSMutableArray *dictArr;
    dictArr =  [self plistValuesWithType:oneType];
    if (dictArr.count==0) {
        return @"null";
    }
    for (NSMutableDictionary  *dic in dictArr) {
        if ([[[dic allKeys] lastObject]isEqualToString:code]) {
            string = [dic valueForKey:code];
        }
        NSLog(@"%@",string);
    }
    
    return string;
}
//将name转化成code
- (NSString *)codeWithString:(NSString *)Name WithType:(NSString *)oneType{
    NSString *string = [NSString string];
    NSMutableArray *dictArr;
    dictArr =  [self plistValuesWithType:oneType];
    if (dictArr.count==0) {
        return @"null";
    }
    for (NSMutableDictionary  *dic in dictArr) {
        NSArray *arr = [dic allKeys];
        for (NSString *key in arr) {
            if ([Name isEqualToString:[dic valueForKey:key]]) {
                string = key;
            }
        }
        
    }
    return string;
}
//判断plist文件中是否有值
- (NSMutableArray *)plistValuesWithType:(NSString *)oneType{
    
    // 在这里做判断，看看plist中有没有东西
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@person.plist",oneType]];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    if ([dict  valueForKey:oneType]) {
        return [dict  valueForKey:oneType];
    }else{
        return nil;
    }
    
}
@end
