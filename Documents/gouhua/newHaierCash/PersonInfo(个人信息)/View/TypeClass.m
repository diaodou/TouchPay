//
//  TypeClass.m
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 17/1/10.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import "TypeClass.h"
#import "SearchCityOrCode.h"
@implementation TypeClass

-(void)searchCityNameArray:(NSArray *)array proNum:(NSInteger)proNumber cityNum:(NSInteger)cityNumber araeNum:(NSInteger)areaNumber{
    
    SearchCityOrCode *_search = [[SearchCityOrCode alloc]init];
    
    NSArray *province = array[0];
    
    NSArray *city = array[1];
    
    NSArray *area = array[2];
    
    self.provinceCode = [_search searchCode:province[proNumber] provinceCode:nil cityCode:nil type:typeProvince];
    
    NSString *proStr = province[proNumber];
 
    self.cityCode = [_search searchCode:city[cityNumber] provinceCode:self.provinceCode cityCode:nil type:typeCity];
    
    NSString *cityStr = city[cityNumber];
    
    NSString *areaStr;
    
    if (areaNumber < area.count) {
        
        self.areaCode = [_search searchCode:area[areaNumber] provinceCode:self.provinceCode cityCode:self.cityCode type:typeArea];
        
        areaStr = area[areaNumber];
        
    }else{
        
       self.areaCode = @"";
        
       areaStr = @"";
        
    }
    
    if ([self.title isEqualToString:@"单位地址"]) {
     
        [self.CompanyCityDic setObject:self.provinceCode forKey:@"officeProvince"];
        
        [self.CompanyCityDic setObject:self.areaCode forKey:@"officeArea"];
        
        [self.CompanyCityDic setObject:self.cityCode forKey:@"officeCity"];
        
    }else if ([self.title isEqualToString:@"居住地址"]){
        
        [self.PeopleCityDic setObject:self.provinceCode forKey:@"liveProvince"];
        
        [self.PeopleCityDic setObject:self.areaCode forKey:@"liveArea"];
        
        [self.PeopleCityDic setObject:self.cityCode forKey:@"liveCity"];

    }
   
    self.result = [NSString stringWithFormat:@"%@%@%@",proStr,cityStr,areaStr];
    
}

-(void)setResult:(NSString *)result{
    
    _result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    
}

@end
