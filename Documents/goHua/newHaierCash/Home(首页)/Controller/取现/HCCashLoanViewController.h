//
//  CashLoanViewController.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/2.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM (NSInteger ,Pushtype){
    
    loanTime = 1,  //借款期限
    toNext,    //确认提交
    assignmentBeReturn, //被退回赋值
    assignmentWaiting   //待提交赋值
};
@interface HCCashLoanViewController : UIViewController

@property(nonatomic,assign) Pushtype pushType; //点击动作区分

@end
