//
//  HouseInfo.h
//  personMerchants
//
//  Created by 百思为科 on 17/1/11.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HouseModel.h"
typedef NS_ENUM(NSInteger, HouseType) {

    HaveHouseNoLoan = 1, //自购现无贷款
    HaveHouseHaveLoan,   //自购现有贷款
    Other                //其他类型
};
@interface HouseInfo : NSObject

//初始化数据源
- (instancetype)initWithType:(HouseType)type;
//得到数据源数组
- (NSArray *)arrayPersonData;

- (NSString *)strInfoJudge;

//获取房产状况
- (NSString *)houseSituation:(HouseBody *)houseBody;
//将单位信息model的对应字段放进数据源
- (void)modelToInfo:(HouseBody *)housebody WithType:(HouseType)type;

- (NSDictionary *)infoToJsonWithType:(HouseType)type;

@end
