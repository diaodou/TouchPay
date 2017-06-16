//
//  UpLimitInfoViewController.h
//  HaiFu
//
//  Created by 史长硕 on 17/2/14.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"

typedef NS_ENUM(NSInteger,FromViewClass){
    
    FromPersonData,//从个人资料进入
    
    FromTE,        //从提额进入
    
};

@interface UpLimitInfoViewController : HCBaseViewController

@property(nonatomic,assign) BOOL firstMentionQuote;//是否是第一次额度申请或提额

@property(nonatomic,assign) FromViewClass fromViewClass;//从哪个页面流程进入

@end
