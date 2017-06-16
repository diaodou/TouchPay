//
//  CheckPersonInfoRate.m
//  personMerchants
//
//  Created by 张久健 on 16/6/3.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "CheckPersonInfoRate.h"
#import "DefineSystemTool.h"
#import "HCMacro.h"
#import "NSString+CheckConvert.h"
@implementation CheckPersonInfoRate
{
    NSMutableDictionary *optionDic;
}



//判断单位信息是否完善
- (BOOL)isCompanyCompeleteWithModel:(CompanyModel *)model
{
    if ([model.head.retFlag isEqualToString:@"00000"])
    {
        NSInteger num = 0;
        
        if ((model.body.officeProvince.length > 0)&&(model.body.officeCity.length > 0)&&(model.body.officeArea.length > 0))
        {
            num ++;
        }
        
        if (model.body.officeAddr.length > 0)
        {
            num ++;
        }
        
        if (model.body.position.length > 0)
        {
            num ++;
        }
        
        if (model.body.officeTel.length > 0)
        {
            num ++;
        }
        
        if (model.body.custIndtry.length > 0 )
        {
            num ++;
        }
        
        if (model.body.officeDept.length > 0)
        {
            num ++;
        }
        
        if (model.body.positionType.length > 0)
        {
            num ++;
        }
        
        if (model.body.mthInc.length > 0)
        {
            num ++;
        }
        
        if (model.body.officeName.length > 0)
        {
            num ++;
        }
        
        

            NSInteger result = num/9.0;
            if(result == 1)
            {
                return YES;
            }
            else
            {
                return NO;
            }
        
    }
    else
    {
        
        return NO;
    }
}

//判断个人信息是否完善
- (BOOL)isPersonCopeleteWithModel:(PersonalMessageModel *)model
{
    int num = 0;
    //最高学历
    if (model.body.education.length > 0)
    {
        num ++;
    }
    
    //户口性质
    if (model.body.localResid.length > 0)
    {
        num ++;
    }
    
    //详细地址
    if (model.body.liveAddr.length > 0)
    {
        num ++;
    }
    
    //居住地址
    if (model.body.liveProvince.length > 0 && model.body.liveCity > 0 && model.body.liveArea.length > 0)
    {
        num ++;
    }
    
    //婚姻状况
    if (model.body.maritalStatus.length > 0)
    {
        num ++;
    }
    
    //户籍地址赋值
    if (model.body.regProvince.length > 0 && model.body.regCity.length > 0 && [model.body.regLiveInd isEqualToString:@"N"])
    {
        num ++;
    }else if (model.body.regLiveInd.length > 0 && ![model.body.regLiveInd isEqualToString:@"N"])
    {
        num++;
    }
    
    //供养人数

        if (model.body.providerNum.length > 0)
        {
            num ++;
        }
    //最高额度

        if (model.body.maxAmount.length > 0 && model.body.creditCount.intValue > 0)
        {
            num ++;
        }

    
    //信用卡数量

        if (model.body.creditCount.length > 0)
        {
            num ++;
        }
    
    //邮箱

        if (model.body.email.length > 0)
        {
            num ++;
        }

    
    //通讯地址赋值

        if (model.body.postProvince.length > 0 && model.body.postCity.length > 0 && [model.body.postQtInd isEqualToString:@"O"])
        {
            num ++;
        }else if (model.body.postQtInd.length > 0 && ![model.body.postQtInd isEqualToString:@"O"])
        {
            num++;
        }

    
    //住宅电话

        if (model.body.fmlyTel.length > 0)
        {
            num ++;
        }
    

        if ([model.body.creditCount isEqualToString:@"0"]&&(model.body.email.length < 3))
        {
            if (num == 10)
            {
                return YES;
            }else
            {
                return NO;
            }
        }else if ([model.body.creditCount isEqualToString:@"0"]&&((model.body.email.length > 3)))
        {
            if (num == 11)
            {
                return YES;
            }else
            {
                return NO;
            }
        }else if ((![model.body.creditCount isEqualToString:@"0"])&&((model.body.email.length > 3)))
        {
            if (num == 12) {
                return  YES;
            }else {
                return NO;
            }
        }else
        {
            if (num == 11)
            {
                return  YES;
            }else
            {
                return NO;
            }
        }
}

