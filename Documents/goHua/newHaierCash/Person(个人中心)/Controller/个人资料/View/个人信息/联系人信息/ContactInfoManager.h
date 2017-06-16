//
//  ContactInfo.h
//  personMerchants
//
//  Created by LLM on 2017/1/12.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "contectModel.h"

@interface ContactInfoManager : NSObject

@property(nonatomic,assign)BOOL ifFromTE;//是否从提额流程进入

//初始化数据源
- (instancetype)initWithType;

//得到数据源数组
- (NSArray *)arrayCompanyData;

//判断数据是否符合要求
- (NSString *)strInfoJudgeWithType;

//将单位信息model的对应字段放进数据源
- (void)modelToInfo:(ContactBody *)contactBody;

//创建上传数据的参数字典数组
- (NSMutableArray *)infoToJsonWithType;

@end
