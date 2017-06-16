//
//  HCMacro.h
//  newHaierCash
//
//  Created by Will on 2017/5/25.
//  Copyright © 2017年 haier. All rights reserved.
//

#ifndef HCMacro_h
#define HCMacro_h

/*
 设备检测
 */

#define IPHONE4 ( [ [ UIScreen mainScreen ] bounds ].size.height == 480 )

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iphone6 [UIScreen mainScreen].bounds.size.height == 667

#define iphone6P [UIScreen mainScreen].bounds.size.height == 736

/*
 设备版本检测
 */

#define IOS8_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")

#define IOS9_OR_LATER SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")

#define ISIOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") && SYSTEM_VERSION_LESS_THAN(@"8.0")

#define ISIOS8  SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && SYSTEM_VERSION_LESS_THAN(@"9.0")

/*
 设备版本比较
 */

//大于
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)

//大于等于
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//小于
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

//小于等于

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


/*
 设备尺寸
 */
#define DeviceWidth ([[UIScreen mainScreen] bounds].size.width)
#define DeviceHeight ([[UIScreen mainScreen] bounds].size.height)

// 尺寸获取

#define Width(x) CGRectGetWidth(x.frame)
#define Height(x) CGRectGetHeight(x.frame)


/*
 缩放比例
 */
#define scaleAdapter ((CGFloat)(DeviceWidth / 375.0))

#define scale6PAdapter ((CGFloat)(DeviceWidth / 414.0))
//图片缩放比例
#define ImageUpZScale (0.8f)
#define ImageLocalScale (0.6f)

/*
 block self
 */
#define WEAKSELF typeof(self) __weak weakSelf = self;
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf;

/*
 检测
 */
#define isNull(x)             (!x || [x isKindOfClass:[NSNull class]])
#define toInt(x)              (isNull(x) ? 0 : [x intValue])
#define isEmptyString(x)   (isNull(x) || [x isEqual:@""] || [x isEqual:@"(null)"] || (x == nil))
#define objectOrNull(obj) ((obj) ? (obj) : [NSNull null])
#define isNull(x)             (!x || [x isKindOfClass:[NSNull class]])
#define StringOrNull(obj) ((obj) ? (obj) : @"")


//--------------HaierCash专属------------------
//设置
#define ReturnRect CGRectMake(0, 0, 12, 16)

#define thinLineHeight 1 / [UIScreen mainScreen].scale
//颜色
#define TableView_BackColor @"#f6f6f9"
#define App_MainColor @"#32bfff"

//海尔会员
#define HAIERUAC @"HAIERUAC"

//旧方法，需改进
#define UIColorFromRGB(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


/*
 Notification 消息通知标识符
 */


#define SettingGuestPwd @"SettingGuestPwd"  //设置手势密码
#define GetAddressNotification @"GetAddressNotification"  //获取地理位置
#define LocationResult @"LocationMsg"  //定位地理位置
#define LocationRevGeoResult @"LocationRevGeo" //逆地理编码

/*
 系统第三方控件ID
 */
//百融
#define MyCid @"3000424"

//信鸽
#define xingeAppId (uint32_t)2200207538
#define xingeAppKey @"I2E9KQN9H66N"

//腾讯Bugly
#define buglyAppId @"26afd33dd1"

/*
 网络请求返回提示字符宏定义
 */
//网络请求返回判断
#define SucessCode @"00000"
#define FailCode @"11111"
#define NoFindCustExtInfo  @"C1109"
//贷款类型
#define CashCode @"02"  //现金贷

//账户信息
#define LimitStateFreeze @"20"   //冻结
#define LimitStateok @"10"  //正常
#define LimitStateChange @"30"  //变更中

//用户白名单类型
#define SocietyUser @"shh"
#define Auser  @"A"
#define Buser @"B"
#define Cuser @"C"


#define HFCachesPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject


#endif /* HCMacro_h */
