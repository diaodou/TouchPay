//
//  SearchCityOrCode.h
//  personMerchants
//
//  Created by xuxie on 16/5/28.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SearchTye) {
    typeProvince,
    typeCity,
    typeArea
};

@interface SearchCityOrCode : NSObject

- (NSString *)searchCode:(NSString *)strName provinceCode:(NSString *)province cityCode:(NSString *)city type:(SearchTye)searchType;

- (NSString *)searchName:(NSString *)strCode provinceCode:(NSString *)province cityCode:(NSString *)city type:(SearchTye)searchType;

- (NSArray *)provinceAll;
- (NSArray *)cityAllFromProv:(NSString *)provinceName;
- (NSArray *)areaAllFromProv:(NSString *)provinceName andCityName:(NSString *)cityName;

- (BOOL)isMatchWithProvince:(NSString *)province andCity:(NSString *)city andAera:(NSString *)aera;

@end
