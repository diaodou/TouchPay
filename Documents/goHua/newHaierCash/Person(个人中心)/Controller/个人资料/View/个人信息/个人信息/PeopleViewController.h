//
//  PeopleViewController.h
//  personMerchants
//
//  Created by LLM on 2017/1/5.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeopleViewController : UIViewController

@property (nonatomic,assign) NSInteger currentIndex;  //判断当前选择的是那一栏
@property (nonatomic,assign) BOOL ifFromTe;//是否从提额流程进入

@end
