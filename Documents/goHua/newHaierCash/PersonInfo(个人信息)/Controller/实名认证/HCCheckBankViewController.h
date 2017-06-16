//
//  HCCheckBankViewController.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendSuccessDelegate.h"
@interface HCCheckBankViewController : UIViewController

@property(nonatomic,weak)id<SendSuccessDelegate> delegate;

@property (nonatomic,strong) UIImageView *cardPosiviteImageView;//身份证正面照片

@property (nonatomic,strong) UIImageView *cardTheOtherImageView;//身份证反面照片

@property(nonatomic,strong) NSMutableDictionary *cardDic;

@end
