//
//  PersonInfo.m
//  personMerchants
//
//  Created by 百思为科 on 17/1/10.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "PersonInfo.h"
#import "UITypeClass.h"
#import "SearchCityOrCode.h"
#import "HCMacro.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "DefineSystemTool.h"

@interface PersonInfo()
{
    NSArray <NSArray*> *_arrData;
    
    NSArray *_dictArr;             //字典项数组
}
@end
@implementation PersonInfo

#pragma mark - lift cycle
- (instancetype)initWithType
{
    self = [super init];
    if (self) {
        [self initDataWithType];
    }
    return self;
}
- (void)dealloc{

}
#pragma mark - private Methods
- (NSArray <NSArray *>*)arrayPersonData
{
    return _arrData;
}
- (void)initDataWithType
{
    _arrData = [NSArray array];
    
    NSArray *arrData1 = [NSArray array];
    NSArray *arrData2 = [NSArray array];
    NSArray *arrData3 = [NSArray array];
    NSArray *arrData4 = [NSArray array];
    NSArray *arrData5 = [NSArray array];
    
    UITypeClass *control1 = [[UITypeClass alloc]init];
    control1.controlShowName = @"最高学历";
    control1.controlClassName = NSStringFromClass([UITextField class]);
    control1.canEdit = NO;
    control1.showType = HighestDegreeType;
    control1.regular = @"^[a-zA-Z0-9\u4E00-\u9FA5]{1,}";
    control1.placeholder = @"";
    control1.errorTip = @"请选择最高学历";
    
    UITypeClass *control2 = [[UITypeClass alloc]init];
    control2.controlShowName = @"户口性质";
    control2.controlClassName = NSStringFromClass([UITextField class]);
    control2.canEdit = NO;
    control2.showType = ResidencePickType;
    control2.regular = @"^[a-zA-Z0-9\u4E00-\u9FA5]{1,}";
    control2.placeholder = @"";
    control2.errorTip = @"请选择户口性质";
    
    UITypeClass *control3 = [[UITypeClass alloc]init];
    control3.controlShowName = @"居住地址";
    control3.showType = LiveAddressCityPickType;
    control3.controlClassName = NSStringFromClass([UITextField class]);
    control3.canEdit = NO;
    control3.regular = @"^[a-zA-Z0-9\u4E00-\u9FA5]{1,}";
    control3.placeholder = @"";
    control3.errorTip = @"请选择居住地址";
    
    UITypeClass *control4 = [[UITypeClass alloc]init];
    control4.controlShowName = @"详细地址";
    control4.controlClassName = NSStringFromClass([UITextField class]);
    control4.canEdit = YES;
    control4.regular = @"^[a-zA-Z0-9\u4E00-\u9FA5]{1,50}$";
    control4.placeholder = @"请输入详细地址";
    control4.errorTip = @"请输入50字以内的详细地址,且不能含有特殊字符或空格";
    
    UITypeClass *control5 = [[UITypeClass alloc]init];
    control5.controlShowName = @"住宅电话";
    control5.controlClassName = NSStringFromClass([UITextField class]);
    control5.canEdit = YES;
    control5.keyBoardType = UIKeyboardTypeNumberPad;
    control5.regular = @"^(\\d{11}$|\\d{12}$)";
    control5.placeholder = @"请输入住宅电话";
    control5.errorTip = @"请输入11或12位的住宅电话";
    
    UITypeClass *control6 = [[UITypeClass alloc]init];
    control6.controlShowName = @"婚姻状况";
    control6.showType = MarriedPickType;
    control6.controlClassName = NSStringFromClass([UITextField class]);
    control6.canEdit = NO;
    control6.regular = @"^[a-zA-Z0-9\u4E00-\u9FA5]{1,}";
    control6.placeholder = @"";
    control6.errorTip = @"请选择婚姻状况";
    
    UITypeClass *control7 = [[UITypeClass alloc]init];
    control7.controlShowName = @"供养人数";
    control7.controlClassName = NSStringFromClass([UITextField class]);
    control7.canEdit = NO;
    control7.showType = SupportNumberType;
    control7.regular = @"[a-zA-Z0-9\u4E00-\u9FA5]{1,}";
    control7.placeholder = @"";
    control7.errorTip = @"请选择供养人数";
    
    UITypeClass *control8 = [[UITypeClass alloc]init];
    control8.controlShowName = @"户籍地址";
    control8.controlClassName = NSStringFromClass([UITextField class]);
    control8.canEdit = NO;
    control8.regular = @"[a-zA-Z0-9\u4E00-\u9FA5]{1,}";
    control8.placeholder = @"";
    control8.showType = PermanentAddressType;
    control8.errorTip = @"请选择户籍地址";
    
    UITypeClass *control9 = [[UITypeClass alloc]init];
    control9.controlShowName = @"通讯地址";
    control9.controlClassName = NSStringFromClass([UITextField class]);
    control9.canEdit = NO;
    control9.regular = @"[a-zA-Z0-9\u4E00-\u9FA5]{1,}";
    control9.placeholder = @"";
    control9.showType = PostalAddressType;
    control9.errorTip = @"请选择通讯地址";
    
    UITypeClass *control10 = [[UITypeClass alloc]init];
    control10.controlShowName = @"信用卡数量";
    control10.controlClassName = NSStringFromClass([UITextField class]);
    control10.canEdit = NO;
    control10.showType = CreditCardsNumberType;
    control10.regular = @"[0-9]{1,}";
    control10.placeholder = @"";
    control10.errorTip = @"请选择信用卡数量";
    
    UITypeClass *control11 = [[UITypeClass alloc]init];
    control11.controlShowName = @"最高额度";
    control11.controlClassName = NSStringFromClass([UITextField class]);
    control11.canEdit = YES;
    control11.regular = @"^[1-9]\\d{1,11}$";
    control11.placeholder = @"请输入信用卡最高额度";
    control11.keyBoardType = KeyBoardTypeNum;
    control11.errorTip = @"信用卡最高额度请输入11位以内数字";
    
    UITypeClass *control12 = [[UITypeClass alloc]init];
    control12.controlShowName = @"邮箱(选填)";
    control12.controlClassName = NSStringFromClass([UITextField class]);
    control12.canEdit = YES;
    control12.regular = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    control12.placeholder = @"可接收合同";
    control12.errorTip = @"邮箱地址不正确";
    
    
    UITypeClass *control13 = [[UITypeClass alloc]init];
    control13.controlShowName = @"房产状况";
    control13.controlClassName = NSStringFromClass([UITextField class]);
    control13.canEdit = NO;
    control13.regular = @"[a-zA-Z0-9\u4E00-\u9FA5]{1,}";
    control13.placeholder = @"";
    control13.showType = PersonEstateSituationType;
    control13.errorTip = @"请选择房产状况";
    
    //  全版

        arrData1 = [NSArray arrayWithObjects:control1,control2,control3,control4,control5, nil];
        arrData2 = [NSArray arrayWithObjects:control6,control7,nil];
        arrData3 = [NSArray arrayWithObjects:control8,control9, nil];
        arrData4 = [NSArray arrayWithObjects:control10,control11, nil];
        arrData5 = [NSArray arrayWithObjects:control12, nil];
        
        _arrData = [NSArray arrayWithObjects:arrData1, arrData2, arrData3,arrData4,arrData5 ,nil];

}
- (NSString *)strInfoJudge
{
    for (NSArray *arr in _arrData)
    {
        for (UITypeClass *model in arr)
        {
            if([model.controlShowName isEqualToString:@"邮箱(选填)"])
            {
                if(isEmptyString(model.value))
                {
                    continue;
                }
                else
                {
                    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",model.regular];
                    if (![numberPre evaluateWithObject:model.value])
                    {
                        return model.errorTip;
                    }
                }
            }
            
            NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",model.regular];
            if (![numberPre evaluateWithObject:model.value])
            {
                return model.errorTip;
            }
        }
    }
    return @"success";
}

