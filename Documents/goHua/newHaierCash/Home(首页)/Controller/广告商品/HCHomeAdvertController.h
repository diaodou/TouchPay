//
//  HCHomeAdvertController.h
//  newHaierCash
//
//  Created by Will on 2017/6/1.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Kpad;

@interface HCHomeAdvertController : UIViewController

@property (nonatomic, strong) Kpad *kpadModel;

@property (copy) void(^clickReponder)();

@end
