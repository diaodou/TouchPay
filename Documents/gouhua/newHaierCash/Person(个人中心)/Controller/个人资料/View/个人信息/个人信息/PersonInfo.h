//
//  PersonInfo.h
//  personMerchants
//
//  Created by 百思为科 on 17/1/10.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonalMessageModel.h"

@interface PersonInfo : NSObject

//初始化数据源
- (instancetype)initWithType;

//得到数据源数组
- (NSArray *)arrayPersonData;

//判断数据是否符合要求
- (NSString *)strInfoJudge;

//将单位信息model的对应字段放进数据源
- (void)modelToInfo:(personBody *)personbody;

//创建上传数据的参数字典
- (NSDictionary *)infoToJsonWithType;

//删除"最高额度"字段,并将删除后的数组返回
- (NSArray *)deleteZGEDUIType;

//插入"最高额度"字段,并将删除后的数组返回
- (NSArray *)insertZGEDUIType;
@end