- (void)modelToInfo:(personBody *)personbody
{

        //最高学历
        if (personbody.education.length > 0)
        {
            ((UITypeClass *)_arrData[0][0]).value = [DefineSystemTool stringForCode:personbody.education WithType:@"EDU_TYP"];
            ((UITypeClass *)_arrData[0][0]).codeArr = @[personbody.education];
        }
        //户口性质
        if (personbody.localResid.length > 0)
        {
            ((UITypeClass *)_arrData[0][1]).value = [DefineSystemTool stringForCode:personbody.localResid WithType:@"LOCAL_RESID"];
            ((UITypeClass *)_arrData[0][1]).codeArr = @[personbody.localResid];
        }
        //居住地址
        if ((personbody.liveProvince.length > 0) && (personbody.liveCity.length > 0) && (personbody.liveArea.length > 0))
        {
            //将接口返回的code先保存下来
            ((UITypeClass *)_arrData[0][2]).codeArr = @[personbody.liveProvince,personbody.liveCity,personbody.liveArea];
            
            SearchCityOrCode *transf = [[SearchCityOrCode alloc]init];
            NSString *provinceString = [transf searchName:StringOrNull(personbody.liveProvince) provinceCode:@"" cityCode:@"" type:typeProvince] ;
            NSString *cityString = [transf searchName:StringOrNull(personbody.liveCity) provinceCode:personbody.liveProvince cityCode:@"" type:typeCity];
            NSString *areaString = [transf searchName:personbody.liveArea provinceCode:personbody.liveProvince cityCode:personbody.liveCity type:typeArea] ;
            
            NSString *addr = [NSString stringWithFormat:@"%@%@%@",provinceString,cityString,areaString];
            if (!isEmptyString(provinceString) && !isEmptyString(cityString) && !isEmptyString(areaString))
            {
                ((UITypeClass *)_arrData[0][2]).value = addr;
            }
        }
        //详细地址
        if (personbody.liveAddr.length > 0)
        {
            ((UITypeClass *)_arrData[0][3]).value = personbody.liveAddr;
        }
        
        //住宅电话
        if (personbody.fmlyTel.length > 0)
        {
            ((UITypeClass *)_arrData[0][4]).value = personbody.fmlyTel;
        }
        
        //婚姻状况
        if (personbody.maritalStatus.length > 0)
        {
            ((UITypeClass *)_arrData[1][0]).codeArr = @[personbody.maritalStatus];
            ((UITypeClass *)_arrData[1][0]).value = [DefineSystemTool stringForCode:personbody.maritalStatus WithType:@"MARR_STS"];
            
            [AppDelegate delegate].userInfo.marryStatues =  [DefineSystemTool stringForCode:personbody.maritalStatus WithType:@"MARR_STS"];
        }
        //供养人数
        if (personbody.providerNum.length > 0)
        {
            ((UITypeClass *)_arrData[1][1]).value = personbody.providerNum;
        }
        //户籍地址
        if (personbody.regLiveInd.length > 0)
        {
            SearchCityOrCode *transfor = [[SearchCityOrCode alloc]init];
            
            NSString * huJiSheng = [transfor searchName:StringOrNull(personbody.regProvince) provinceCode:@"" cityCode:@"" type:typeProvince];
            
            
            NSString *huJiShi = [transfor searchName:StringOrNull(personbody.regCity) provinceCode:StringOrNull(personbody.regProvince) cityCode:@"" type:typeCity];
            
            
            NSString *hujiqu = [transfor searchName:StringOrNull(personbody.regArea) provinceCode:StringOrNull(personbody.regProvince) cityCode:StringOrNull(personbody.regCity) type:typeArea];
            
            NSString *hujiAddress = personbody.regAddr;
            
            NSString *kiss;
            if(!isEmptyString(huJiSheng) && !isEmptyString(huJiShi))
            {
                kiss = [NSString stringWithFormat:@"%@%@%@%@",huJiSheng,huJiShi,hujiqu,hujiAddress];
            }
            
            if (kiss.length > 0 && kiss)
            {
                ((UITypeClass *)_arrData[2][0]).value = kiss;
                ((UITypeClass *)_arrData[2][0]).codeArr = @[StringOrNull(personbody.regProvince),StringOrNull(personbody.regCity),StringOrNull(personbody.regArea),StringOrNull(personbody.regAddr)];
            }
            
            if ([personbody.regLiveInd isEqualToString:@"Y"])
            {
                ((UITypeClass *)_arrData[2][0]).value = @"同住宅地址";
                ((UITypeClass *)_arrData[2][0]).codeArr = @[@"Y"];
            }
        }
        //通讯地址
        if (personbody.postQtInd.length > 0)
        {
            SearchCityOrCode *transfor = [[SearchCityOrCode alloc]init];
            NSString *shengT = [transfor searchName:StringOrNull(personbody.postProvince) provinceCode:@"" cityCode:@"" type:typeProvince];
            
            NSString *shiT = [transfor searchName:StringOrNull(personbody.postCity) provinceCode:StringOrNull(personbody.postProvince) cityCode:@"" type:typeCity];
            
            NSString *quT = [transfor searchName:StringOrNull(personbody.postArea) provinceCode:StringOrNull(personbody.postProvince) cityCode:StringOrNull(personbody.postCity) type:typeArea];
            
            NSString *tongxunAddress = personbody.postAddr;
            
            NSArray *mailArr = [DefineSystemTool plistValuesWithType:@"MAIL_ADDR"];
            for (NSDictionary *dict  in mailArr)
            {
                if ([[dict allKeys][0] isEqualToString:personbody.postQtInd] && ![personbody.postQtInd isEqualToString:@"O"])
                {
                    ((UITypeClass *)_arrData[2][1]).value = [dict allValues][0];
                    ((UITypeClass *)_arrData[2][1]).codeArr = @[personbody.postQtInd];
                }
            }
            
            NSString *phone;
            if(!isEmptyString(shengT) && !isEmptyString(shiT))
            {
                phone = [NSString stringWithFormat:@"%@%@%@%@",shengT,shiT,quT,tongxunAddress];
            }
            
            if (phone.length > 0 && [personbody.postQtInd isEqualToString:@"O"])
            {
                ((UITypeClass *)_arrData[2][1]).value = phone;
                ((UITypeClass *)_arrData[2][1]).codeArr = @[StringOrNull(personbody.postProvince),StringOrNull(personbody.postCity),StringOrNull(personbody.postArea),StringOrNull(personbody.postAddr)];
            }
            
        }
        
        //信用卡数量
        if (personbody.creditCount.length > 0)
        {
            ((UITypeClass *)_arrData[3][0]).value = personbody.creditCount;
            
            if(personbody.creditCount.intValue == 0 && [((UITypeClass *)[_arrData[3] lastObject]).controlShowName isEqualToString:@"最高额度"])
            {
                [self deleteZGEDUIType];
            }
        }
        
        //最高额度,这里有可能曾今信用卡数量有值，后来改为0，但这个字段有值
        if (personbody.maxAmount.length > 0 && [((UITypeClass *)[_arrData[3] lastObject]).controlShowName isEqualToString:@"最高额度"])
        {
            ((UITypeClass *)_arrData[3][1]).value = personbody.maxAmount;
        }
        
        //邮箱
        if (personbody.email.length > 0)
        {
            ((UITypeClass *)_arrData[4][0]).value = personbody.email;
        }
    
}
- (NSDictionary *)infoToJsonWithType
{
    NSMutableDictionary *parmDic = [[NSMutableDictionary alloc]init];
    

    [parmDic setObject:StringOrNull([AppDelegate delegate].userInfo.custNum) forKey:@"custNo"];
    
    [parmDic setObject:@"app_person" forKey:@"dataFrom"];
    
        //最高学历
        NSString *education = ((UITypeClass *)_arrData[0][0]).codeArr[0];
        [parmDic setObject:education forKey:@"education"];
        //户口性质
        NSString *localResid = ((UITypeClass *)_arrData[0][1]).codeArr[0];
        [parmDic setObject:localResid forKey:@"localResid"];
        //居住地址
        NSString *liveProvinceCode = ((UITypeClass *)_arrData[0][2]).codeArr[0];
        [parmDic setObject:StringOrNull(liveProvinceCode) forKey:@"liveProvince"];
        
        NSString *liveCityCode = ((UITypeClass *)_arrData[0][2]).codeArr[1];
        [parmDic setObject:StringOrNull(liveCityCode) forKey:@"liveCity"];
        
        NSString *liveAreaCode = ((UITypeClass *)_arrData[0][2]).codeArr[2];
        [parmDic setObject:StringOrNull(liveAreaCode) forKey:@"liveArea"];
        //详细地址
        NSString *liveAddr = ((UITypeClass *)_arrData[0][3]).value;
        [parmDic setObject:liveAddr forKey:@"liveAddr"];
        //住宅电话
        NSString *fmlyTel = ((UITypeClass *)_arrData[0][4]).value;;
        [parmDic setObject:fmlyTel forKey:@"fmlyTel"];
        //婚姻状况
        NSString *maritalStatus = ((UITypeClass *)_arrData[1][0]).codeArr[0];
        [parmDic setObject:maritalStatus forKey:@"maritalStatus"];
        //供养人数
        NSString *providerNum = ((UITypeClass *)_arrData[1][1]).value;
        [parmDic setObject:providerNum forKey:@"providerNum"];
        //户籍地址
        if(((UITypeClass *)_arrData[2][0]).codeArr.count == 1)
        {
            [parmDic setObject:@"Y" forKey:@"regLiveInd"];
        }
        else
        {
            [parmDic setObject:@"N" forKey:@"regLiveInd"];
            
            NSString *provinceCode = ((UITypeClass *)_arrData[2][0]).codeArr[0];
            [parmDic setObject:provinceCode forKey:@"regProvince"];
            
            NSString *regCity = ((UITypeClass *)_arrData[2][0]).codeArr[1];
            [parmDic setObject:regCity forKey:@"regCity"];
            
            NSString *regArea = ((UITypeClass *)_arrData[2][0]).codeArr[2];
            [parmDic setObject:regArea forKey:@"regArea"];
            
            NSString *regAddr = ((UITypeClass *)_arrData[2][0]).codeArr[3];
            [parmDic setObject:regAddr forKey:@"regAddr"];
        }
        
        //通讯地址
        if(((UITypeClass *)_arrData[2][1]).codeArr.count == 1)
        {
            NSString *regLiveInd = ((UITypeClass *)_arrData[2][1]).codeArr[0];
            [parmDic setObject:regLiveInd forKey:@"postQtInd"];
        }
        else
        {
            [parmDic setObject:@"O" forKey:@"postQtInd"];
            
            NSString *postProvince = ((UITypeClass *)_arrData[2][1]).codeArr[0];
            [parmDic setObject:postProvince forKey:@"postProvince"];
            
            NSString *postCity = ((UITypeClass *)_arrData[2][1]).codeArr[1];
            [parmDic setObject:postCity forKey:@"postCity"];
            
            NSString *postArea = ((UITypeClass *)_arrData[2][1]).codeArr[2];
            [parmDic setObject:postArea forKey:@"postArea"];
            
            NSString *postAddr = ((UITypeClass *)_arrData[2][1]).codeArr[3];
            [parmDic setObject:postAddr forKey:@"postAddr"];
        }
        
        //信用卡数量
        NSString *creditCount = ((UITypeClass *)_arrData[3][0]).value;
        [parmDic setObject:creditCount forKey:@"creditCount"];
        
        //最高额度
        if(creditCount.intValue != 0)
        {
            NSString *maxAmount = ((UITypeClass *)_arrData[3][1]).value;
            [parmDic setObject:maxAmount forKey:@"maxAmount"];
        }
        
        //邮箱
        NSString *email = ((UITypeClass *)_arrData[4][0]).value;
        [parmDic setObject:StringOrNull(email) forKey:@"email"];
        
       
    return parmDic;
}

