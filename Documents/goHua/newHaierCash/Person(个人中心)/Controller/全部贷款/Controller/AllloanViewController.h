//
//  AllloanViewController.h
//  personMerchants
//
//  Created by LLM on 16/11/8.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ShowList) {

        showAllList,   //全部贷款
        showBeReturnList   //待还款
};
@interface AllloanViewController : UIViewController

@property (nonatomic,assign)ShowList showList;

@end