//判断联系人信息是否完善
- (BOOL)isContactCompeleteWithModel:(contectModel *)model
{

        NSMutableArray *_dicArray = [[NSMutableArray alloc]init];
        
        NSMutableDictionary *dicOne = [[NSMutableDictionary alloc]init];
        
        NSMutableDictionary *dicTwo = [[NSMutableDictionary alloc]init];
        
        NSMutableDictionary *dicThree = [[NSMutableDictionary alloc]init];
        
        [_dicArray addObject:dicOne];
        
        [_dicArray addObject:dicTwo];
        
        [_dicArray addObject:dicThree];
        
        if (model.body.lxrList.count > 0 && model.body.lxrList) {
            
            NSInteger kill;
            
            if (model.body.lxrList.count > 3) {
                
                kill = 3;
                
            }else{
                
                kill = model.body.lxrList.count;
                
            }
            
            for (int i= 0; i< kill; i++) {
                
                ContactInfo *body = model.body.lxrList[i];
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                
                if (body.contactName.length > 0 && body.contactName) {
                    
                    [dic setObject:body.contactName forKey:@"姓名"];
                    
                }else{
                    
                    [dic setObject:@"" forKey:@"姓名"];
                }
                
                if (body.contactMobile.length > 0 && body.contactMobile) {
                    
                    [dic setObject:body.contactMobile forKey:@"联系电话"];
                    
                }else{
                    
                    [dic setObject:@"" forKey:@"联系电话"];
                }
                
                if (body.relationType.length > 0 && body.relationType) {
                    
                    
                    [dic setObject:body.relationType forKey:@"关系"];
                    
                }else{
                    
                    [dic setObject:@"" forKey:@"关系"];
                    
                    
                }
                
                [_dicArray replaceObjectAtIndex:i withObject:dic];
                
                
            }
            
            
        }
        
        NSInteger num = 0;
        
        for (NSMutableDictionary *dic in _dicArray) {
            
            NSInteger kiss = 0;
            
            for (NSString *string in [dic allValues]) {
                
                if (string && string.length > 0) {
                    
                    kiss++;
                    
                }
                
            }
            
            if (kiss == 3) {
                
                num++;
                
            }
            
        }
        
        if (_ifFromTE)
        {
            if (num == 3)
            {
                return  YES;
            }
            else
            {
                return NO;
            }
        }
        else
        {
            if (num >= 1) {
                
                return  YES;
                
            }else{
                
                return NO;
            }
            
        }
  
    
    
}
//判断房产信息是否完善
- (BOOL)isHouseCompeleteWithModel:(HouseModel *)model
{
    optionDic = [NSMutableDictionary dictionary];
    
    if (model.body.liveYear.length > 0 && model.body.liveYear)
    {
        NSString * str = [NSString stringWithFormat:@"%d",[model.body.liveYear intValue]];
        
        [optionDic setObject:str forKey:@"居住年限"];
    }
    
    if (model.body.pptyAmt.length > 0 && (![model.body.pptyAmt isEqualToString:@"null"]))
    {
        [optionDic setObject:model.body.pptyAmt forKey:@"购买价格"];
    }
    
    if (model.body.mortgageRatio.length > 0 && !([model.body.mortgageRatio isEqualToString:@"null"]))
    {
        [optionDic setObject:(model.body.mortgageRatio)forKey:@"按揭比例"];
    }
    
    if (model.body.pptyLoanBank.length > 0 && model.body.pptyLoanBank)
    {
        [optionDic setObject:(model.body.pptyLoanBank)forKey:@"按揭银行"];
    }
    
    if (model.body.pptyLoanYear.length > 0 && (![model.body.pptyLoanYear isEqualToString:@"null"]))
    {
        [optionDic setObject: ( model.body.pptyLoanYear) forKey:@"按揭周期(年)"];
    }
    
    if (model.body.mortgagePartner.length > 0 && model.body.mortgagePartner)
    {
        [optionDic setObject: (model.body.mortgagePartner )forKey:@"按揭参与人"];
    }
    
    if (model.body.pptyProvince.length > 0 && model.body.pptyCity.length > 0 && [model.body.pptyLiveInd isEqualToString:@"30"])
    {
        [optionDic setObject:[NSString stringWithFormat:@"%@%@%@%@",model.body.pptyProvince,model.body.pptyCity,model.body.pptyArea,model.body.pptyAddr] forKey:@"房产地址"];
    }else if (![model.body.pptyLiveInd isEqualToString:@"30"] && model.body.pptyLiveInd.length > 0)
    {
        [optionDic setObject:@"同住宅地址" forKey:@"房产地址"];
    }else
    {
        [optionDic setObject:@"" forKey:@"房产地址"];
    }
    
    
    if (model.body.liveInfo.length > 0 && model.body.liveInfo)
    {
        NSString *string = [self stringForCode:model.body.liveInfo WithType:@"CURR_SITUATION"];
        
        if (string && string.length > 0)
        {
            [optionDic setObject:string forKey:@"房产状况"];
        }
    }
    
    if (model.body.pptyRighName && [model.body.pptyRighName isValidateName])
    {
        [optionDic setObject:model.body.pptyRighName forKey:@"房产产权人"];
    }
    
    return [self contactNum];
}

