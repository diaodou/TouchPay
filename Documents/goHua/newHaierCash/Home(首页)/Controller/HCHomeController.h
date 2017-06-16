//
//  HCHomeController.h
//  newHaierCash
//
//  Created by Will on 2017/5/27.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdvertSelectModel;

@interface HCHomeController : UIViewController

@property (nonatomic, strong)AdvertSelectModel *advertModel;

- (void)showKPController;
@end
