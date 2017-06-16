//
//  CompanyViewController.h
//  personMerchants
//
//  Created by LLM on 2017/1/5.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyModel.h"
#import "ShowType.h"


@interface CompanyViewController : UIViewController

@property (nonatomic,strong) CompanyBody *companyBody;   //单位信息的model

@property (nonatomic,copy) void(^showPikerViewShow)(ShowPickViewType); //展示pikerView

@property (nonatomic,copy) void(^sendParmDict)(NSDictionary *parmDict);        //参数字典

//将选择器的选择的数据传过来
- (void)reloadTableViewWithDictionary:(NSDictionary *)dict andType:(ShowPickViewType)type;

//判断当前view信息是否填完的方法
- (BOOL)judgeCompanyInfoCompelete;

//刷新数据源
- (void)reloadCompanyInfo;

@end