- (BOOL)contactNum
{
    int num = 0;
    int result = 0;
    if ([[optionDic objectForKey:@"房产状况"]isEqualToString:@"自购现无贷款"])
    {
        NSString *addre = [optionDic objectForKey:@"房产地址"];
        NSString *kiss = [optionDic objectForKey:@"居住年限"];
        NSString *mon =[optionDic objectForKey:@"购买价格"];
        NSString *people = [optionDic objectForKey:@"房产产权人"];
        if (addre.length>0) {
            num ++;
        }
        if (kiss.length>0) {
            num++;
        }
        if (mon.length>0) {
            
            num++;
        }
        if (people.length>0){
            
            num++;
        }
        result = num/4.0;
        
    }else if ([[optionDic objectForKey:@"房产状况"]isEqualToString:@"自购现有贷款"])
    {
        NSString *addre = [optionDic objectForKey:@"房产地址"];
        
        NSString *kiss = [optionDic objectForKey:@"居住年限"];
        
        NSString *mon =[optionDic objectForKey:@"购买价格"];
        
        NSString *scale = [optionDic objectForKey:@"按揭比例"];
        
        NSString *time = [optionDic objectForKey:@"按揭周期(年)"];
        
        NSString *people = [optionDic objectForKey:@"按揭参与人"];
        
        NSString *bank = [optionDic objectForKey:@"按揭银行"];
        
        NSString *proprl = [optionDic objectForKey:@"房产产权人"];
        
        if (addre.length>0) {
            
            num ++;
        }
        
        if (kiss.length>0) {
            num++;
        }
        
        if (mon.length>0) {
            
            num++;
        }
        
        if (bank.length>0) {
            
            num++;
        }
        
        if (scale.length>0) {
            
            num++;
        }
        
        if (people.length>0) {
            
            num++;
        }
        
        if (time.length>0) {
            num++;
        }
        
        if (proprl.length>0) {
            num++;
        }
        
        result = num/8.0;
        
    }else if ([[optionDic objectForKey:@"房产状况"]isEqualToString:@"租房"])
    {
        NSString *kiss = [optionDic objectForKey:@"居住年限"];
        
        if (kiss.length>0)
        {
            num++;
        }
        result = num/1.0;
        
    }else{
        NSString *kiss = [optionDic objectForKey:@"居住年限"];
        
        if (kiss.length>0) {
            num++;
        }
        result = num/1.0;
    }
    
    if (result == 1) {
        
        
        return YES;
        
    }else{
        
        return NO;
    }
}


