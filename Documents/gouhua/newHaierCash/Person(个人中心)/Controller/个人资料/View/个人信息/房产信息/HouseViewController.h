//
//  HouseViewController.h
//  personMerchants
//
//  Created by 百思为科 on 17/1/10.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HouseModel.h"
#import "ShowType.h"

@interface HouseViewController : UIViewController

@property (nonatomic,strong)HouseBody *houseBody;  //房产信息Model

@property (nonatomic,copy) void(^showPikerViewShow)(ShowPickViewType ); //展示pikerView
@property (nonatomic,copy) void(^sendParmDict)(NSDictionary *);        //参数字典


//将选择器的选择的数据传过来
- (void)reloadTableViewWithDictionary:(NSDictionary *)dict andType:(ShowPickViewType)type;

//刷新数据源
- (void)reloadHouseInfo;

//判断当前view信息是否填完的方法
- (BOOL)judgePersonInfoCompelete;

@end

