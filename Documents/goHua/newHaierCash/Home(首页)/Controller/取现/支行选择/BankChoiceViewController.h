//
//  BankChoiceViewController.h
//  personMerchants
//
//  Created by 张久健 on 16/4/16.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYZCity.h"
#import "GYZChooseCityDelegate.h"
#import "HCMacro.h"
#import "BankChoiceModel.h"
#define     MAX_COMMON_CITY_NUMBER      8
#define     COMMON_CITY_DATA_KEY        @"GYZCommonCityArray"

@protocol SendBankNameDelegate <NSObject>

@optional
-(void)sendBankInfo:(BankChoiceBody *)body;

@end

@interface BankChoiceViewController : UIViewController
@property (nonatomic, weak) id <SendBankNameDelegate> delegate;

/*
 *  定位城市id
 */
@property (nonatomic, strong) NSString *locationCityID;

/*
 *  常用城市id数组,自动管理，也可赋值
 */
@property (nonatomic, strong) NSMutableArray *commonCitys;


/*
 *  城市数据，可在Getter方法中重新指定
 */
@property (nonatomic, strong) NSMutableArray *cityDatas;

@property (nonatomic, copy) NSString *strBackNo;  //银行编号

@property (nonatomic, copy) NSString *strBackCityCode;



@end

