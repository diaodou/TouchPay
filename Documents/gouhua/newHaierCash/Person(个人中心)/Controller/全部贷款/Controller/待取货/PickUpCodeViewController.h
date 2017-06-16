//
//  PickUpCodeViewController.h
//  personMerchants
//
//  Created by 陈相孔 on 16/3/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeCodeModel.h"
@interface PickUpCodeViewController : UIViewController

@property (nonatomic,strong)TradeCodeModel * tradeCodeModel;

@property (nonatomic,copy)NSString * codeStr;
@end
