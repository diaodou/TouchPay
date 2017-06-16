//
//  HCMapLocation.m
//  personMerchants
//
//  Created by 王晓栋 on 16/5/26.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "RMUniversalAlert.h"

#import "HCMapLocation.h"
#import "SearchCityOrCode.h"
#import "HCMacro.h"

@interface HCMapLocation()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}


@end
@implementation HCMapLocation


- (void)openLocationService{
    // 开始定位
    
    if ([CLLocationManager locationServicesEnabled] &&(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
                                                        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways))){
        
        if (!_locationManager) {
            _locationManager=[[CLLocationManager alloc]init];
            _locationManager.delegate = self;
            _locationManager.distanceFilter = kCLLocationAccuracyThreeKilometers;
            // 3. 定位精度
            [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            
            if (IOS8_OR_LATER) {
                  [_locationManager requestWhenInUseAuthorization];//?只在前台开启定位
              //  [_locationManager requestAlwaysAuthorization];//?在后台也可定位
            }
            if (IOS9_OR_LATER) {
              //  _locationManager.allowsBackgroundLocationUpdates = NO;
                
            }
            [_locationManager startUpdatingLocation];
        }else {
            [_locationManager startUpdatingLocation];
        }
    }else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || kCLAuthorizationStatusRestricted == [CLLocationManager authorizationStatus] )
    {
        self.locationStatus = LocationNoAuthority;
    }
}

#pragma mark - CLLocationDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.locationStatus = LocationFail;
    _myCoordinate2D = kCLLocationCoordinate2DInvalid;
    if (error) {
        
    }else {
        
    }
}




-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    
    _currentLocation = location;
    _myCoordinate2D = coordinate;

    //逆地理编码
    [self reverseGeocodeLocation];
}

//逆地理编码
- (void)reverseGeocodeLocation
{
    // 保存 Device 的现语言 (英语 法语 ，，，)
    NSMutableArray
    *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                             objectForKey:@"AppleLanguages"];
    
    
    // 强制 成 简体中文
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil] forKey:@"AppleLanguages"];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];//反向解析，根据及纬度反向解析出地址
    [geoCoder reverseGeocodeLocation:_currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            for(CLPlacemark *place in placemarks)
            {
                NSDictionary *dict = [place addressDictionary];
                NSLog(@"%@",dict);
                if ([dict valueForKey:@"CountryCode"]) {
                    if ( [[dict valueForKey:@"CountryCode"]isEqualToString:@"CN"])
                    {
                        self.locationStatus = LocationInChina;
                    }else {
                        self.locationStatus = LocationNotInChina;
                    }
                }
                
                _strCity = [dict valueForKey:@"City"];
                _strProvince = dict[@"State"];
                _stringArea = [dict objectForKey:@"SubLocality"];
                //只有在中国,城市编码才是有意义的
                if(self.locationStatus == LocationInChina)
                {
                    if(!isEmptyString(_strProvince))
                    {
                        //城市编码成功
                        self.locationStatus = LocationGeoCitySucess;
                    }else
                    {
                        self.locationStatus = LocationGeoCityFail;
                    }
                    
                    NSArray *array = [dict objectForKey:@"FormattedAddressLines"];
                    
                    if (array.count > 0) {
                        
                      _strAddreDetail = [NSString stringWithFormat:@"%@",array[0]];
                        
                    }else{
                        
                        _strAddreDetail = [NSString stringWithFormat:@"%@%@%@%@%@",_strProvince,_strCity,_stringArea,[dict objectForKey:@"Street"],[dict objectForKey:@"Name"]];
                        
                    }
                    
                }
                
                SearchCityOrCode *search = [[SearchCityOrCode alloc]init];
                _strProvinceCode = [search searchCode:StringOrNull(_strProvince) provinceCode:@"" cityCode:@"" type:typeProvince];
                _strCityCode = [search searchCode:StringOrNull(_strCity) provinceCode:StringOrNull(_strProvinceCode) cityCode:@"" type:typeCity];
                _strAreaCode = [search searchCode:StringOrNull(_stringArea) provinceCode:StringOrNull(_strCityCode) cityCode:@"" type:typeArea];
            }
            [_locationManager stopUpdatingLocation];
        }else {
            [_locationManager startUpdatingLocation];
            self.locationStatus = LocationGeoCityFail;
        }
        // 还原Device 的语言
        [[NSUserDefaults
          standardUserDefaults] setObject:userDefaultLanguages
         forKey:@"AppleLanguages"];
    }];
}

#pragma mark - 获取地理位置信息
- (BOOL)getLocationStatusWithController:(UIViewController *)controller {
    //地理位置加判断
    if(self.locationStatus == LocationNoAuthority) {
        //提示没有权限
        [self showNoAuthorityAlertWith:controller];
    } else if (self.locationStatus == LocationNotInChina) {
        //提示不在中国
        [self showNotInChinaAlertWith:controller];
    }
    else if(self.locationStatus == LocationGeoCitySucess) {
        return YES;
    }else {
        //提示定位失败
        [self showLocationFailAlertWith:controller];
    }
    return NO;
}

#pragma mark --地理位置提示语--
//没有权限的提示框
- (void)showNoAuthorityAlertWith:(UIViewController *)con
{
    [RMUniversalAlert showAlertInViewController:con withTitle:@"提示" message:@"尚未获取您的位置，请开启定位服务或移动至开阔地带！" cancelButtonTitle:@"取消" destructiveButtonTitle:@"设置" otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        if (buttonIndex == 1)
        {
            //去设置页面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }];
}

//不在中国的提示框
- (void)showNotInChinaAlertWith:(UIViewController *)con
{
    [RMUniversalAlert showAlertInViewController:con withTitle:@"提示" message:@"当前业务仅支持在中国" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
    }];
}

//解析失败或者定位失败的提示框
- (void)showLocationFailAlertWith:(UIViewController *)con
{
    WEAKSELF
    [RMUniversalAlert showAlertInViewController:con withTitle:@"提示" message:@"尚未获取您的位置，请开启GPS定位权限" cancelButtonTitle:@"知道了" destructiveButtonTitle:nil otherButtonTitles:nil tapBlock:^(RMUniversalAlert * _Nonnull alert, NSInteger buttonIndex) {
        STRONGSELF
        if (strongSelf) {
            if (buttonIndex == 0) {
                [strongSelf openLocationService];
            }
        }
    }];
}
@end
