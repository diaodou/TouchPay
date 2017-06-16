//
//  CompanyModel.h
//  TestC
//
//  Created by xuxie on 17/1/3.
//  Copyright © 2017年 chinaredstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CompanyModel.h"

@interface CompanyInfo : NSObject

//初始化数据源
- (instancetype)initWithType;

//得到数据源数组
- (NSArray *)arrayCompanyData;

//判断数据是否符合要求
- (NSString *)strInfoJudge;

//将单位信息model的对应字段放进数据源
- (void)modelToInfo:(CompanyBody *)companybody;

//创建上传数据的参数字典
- (NSDictionary *)infoToJsonWithType;

@end
