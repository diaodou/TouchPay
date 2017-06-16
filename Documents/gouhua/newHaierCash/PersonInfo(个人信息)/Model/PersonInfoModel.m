//
//  PersonInfoModel.m
//  HaiFu
//
//  Created by 史长硕 on 17/2/9.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import "PersonInfoModel.h"
#import "HCMacro.h"
#import "UIFont+AppFont.h"
#import "SearchCityOrCode.h"
#import "AppDelegate.h"
#import "DefineSystemTool.h"
#import "NSString+CheckConvert.h"
@interface PersonInfoModel ()

{
    
    SearchCityOrCode *_searchCode;
}

@end

@implementation PersonInfoModel

-(instancetype)initWithInfoModel:(AllPersonInfoBody *)model{
    
    if (self = [super init]) {
    
        [self creatBaseData:model];
        
    }
    
    return self;
}

#pragma mark --> private Methods

//创建所有数据源
-(void)creatBaseData:(AllPersonInfoBody *)_modelInfo{
    
    _searchCode = [[SearchCityOrCode alloc]init];
    
    
    /*_________________________单位信息_________________________*/
    
    //工作单位名称
    TypeClass *nameClass = [[TypeClass alloc]init];
    nameClass.title = @"工作单位";
    nameClass.placeholder = @"请输入工作单位";
    if (_modelInfo.officeName && _modelInfo.officeName.length > 0) {
        nameClass.result = _modelInfo.officeName;
    }
    nameClass.errorTipOne = @"请输入30字以内的工作单位且内容不能全为空格";
    nameClass.boardType = UIKeyboardTypeDefault;
    nameClass.regularOne = @"^[a-zA-Z0-9\u4e00-\u9fa5-/，。（）-@#*&~‘]{1,30}$";
    nameClass.isEdit = YES;
    nameClass.saveHttpKey = @"officeName";
    
    //工作单位地址
    TypeClass *addreClass = [[TypeClass alloc]init];
    addreClass.title = @"单位地址";
    if (_modelInfo.officeProvince.length > 0 && _modelInfo.officeCity.length > 0 && _modelInfo.officeArea.length > 0) {
        NSString *province =  [_searchCode searchName:_modelInfo.officeProvince provinceCode:nil cityCode:nil type:typeProvince];
        
        NSString *city = [_searchCode searchName:_modelInfo.officeCity provinceCode:_modelInfo.officeProvince cityCode:nil type:typeCity];
        NSString *area = [_searchCode searchName:_modelInfo.officeArea provinceCode:_modelInfo.officeProvince cityCode:_modelInfo.officeCity type:typeArea];
        NSString *addre = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        if (addre.length > 0) {
            addreClass.result = addre;
        }
        NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
        [parm setObject:_modelInfo.officeProvince forKey:@"officeProvince"];
        [parm setObject:_modelInfo.officeCity forKey:@"officeCity"];
        [parm setObject:_modelInfo.officeArea forKey:@"officeArea"];
        addreClass.CompanyCityDic = [[NSMutableDictionary alloc]initWithDictionary:parm];
    }else{
        addreClass.CompanyCityDic = [[NSMutableDictionary alloc]init];
    }
    addreClass.errorTipOne = @"请选择正确的单位地址";
    addreClass.showType = WorkAddressCityPickType;
    addreClass.regularOne = @"^[u4e00-\u9fa5]{1,100}$";
    NSArray *comProvinceArr = [_searchCode provinceAll];
    NSArray *comAreaArr;
    NSArray *comCityArr;
    if (comProvinceArr.count > 0) {
        
        comCityArr = [_searchCode cityAllFromProv:comProvinceArr[0]];
        
        if (comCityArr.count > 0) {
            
            comAreaArr = [_searchCode areaAllFromProv:comProvinceArr[0] andCityName:comCityArr[0]];
            
        }
        
    }
    addreClass.showArray = [NSArray arrayWithObjects:comProvinceArr,comCityArr,comAreaArr, nil];
    
    //工作单位详细地址
    TypeClass *comDetailClass = [[TypeClass alloc]init];
    comDetailClass.title = @"详细地址";
    if (_modelInfo.officeAddr.length > 0 && _modelInfo.officeAddr) {
        comDetailClass.result = _modelInfo.officeAddr;
    }
    comDetailClass.errorTipOne = @"请输入50字以内的详细地址且内容不能全为空格";
    comDetailClass.placeholder = @"请输入详细地址";
    comDetailClass.regularOne = @"^[a-zA-Z0-9\u4e00-\u9fa5-/，。（）-@#*&~.‘]{1,50}$";
    comDetailClass.boardType = UIKeyboardTypeDefault;
    comDetailClass.isEdit = YES;
    comDetailClass.saveHttpKey = @"officeAddr";
    
    //工作单位职务
    TypeClass *postClass = [[TypeClass alloc]init];
    postClass.title = @"职务";
    if (_modelInfo.position.length > 0) {
        NSString * position = [DefineSystemTool stringForCode:_modelInfo.position WithType:@"POSITION"];
        postClass.code = _modelInfo.position;
        if (position.length > 0) {
            postClass.result = position;
        }
    }
    postClass.errorTipOne = @"请选择职务";
    postClass.regularOne = @"^[u4e00-\u9fa5]{1,50}$";
    postClass.showArray = [self getFinshArray:[DefineSystemTool plistValuesWithType:@"POSITION"]];
    postClass.showType = JobType;
    postClass.key = @"POSITION";
    postClass.saveHttpKey = @"position";
    
    //工作单位电话
    TypeClass *phoneClass = [[TypeClass alloc]init];
    phoneClass.title = @"单位电话";
    if (_modelInfo.officeTel.length > 0) {
        NSString *str = [_modelInfo.officeTel stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phoneClass.result =  [str deleteSpeaceString];
    }
    phoneClass.errorTipOne = @"请输入11位或12位的单位电话";
    phoneClass.placeholder = @"请输入单位电话";
    phoneClass.regularOne = @"^[u4e00-\u9fa5]{11,12}$";
    phoneClass.boardType = UIKeyboardTypeNumberPad;
    phoneClass.isEdit = YES;
    phoneClass.saveHttpKey  = @"officeTel";
    
    //工作单位月收入
    TypeClass *moneyClass = [[TypeClass alloc]init];
    moneyClass.title = @"月收入";
    if (_modelInfo.mthInc.length > 0) {
        moneyClass.result = _modelInfo.mthInc;
    }
    moneyClass.errorTipOne = @"请输入1-11位数字的月收入";
    moneyClass.placeholder = @"请输入月收入";
    moneyClass.regularOne = @"^[a-zA-Z0-9\u4e00-\u9fa5.]{1,11}$";
    moneyClass.boardType = UIKeyboardTypeDecimalPad;
    moneyClass.isEdit = YES;
    moneyClass.saveHttpKey = @"mthInc";

    NSArray *arrayOne = [NSArray arrayWithObjects:nameClass,addreClass,comDetailClass,postClass,moneyClass,phoneClass, nil];
    
    /*_________________________个人信息_________________________*/
    //居住地址
    TypeClass *peoAddreClass = [[TypeClass alloc]init];
    peoAddreClass.title = @"居住地址";
    if (_modelInfo.liveProvince.length > 0 && _modelInfo.liveCity.length > 0 && _modelInfo.liveArea.length > 0) {
        NSString *province =  [_searchCode searchName:_modelInfo.liveProvince provinceCode:nil cityCode:nil type:typeProvince];
        
        NSString *city = [_searchCode searchName:_modelInfo.liveCity provinceCode:_modelInfo.liveProvince cityCode:nil type:typeCity];
        NSString *area = [_searchCode searchName:_modelInfo.liveArea provinceCode:_modelInfo.liveProvince cityCode:_modelInfo.liveCity type:typeArea];
        NSString *addre = [NSString stringWithFormat:@"%@%@%@",province,city,area];
        if (addre.length > 0) {
            peoAddreClass.result = addre;
        }
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        
        [dic setObject:_modelInfo.liveProvince forKey:@"liveProvince"];
        
        [dic setObject:_modelInfo.liveCity forKey:@"liveCity"];
        
        [dic setObject:_modelInfo.liveArea forKey:@"liveArea"];
        
        peoAddreClass.PeopleCityDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    }else{
        peoAddreClass.PeopleCityDic = [[NSMutableDictionary alloc]init];
        
    }
    peoAddreClass.errorTipOne = @"请选择正确的居住地址";
    peoAddreClass.showType = LiveAddressCityPickType;
    peoAddreClass.regularOne = @"^[u4e00-\u9fa5]{1,100}$";
    NSArray *provinceArr = [_searchCode provinceAll];
    NSArray *areaArr;
    NSArray *cityArr;
    if (provinceArr.count > 0) {
        
        cityArr = [_searchCode cityAllFromProv:provinceArr[0]];
        
        if (cityArr.count > 0) {
            
            areaArr = [_searchCode areaAllFromProv:provinceArr[0] andCityName:cityArr[0]];
            
        }
        
    }
    peoAddreClass.showArray = [NSArray arrayWithObjects:provinceArr,cityArr,areaArr, nil];
    
    //个人居住详细地址
    TypeClass *detailClass = [[TypeClass alloc]init];
    detailClass.title = @"详细地址";
    if (_modelInfo.liveAddr.length > 0 && _modelInfo.liveAddr) {
        detailClass.result = _modelInfo.liveAddr;
    }
    detailClass.errorTipOne = @"请输入50字以内的详细地址且内容不能全为空格";
    detailClass.placeholder = @"请输入详细地址";
    detailClass.regularOne = @"^[a-zA-Z0-9\u4e00-\u9fa5-/，。（）-@#*&~‘.;:']{1,50}$";
    detailClass.boardType = UIKeyboardTypeDefault;
    detailClass.isEdit = YES;
    detailClass.saveHttpKey = @"liveAddr";
    
    //婚姻状况
    TypeClass *marryClass = [[TypeClass alloc]init];
    marryClass.title = @"婚姻状况";
    if (_modelInfo.maritalStatus.length > 0) {
        NSString * position = [DefineSystemTool stringForCode:_modelInfo.maritalStatus WithType:@"MARR_STS"];
        marryClass.code = _modelInfo.maritalStatus;
        if (position.length > 0) {
            marryClass.result = position;
        }
    }
    marryClass.errorTipOne = @"请选择婚姻状况";
    marryClass.regularOne = @"^[u4e00-\u9fa5]{1,50}$";
    marryClass.showArray = [self getFinshArray:[DefineSystemTool plistValuesWithType:@"MARR_STS"]];
    marryClass.showType = MarriedPickType;
    marryClass.key = @"MARR_STS";
    marryClass.saveHttpKey = @"maritalStatus";
    marryClass.showType = MarriedPickType;
    
    NSArray *arrayTwo = [NSArray arrayWithObjects:marryClass,peoAddreClass,detailClass, nil];
    
    /*_________________________联系人_________________________*/
    //关系
    TypeClass *relation = [[TypeClass alloc]init];
    relation.title = @"关系";
    relation.isEdit = NO;
    relation.saveHttpKey = @"relationType";
    relation.errorTipOne = @"请选择联系人关系";
    relation.showArray = [self getFinshArray:[DefineSystemTool plistValuesWithType:@"RELATION"]];
    relation.key = @"RELATION";
    relation.regularOne = @"^[a-zA-Z0-9\u4e00-\u9fa5-/，。（）-@#*&~‘]{1,50}$";
    
    //姓名
    TypeClass *namClass = [[TypeClass alloc]init];
    namClass.title = @"姓名";
    namClass.isEdit = YES;
    namClass.saveHttpKey = @"contactName";
    namClass.boardType = UIKeyboardTypeDefault;
    namClass.placeholder = @"请输入姓名";
    namClass.errorTipOne = @"请输入联系人姓名";
    namClass.regularOne = @"^[a-zA-Z0-9\u4e00-\u9fa5-/，。（）-@#*&~‘]{2,50}$";
    
    //电话号码
    TypeClass *telClass = [[TypeClass alloc]init];
    telClass.title = @"联系电话";
    telClass.isEdit = NO;
    telClass.boardType = UIKeyboardTypeNumberPad;
    telClass.placeholder = @"请输入电话号码";
    telClass.saveHttpKey = @"contactMobile";
    telClass.errorTipOne = @"请选择11位或12位的联系电话";
    telClass.regularOne = @"^[0-9]{11,12}$";
    
     if (_modelInfo.lxrList.count>0) {
     ContactItem *info = _modelInfo.lxrList[0];
     relation.result = [DefineSystemTool stringForCode:info.relationType WithType:@"RELATION"];
     relation.code = info.relationType;
     namClass.result = info.contactName;
     telClass.result = info.contactMobile;
     if (info.Id) {
     nameClass.friendId = [NSNumber numberWithInteger:info.Id];
     relation.friendId = [NSNumber numberWithInteger:info.Id];
     telClass.friendId = [NSNumber numberWithInteger:info.Id];
     }
     }
    
    
    NSArray *array = [NSArray arrayWithObjects:relation,namClass,telClass, nil];

    _dataArray = [NSMutableArray arrayWithObjects:arrayOne,arrayTwo,array, nil];
    
    
}

#pragma event Methods
- (NSString *)strInfoJudge {
    
    for (NSArray *arr in _dataArray) {
        
        for (TypeClass *model in arr) {
            
            NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",model.regularOne];
            
            if ([model.title isEqualToString:@"居住地址"]){
                
                if (model.result.length == 0 || !model.result) {
                   
                    return model.errorTipOne;
                    
                }else{
                  
                    for (NSString *jack in [model.PeopleCityDic allValues]) {
                        
                        if (jack.length == 0 || !jack) {
                            
                            return model.errorTipOne;
                            
                        }
                        
                    }

                    
                }
                
                
            }else if ([model.title isEqualToString:@"单位地址"]){
                
                if (model.result.length == 0 || !model.result) {
                   
                    return model.errorTipOne;
                    
                }else{
                 
                    for (NSString *jack in [model.CompanyCityDic allValues]) {
                        
                        if (jack.length == 0 || !jack) {
                            
                            return model.errorTipOne;
                            
                        }
                        
                    }

                    
                }
                
                
            }else{
                
                if (![numberPre evaluateWithObject:model.result]) {
                    NSLog(@"title = %@",model.result);
                    return model.errorTipOne;
                    
                }
                
            }
            
        }
    }
    return @"sucess";
}

-(NSMutableArray *)getDataArray{
    
    return _dataArray;
    
}

#pragma mark --> evenet Methods

 -(void)insertInfoData{
         // 姓名
         TypeClass *nameClass = [[TypeClass alloc]init];
         nameClass.title = @"姓名";
         nameClass.placeholder = @"请输入工作单位";
         if ([AppDelegate delegate].userInfo.realName && [AppDelegate delegate].userInfo.realName.length > 0) {
         nameClass.result = [AppDelegate delegate].userInfo.realName;
         }
         nameClass.errorTipOne = @"请输入姓名";
         nameClass.boardType = UIKeyboardTypeDefault;
         nameClass.regularOne = @"^[a-zA-Z0-9\u4e00-\u9fa5-/，。（）-@#*&~‘]{1,30}$";
         nameClass.saveHttpKey = @"custName";
         
         // 姓名
         TypeClass *certClass = [[TypeClass alloc]init];
         certClass.title = @"身份证";
         certClass.placeholder = @"请输入身份证号";
         if ([AppDelegate delegate].userInfo.realId && [AppDelegate delegate].userInfo.realId.length > 0) {
         certClass.result = [AppDelegate delegate].userInfo.realId;
         }
         certClass.errorTipOne = @"请输入身份证号";
         certClass.boardType = UIKeyboardTypeDefault;
         certClass.regularOne = @"^[a-zA-Z0-9\u4e00-\u9fa5-/，。（）-@#*&~‘]{1,30}$";
         certClass.saveHttpKey = @"certNo";
         
         //性别
         TypeClass *manClass = [[TypeClass alloc]init];
         manClass.title = @"性别";
         manClass.errorTipOne = @"请选择性别";
         manClass.regularOne = @"^[a-zA-Z0-9\u4e00-\u9fa5-/，。（）-@#*&~‘]{1,30}$";
         manClass.saveHttpKey = @"gender";
         
         //出生年月
         TypeClass *timeClass = [[TypeClass alloc]init];
         timeClass.title = @"出生年月";
         timeClass.errorTipOne = @"请选择出生年月";
         timeClass.regularOne = @"^[a-zA-Z0-9\u4e00-\u9fa5-/，。（）-@#*&~‘]{1,30}$";
         timeClass.saveHttpKey = @"birthDt";
     
     //出生年月
     TypeClass *taddreClass = [[TypeClass alloc]init];
     taddreClass.title = @"家庭住址";
     taddreClass.errorTipOne = @"请输入家庭住址";
     taddreClass.regularOne = @"^[a-zA-Z0-9\u4e00-\u9fa5-/，。（）-@#*&~‘]{1,30}$";
     taddreClass.saveHttpKey = @"birthDt";
 
 }



//获得选择器的数据源
-(NSArray *)getFinshArray:(NSArray *)array{
    
    NSMutableArray *jack = [[NSMutableArray alloc]init];
    
    for (NSMutableDictionary *dic in array) {
        
        if (![[dic.allValues firstObject] isEqualToString:@"学生"]) {
            
            [jack addObject:[dic.allValues firstObject]];
            
        }
        
    }
    
    return [NSArray arrayWithObjects:jack, nil];
}


@end