- (LoanTypeInfo *)selectWithD:(int) dTime withData:(LoanTypeModel *)model {
    NSMutableArray *arrTemp = [NSMutableArray array];
    for (LoanTypeInfo * tempModel in model.body.info) {
        if (dTime <= [tempModel.tnrMaxDays intValue]) {
            [arrTemp addObject:tempModel];
        }
    }
    if (arrTemp.count != 0) {
        return arrTemp[0];
    }
    return nil;
}

- (LoanTypeInfo *)selectWithDWithType:(int) dTime with:(NSString *)strType withData:(LoanTypeModel *)model withTypCde:(NSString *)TypCde {
    LoanTypeInfo * refModel;
    for (LoanTypeInfo * tempModel in model.body.info) {
        if (dTime <= [tempModel.tnrMaxDays intValue] && [strType isEqualToString:tempModel.mtdDesc] && [TypCde isEqualToString:tempModel.typCde]) {
            
            refModel = tempModel;
        }
    }
    return refModel;
}

- (NSArray *)selectType:(int )dTime withData:(LoanTypeModel *)model {
    
    NSMutableArray *arrTemp = [NSMutableArray array];
    for (LoanTypeInfo * tempModel in model.body.info) {
        if (dTime <= [tempModel.tnrMaxDays intValue]) {
            [arrTemp addObject:tempModel.mtdDesc];
        }
    }
    return arrTemp;
}
- (NSArray *)selectTypeCde:(int )dTime withData:(LoanTypeModel *)model {
    
    NSMutableArray *arrTemp = [NSMutableArray array];
    for (LoanTypeInfo * tempModel in model.body.info) {
        if (dTime <= [tempModel.tnrMaxDays intValue]) {
            [arrTemp addObject:tempModel.typCde];
        }
    }
    return arrTemp;
}

- (LoanTypeInfo *)selectWithM:(int) mTime withData:(LoanTypeModel *)model {
    NSMutableArray *arrTemp = [NSMutableArray array];
    for (LoanTypeInfo * tempModel in model.body.info) {
        if (![tempModel.tnrOpt isEqualToString:@"D"]) {
            
            if ([tempModel.tnrOpt rangeOfString:@","].location!=NSNotFound) {
                NSArray *arr = [tempModel.tnrOpt componentsSeparatedByString:@","];
                for (NSString *str in arr) {
                    if (mTime == [str intValue]) {
                        [arrTemp addObject:tempModel];
                        break ;
                    }
                }
            }else {
                if (mTime == [tempModel.tnrOpt intValue]) {
                    [arrTemp addObject:tempModel];
                }
            }
        }
    }
    if (arrTemp.count != 0) {
        return arrTemp[0];
    }
    return nil;
}


- (LoanTypeInfo *)selectWithMWithType:(int) mTime with:(NSString *)strType withData:(LoanTypeModel *)model withTypCde:(NSString *)TypCde{
    LoanTypeInfo * refModel;
    for (LoanTypeInfo * tempModel in model.body.info) {
        if (![tempModel.tnrOpt isEqualToString:@"D"]) {
            
            if ([tempModel.tnrOpt rangeOfString:@","].location!=NSNotFound) {
                NSArray *arr = [tempModel.tnrOpt componentsSeparatedByString:@","];
                for (NSString *str in arr) {
                    if (mTime == [str intValue] && [strType isEqualToString:tempModel.mtdDesc]) {
                        refModel = tempModel;
                        break ;
                    }
                }
            }else {
                if (mTime == [tempModel.tnrOpt intValue] && [strType isEqualToString:tempModel.mtdDesc] && [TypCde isEqualToString:tempModel.typCde]) {
                    refModel = tempModel;
                }
            }
        }
    }
    return refModel;
}

- (NSArray *)selectMType:(int )mTime withData:(LoanTypeModel *)model {
    NSMutableArray *arrTemp = [NSMutableArray array];
    for (LoanTypeInfo * tempModel in model.body.info) {
        
        if (![tempModel.tnrOpt isEqualToString:@"D"]) {
            
            if ([tempModel.tnrOpt rangeOfString:@","].location!=NSNotFound) {
                NSArray *arr = [tempModel.tnrOpt componentsSeparatedByString:@","];
                for (NSString *str in arr) {
                    if (mTime == [str intValue]) {
                        [arrTemp addObject:tempModel.mtdDesc];
                        break ;
                    }
                }
            }else {
                if (mTime == [tempModel.tnrOpt intValue]) {
                    [arrTemp addObject:tempModel.mtdDesc];
                }
            }
        }
    }
    return arrTemp;
}

