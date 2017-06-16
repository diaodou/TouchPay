//
//  PersonInfoModel.h
//  HaiFu
//
//  Created by 史长硕 on 17/2/9.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllPersonInfo.h"
#import "TypeClass.h"
@interface PersonInfoModel : NSObject

@property(nonatomic,strong)NSMutableArray *dataArray;

-(instancetype)initWithInfoModel:(AllPersonInfoBody *)model;

-(NSMutableArray *)getDataArray;

-(void)insertInfoData;

- (NSString *)strInfoJudge;

@end
