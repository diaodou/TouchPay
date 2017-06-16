//
//  SearchCityOrCode.m
//  personMerchants
//
//  Created by xuxie on 16/5/28.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "SearchCityOrCode.h"
#import <FMDB.h>
#import "HCMacro.h"

@implementation SearchCityOrCode
{
    FMDatabase *dataBase;
}
- (BOOL)opDb {
    if (!dataBase) {
        NSString *strPath = [[NSBundle mainBundle]pathForResource:@"mydatabase" ofType:@"sqlite"];
        dataBase=[FMDatabase databaseWithPath:strPath];
    }
    return [dataBase open];
}

- (NSString *)searchCode:(NSString *)strName provinceCode:(NSString *)province cityCode:(NSString *)city type:(SearchTye)searchType{
    if ([self opDb]) {
        NSString *strSql = @"";
        if (typeProvince == searchType) {
            strSql = [NSString stringWithFormat:@"SELECT AREA_CODE from s_area WHERE AREA_NAME ='%@' AND AREA_TYPE = 'province'",strName];
        }else if (typeCity == searchType) {
            if (province && ![province isEqualToString:@""]) {
                strSql = [NSString stringWithFormat:@"SELECT AREA_CODE from s_area WHERE AREA_NAME ='%@' AND AREA_PARENT_CODE = '%@' AND AREA_TYPE = 'city'",strName,province];
            }else {
                strSql = [NSString stringWithFormat:@"SELECT AREA_CODE from s_area WHERE AREA_NAME ='%@' AND AREA_TYPE = 'city'",strName];
            }
        }else {
            if (city && ![city isEqualToString:@""]) {
                strSql = [NSString stringWithFormat:@"SELECT AREA_CODE from s_area WHERE AREA_NAME ='%@' AND AREA_PARENT_CODE = '%@' AND AREA_TYPE = 'area'",strName,city];
            }else {
                strSql = [NSString stringWithFormat:@"SELECT AREA_CODE from s_area WHERE AREA_NAME ='%@' AND AREA_TYPE = 'area'",strName];
            }
        }
        
        FMResultSet *result = [dataBase executeQuery:strSql];
        NSString *name = @"";
        while (result.next) {
            name=[result stringForColumn:@"AREA_CODE"];
        }
        
        [self closeDB];
        return name;
    }
    [self closeDB];
    return @"";
}

- (NSString *)searchName:(NSString *)strCode provinceCode:(NSString *)province cityCode:(NSString *)city type:(SearchTye)searchType{
    if ([self opDb]) {
        
        NSString *strSql = @"";
        if (typeProvince == searchType) {
            strSql = [NSString stringWithFormat:@"SELECT AREA_NAME from s_area WHERE AREA_CODE ='%@' AND AREA_TYPE = 'province'",strCode];
        }else if (typeCity == searchType) {
            if (province && ![province isEqualToString:@""]) {
                strSql = [NSString stringWithFormat:@"SELECT AREA_NAME from s_area WHERE AREA_CODE ='%@' AND AREA_PARENT_CODE = '%@' AND AREA_TYPE = 'city'",strCode,province];
            }else {
                strSql = [NSString stringWithFormat:@"SELECT AREA_NAME from s_area WHERE AREA_CODE ='%@' AND AREA_TYPE = 'city'",strCode];
            }
        }else {
            if (city && ![city isEqualToString:@""]) {
                strSql = [NSString stringWithFormat:@"SELECT AREA_NAME from s_area WHERE AREA_CODE ='%@' AND AREA_PARENT_CODE = '%@' AND AREA_TYPE = 'area'",strCode,city];
            }else {
                strSql = [NSString stringWithFormat:@"SELECT AREA_NAME from s_area WHERE AREA_CODE ='%@' AND AREA_TYPE = 'area'",strCode];
            }
        }
        FMResultSet *result = [dataBase executeQuery:strSql];
        
        NSString *name= @"";
        
        while (result.next) {
            name = [result stringForColumn:@"AREA_NAME"];
        }
        
        [self closeDB];
        
        return name;
    }
    [self closeDB];
    return @"";
}