- (NSArray *)selectMTypeCde:(int )mTime withData:(LoanTypeModel *)model {
    NSMutableArray *arrTemp = [NSMutableArray array];
    for (LoanTypeInfo * tempModel in model.body.info) {
        
        if (![tempModel.tnrOpt isEqualToString:@"D"]) {
            
            if ([tempModel.tnrOpt rangeOfString:@","].location!=NSNotFound) {
                NSArray *arr = [tempModel.tnrOpt componentsSeparatedByString:@","];
                for (NSString *str in arr) {
                    if (mTime == [str intValue]) {
                        [arrTemp addObject:tempModel.typCde];
                        break ;
                    }
                }
            }else {
                if (mTime == [tempModel.tnrOpt intValue]) {
                    [arrTemp addObject:tempModel.typCde];
                }
            }
        }
    }
    return arrTemp;
}


- (NSArray *)arrCanLoan:(NSArray *)soureLoans shoppingLoans:(NSArray *)shoppingLoans {
    if (soureLoans.count == 0 || shoppingLoans.count == 0 ) {
        return [NSArray array];
    }else {
        NSMutableArray *arr = [NSMutableArray array];
        for (InquiryLoan *tempShop in shoppingLoans) {
            for (LoanTypeInfo *tempMy in soureLoans) {
                if ([tempShop.loanCode isEqualToString:tempMy.typCde]) {
                    [arr addObject:tempMy];
                }
            }
        }
        return arr;
    }
}


