//
//  BorrowingMethodsViewController.h
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/6.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoiceCashLoanTypeDelegate <NSObject>

- (void)choiceCashLoanType:(NSString *)type;

@end
@interface HCBorrowingMethodsViewController : UIViewController

@property (nonatomic,weak)id<ChoiceCashLoanTypeDelegate>choiceCashloanTypedelegate;
@end
