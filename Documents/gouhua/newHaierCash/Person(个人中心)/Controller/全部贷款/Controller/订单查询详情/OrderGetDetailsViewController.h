//
//  OrderGetDetailsViewController.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,OrderGetDetailType) {
    
    BeReturnLoanByMerchant,   //被退回商品贷 商户

    waitSubmitCash,           //待提交现金贷

    waitSubmitLoan,           //待提交商品贷

    MsgWaitSubmitCash         //信息列表待提交现金贷
};
@interface OrderGetDetailsViewController : UIViewController

@property(nonatomic,assign)OrderGetDetailType loanName;

@property (nonatomic,copy)NSString *msgId;

@property (nonatomic,copy)NSString * formTyp;

@end