- (NSArray *)provinceAll {
    if ([self opDb]) {
        NSString *strSql = @"SELECT AREA_NAME from s_area WHERE AREA_TYPE = 'province' AND AREA_STS = 'A'  order by AREA_CODE asc";
        FMResultSet *result = [dataBase executeQuery:strSql];
        
        NSMutableArray *arr = [NSMutableArray array];
        
        while (result.next) {
            if ([result stringForColumn:@"AREA_NAME"]) {
               [arr addObject:[result stringForColumn:@"AREA_NAME"]];
            }
        }
        [self closeDB];
        return arr;
    }
    [self  closeDB];
    return nil;
}
- (NSArray *)cityAllFromProv:(NSString *)provinceName {
    if ([self opDb]) {
        NSString *strSearchCodeSql = [NSString stringWithFormat:@"SELECT AREA_CODE from s_area WHERE AREA_TYPE = 'province' AND AREA_STS = 'A' AND AREA_NAME = '%@'",provinceName];
        FMResultSet *resultCode = [dataBase executeQuery:strSearchCodeSql];
        NSString *code= @"";
        
        while (resultCode.next) {
            code = [resultCode stringForColumn:@"AREA_CODE"];
        }
        if (code) {
            NSString *strSql = [NSString stringWithFormat:@"SELECT AREA_NAME from s_area WHERE AREA_TYPE = 'city' AND AREA_STS = 'A' AND AREA_PARENT_CODE = '%@'order by AREA_CODE asc",code];
            FMResultSet *result = [dataBase executeQuery:strSql];
            
            NSMutableArray *arr = [NSMutableArray array];
            
            while (result.next) {
                if ([result stringForColumn:@"AREA_NAME"]) {
                    [arr addObject:[result stringForColumn:@"AREA_NAME"]];
                }
            }
            [self closeDB];
            return arr;
        }
    }
    [self  closeDB];
    return nil;
}
- (NSArray *)areaAllFromProv:(NSString *)provinceName andCityName:(NSString *)cityName {
    if ([self opDb]) {
        NSString *strSearchCodeSql = [NSString stringWithFormat:@"SELECT AREA_CODE from s_area WHERE AREA_TYPE = 'province' AND AREA_STS = 'A' AND AREA_NAME = '%@'",provinceName];
        FMResultSet *resultCode = [dataBase executeQuery:strSearchCodeSql];
        NSString *code= @"";
        
        while (resultCode.next) {
            code = [resultCode stringForColumn:@"AREA_CODE"];
        }
        
        NSString *strCityCodeSql = [NSString stringWithFormat:@"SELECT AREA_CODE from s_area WHERE AREA_TYPE = 'city' AND AREA_STS = 'A' AND AREA_PARENT_CODE = '%@' AND AREA_NAME = '%@'",code,cityName];
        FMResultSet *resultCityCode = [dataBase executeQuery:strCityCodeSql];
        NSString *citycode= @"";
        
        while (resultCityCode.next) {
            citycode = [resultCityCode stringForColumn:@"AREA_CODE"];
        }
        if (citycode) {
            NSString *strSql = [NSString stringWithFormat:@"SELECT AREA_NAME from s_area WHERE AREA_TYPE = 'area' AND AREA_STS = 'A' AND AREA_PARENT_CODE = '%@'order by AREA_CODE asc",citycode];
            FMResultSet *result = [dataBase executeQuery:strSql];
            
            NSMutableArray *arr = [NSMutableArray array];
            
            while (result.next) {
                if ([result stringForColumn:@"AREA_NAME"]) {
                    [arr addObject:[result stringForColumn:@"AREA_NAME"]];
                }
            }
            [self closeDB];
            return arr;
        }
    }
    [self  closeDB];
    return nil;
}




- (void)closeDB {
    if (dataBase) {
        [dataBase close];
    }
}

- (BOOL)isMatchWithProvince:(NSString *)province andCity:(NSString *)city andAera:(NSString *)aera
{
    NSArray *cityArray = [self cityAllFromProv:StringOrNull(province)];
    if([cityArray containsObject:city])
    {
        if (aera.length > 0) {
            NSArray *earaArray = [self areaAllFromProv:StringOrNull(province) andCityName:StringOrNull(city)];
            if([earaArray containsObject:aera])
            {
                return YES;
            }else
            {
                return NO;
            }
        }
        return YES;
    }else
    {
        return NO;
    }

}

@end
