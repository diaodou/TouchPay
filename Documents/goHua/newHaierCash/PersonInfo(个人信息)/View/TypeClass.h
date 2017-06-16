//
//  TypeClass.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 17/1/10.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ShowType.h"
@interface TypeClass : NSObject

@property(nonatomic,copy)NSString *title;//左侧标题

@property(nonatomic,copy)NSString *placeholder;//输入框时的默认文字

@property(nonatomic,copy)NSString *errorTipOne;//第一种错误时的提示语

@property(nonatomic,copy)NSString *regularOne;//第一种正则表达式

@property(nonatomic,assign)ShowPickViewType showType;//选择器的分类

@property(nonatomic,strong)NSArray *showArray;

@property(nonatomic,assign)UIKeyboardType boardType;//键盘类型

@property(nonatomic,copy)NSString *result;//右侧数据

@property(nonatomic,copy)NSString *saveHttpKey;//保存订单信息时的key

@property(nonatomic,copy)NSString *code;//选择选项对应的代码

@property(nonatomic,copy)NSString *key;//选择选项的值

@property(nonatomic,copy)NSString *provinceCode;//省份代码

@property(nonatomic,copy)NSString *cityCode;//市代码

@property(nonatomic,copy)NSString *areaCode;//区代码

@property(nonatomic,strong)NSNumber *friendId;//联系人id

@property(nonatomic,strong)NSMutableDictionary *PeopleCityDic;//用于保存单位地址省市区代码

@property(nonatomic,strong)NSMutableDictionary *CompanyCityDic;//用于保存个人居住地址省市区


@property(nonatomic,assign)BOOL isEdit;//是否可以编辑输入

-(void)searchCityNameArray:(NSArray *)array proNum:(NSInteger)proNumber cityNum:(NSInteger)cityNumber araeNum:(NSInteger)areaNumber;

@end
