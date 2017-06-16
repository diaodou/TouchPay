//
//  HCMapLocation.h
//  personMerchants
//
//  Created by 王晓栋 on 16/5/26.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
//定位的状态
typedef NS_ENUM(NSInteger,LocationStatus)
{
    LocationFail,           //因为网络问题,或者权限问题失败
    LocationNoAuthority,    //没有权限
    LocationInChina,        //在中国
    LocationNotInChina,     //不在中国
    LocationGeoCitySucess,  //逆地理编码成功(前提是在中国,能获得省份)
    LocationGeoCityFail     //逆地理编码失败(前提是在中国,但没有获取省)
};

@interface HCMapLocation : NSObject

@property (nonatomic, assign) BOOL bLocation;

@property (nonatomic, assign) CLLocationCoordinate2D myCoordinate2D;
@property (nonatomic, strong) NSString *strProvince;
@property (nonatomic, strong) NSString *strCity;
@property (nonatomic, strong) NSString *stringArea;
@property (nonatomic, strong) NSString *strProvinceCode;
@property (nonatomic, strong) NSString *strCityCode;
@property (nonatomic, strong) NSString *strAreaCode;
@property (nonatomic, strong) NSString *strAddreDetail;
@property (nonatomic, assign) LocationStatus locationStatus;    //判断定位状态
@property (nonatomic, strong) CLLocation *currentLocation;      //当前位置


- (void)openLocationService;

//逆地理编码
- (void)reverseGeocodeLocation;


- (BOOL)getLocationStatusWithController:(UIViewController *)controller;

@end
