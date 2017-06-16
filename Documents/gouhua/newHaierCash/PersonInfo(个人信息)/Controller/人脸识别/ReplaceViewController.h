//
//  ReplaceViewController.h
//  personMerchants
//
//  Created by 百思为科 on 16/11/22.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"

@interface ReplaceViewController : HCBaseViewController

@property(nonatomic,strong)NSArray *imageArray;//影像数组

@property(nonatomic,copy)NSString *typCde;//贷款品种代码

@property(nonatomic,assign)BOOL ifFromTE;//是否从提额页面进入

@property(nonatomic,assign)BOOL ifFromPerson;//是否从个人资料页面进入

@end