//删除某一个字段,并将删除后的数组返回
- (NSArray *)deleteZGEDUIType
{
    NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:_arrData];
    
    NSMutableArray *mArr1 = [[NSMutableArray alloc] initWithArray:_arrData[3]];
    [mArr1 removeLastObject];
    
    [mArr replaceObjectAtIndex:3 withObject:mArr1];
    
    _arrData = mArr;
    
    return _arrData;
}

//插入"最高额度"字段,并将删除后的数组返回
- (NSArray *)insertZGEDUIType
{
    UITypeClass *control = [[UITypeClass alloc]init];
    control.controlShowName = @"最高额度";
    control.controlClassName = NSStringFromClass([UITextField class]);
    control.canEdit = YES;
    control.regular = @"^[1-9]\\d{1,11}$";
    control.placeholder = @"请输入信用卡最高额度";
    control.keyBoardType = UIKeyboardTypeNumberPad;
    control.errorTip = @"信用卡最高额度请输入11位以内数字";

    NSMutableArray *mArr = [[NSMutableArray alloc] initWithArray:_arrData];
    
    NSMutableArray *mArr1 = [[NSMutableArray alloc] initWithArray:_arrData[3]];
    [mArr1 addObject:control];
    
    [mArr replaceObjectAtIndex:3 withObject:mArr1];
    
    _arrData = mArr;

    return _arrData;
}
@end
