//
//  ReturnPlanViewController.h
//  personMerchants
//
//  Created by 百思为科 on 16/4/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
#import "StageApplicationModel.h"

//从哪个页面跳转过来
typedef NS_ENUM (NSInteger,pushType )
{
   fromGoodsByStages = 1,//商品贷
   fromMoneyStage    //现金贷
};

@interface ReturnPlanViewController : HCBaseViewController

@property (nonatomic,assign) pushType pushType;//判断从哪个界面进入

@property (nonatomic,strong) StageApplicationModel *planModel;//接受传过来的model

@property(nonatomic,copy)NSString *nameOne;
@property(nonatomic,copy)NSString *nameTwo;
@property(nonatomic,copy)NSString *showOne;
@property(nonatomic,copy)NSString *showTwo;
@end