- (NSArray *)arrSynalize:(NSArray *)loanModel {
    NSMutableArray *newArrayMD = [NSMutableArray array];
    NSMutableDictionary *dictAmount = [NSMutableDictionary dictionary];
    NSMutableArray *arrDays = [NSMutableArray array];
    NSMutableArray *arrMinDays = [NSMutableArray array];
    for (LoanTypeInfo *model in loanModel) {
        if ([model.tnrOpt isEqualToString:@"D"] || [model.tnrOpt isEqualToString:@"d"])
        {
            if(!isEmptyString(model.tnrMaxDays)) {
                [arrDays addObject:model.tnrMaxDays];
            }
            if(!isEmptyString(model.tnrMinDays)) {
                [arrMinDays addObject:model.tnrMinDays];
            }else{
                [arrMinDays addObject:@"3"];
            }
        }else {
            if ([model.tnrOpt rangeOfString:@","].location != NSNotFound) {
                NSArray *arrTemp = [model.tnrOpt componentsSeparatedByString:@","];
                for (NSString *strMonth in arrTemp) {
                    [dictAmount setValue:strMonth forKey:strMonth];
                }
            }else {
                [dictAmount setValue:model.tnrOpt forKey:model.tnrOpt];
            }
        }
    }
    NSArray *arrValues = [dictAmount allValues];
    NSMutableArray *arrAmount = [NSMutableArray arrayWithArray:arrValues];
    if (arrDays.count > 0) {
        NSString *strMax = @"0";
       
        for (NSString *temp in arrDays) {
            if ([temp intValue] > [strMax intValue]) {
                strMax = temp;
            }
        }
        
        NSString *strMin = strMax;
        for(NSString *minDay in arrMinDays)
        {
            if([minDay intValue] < [strMin intValue])
            {
                strMin = minDay;
            }
        }
        
        if(!strMin)
        {
            strMin = @"3";
        }
        
        [arrDays removeAllObjects];
        [arrMinDays removeAllObjects];
        for (int i = [strMax intValue]; i >= [strMin intValue] ; --i) {
            [arrDays addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [newArrayMD addObject:@{@"天":arrDays}];
    }
    if (arrAmount.count > 0) {
        
        [arrAmount sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *a = (NSString *)obj1;
            NSString *b = (NSString *)obj2;
            
            int aNum = [a intValue];
            int bNum = [b intValue];
            
            if (aNum > bNum) {
                return NSOrderedDescending;
            }
            else if (aNum < bNum){
                return NSOrderedAscending;
            }
            else {
                return NSOrderedSame;
            }
        }];
        [newArrayMD addObject:@{@"月":arrAmount}];
    }
    return newArrayMD;
}


- (NSArray *)arrSynalizeSomeLoan:(NSArray *)loanModel loanType:(LoanTypeInfo *)someLoan {
    NSMutableArray *newArrayMD = [NSMutableArray array];
    NSMutableDictionary *dictAmount = [NSMutableDictionary dictionary];
    NSMutableArray *arrDays = [NSMutableArray array];
    NSMutableArray *arrMinDays = [NSMutableArray array];
    LoanTypeInfo *tempDest;
    for (LoanTypeInfo *model in loanModel) {
        if ([model.typCde isEqualToString:someLoan.typCde] && [model.mtdCde isEqualToString:someLoan.mtdCde]) {
            tempDest = model;
        }
    }
    if (tempDest) {
        if ([tempDest.tnrOpt isEqualToString:@"D"] || [tempDest.tnrOpt isEqualToString:@"d"]) {
            
            if(!isEmptyString(tempDest.tnrMaxDays)) {
                [arrDays addObject:tempDest.tnrMaxDays];
            }
            if(!isEmptyString(tempDest.tnrMinDays)) {
                [arrMinDays addObject:tempDest.tnrMinDays];
            }else{
                [arrMinDays addObject:@"3"];
            }

        }else {
            if ([tempDest.tnrOpt rangeOfString:@","].location != NSNotFound) {
                NSArray *arrTemp = [tempDest.tnrOpt componentsSeparatedByString:@","];
                for (NSString *strMonth in arrTemp) {
                    [dictAmount setValue:strMonth forKey:strMonth];
                }
            }else {
                [dictAmount setValue:tempDest.tnrOpt forKey:tempDest.tnrOpt];
            }
        }
        NSArray *arrValues = [dictAmount allValues];
        NSMutableArray *arrAmount = [NSMutableArray arrayWithArray:arrValues];
        if (arrDays.count > 0) {
            NSString *strMax = @"0";
            for (NSString *temp in arrDays) {
                if ([temp intValue] > [strMax intValue]) {
                    strMax = temp;
                }
            }
            
            NSString *strMin = strMax;
            for(NSString *minDay in arrMinDays)
            {
                if([minDay intValue] < [strMin intValue])
                {
                    strMin = minDay;
                }
            }
            
            if(!strMin)
            {
                strMin = @"3";
            }

            [arrDays removeAllObjects];
            [arrMinDays removeAllObjects];
            for (int i = [strMax intValue]; i >= [strMin intValue] ; --i) {
                [arrDays addObject:[NSString stringWithFormat:@"%d",i]];
            }
            [newArrayMD addObject:@{@"天":arrDays}];
        }
        if (arrAmount.count > 0) {
            
            [arrAmount sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSString *a = (NSString *)obj1;
                NSString *b = (NSString *)obj2;
                
                int aNum = [a intValue];
                int bNum = [b intValue];
                
                if (aNum > bNum) {
                    return NSOrderedDescending;
                }
                else if (aNum < bNum){
                    return NSOrderedAscending;
                }
                else {
                    return NSOrderedSame;
                }
            }];
            [newArrayMD addObject:@{@"月":arrAmount}];
        }
        return newArrayMD;
    }else {
        return @[];
    }
}







- (BOOL)checkAllowCity:(NSString *)strCityCode provinceCity:(NSString *)strProvinceCode arrowInfo:(CityRangeModel *)model {
    if (strCityCode && ![strCityCode isEqualToString:@""]) {
        for (CityRangeBody *temp in model.body) {
            if (![temp.cityCode isEqualToString:@""]) {
                if ([temp.cityCode isEqualToString:strCityCode]) {
                    
                    return YES;
                }
            }
        }
    }
    return NO;
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
