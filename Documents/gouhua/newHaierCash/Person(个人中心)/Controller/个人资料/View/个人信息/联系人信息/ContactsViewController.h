//
//  ContactsViewController.h
//  personMerchants
//
//  Created by 百思为科 on 17/1/10.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "contectModel.h"
#import "ShowType.h"


@interface ContactsViewController : UIViewController

@property (nonatomic,strong) ContactBody *contectBody;         //联系人信息model

@property (nonatomic,copy) void(^showPikerViewShow)(ShowPickViewType); //展示pikerView

@property (nonatomic,copy) void(^sendParmDict)(NSArray *);    //参数字典数组
@property (nonatomic,assign) BOOL ifFromTE;//是否是从提额流程进入

//将选择器的选择的数据传过来
- (void)reloadTableViewWithDictionary:(NSDictionary *)dict andType:(ShowPickViewType)type;

//刷新数据源
- (void)reloadContactInfo;

//判断当前view信息是否填完的方法
- (BOOL)judgeContactInfoCompelete;

@end
