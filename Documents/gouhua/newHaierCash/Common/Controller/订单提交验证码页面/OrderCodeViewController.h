//
//  OrderCodeViewController.h
//  newHaierCash
//
//  Created by 史长硕 on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
@interface OrderCodeViewController : HCBaseViewController

@property(nonatomic,assign)BOOL firstMentionQuote;//是否是第一次额度申请或者第一次提额

@property(nonatomic,assign)BOOL ifFromTE;//是否从提额流程过来

@property(nonatomic,assign)BOOL ifFromCredit;//是否从申请放款流程过来


@end
