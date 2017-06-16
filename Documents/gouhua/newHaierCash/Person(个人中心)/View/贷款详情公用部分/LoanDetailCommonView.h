//
//  LoanDetailCommonView.h
//  贷款详情
//
//  Created by 百思为科 on 16/4/3.
//  Copyright © 2016年 百思为科iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanTopView.h"
typedef NS_ENUM(NSInteger, LoanHandlingTypes) {
    loanFallback,  //被退回
    loanProductDetailCommit, //详情提交
    loanApprovaling,   //审批
    loanOutDate,       //逾期
    loanHasAppointment,  //预约
    loanMakeAppoint // 合同签订
};
@interface LoanDetailCommonView : UIView

@property (nonatomic, strong) LoanTopView *loanTopView;

@property (nonatomic, strong) UILabel *priManey; //分期本金

@property (nonatomic, strong) UILabel *divManey; //利息

@property (nonatomic, strong) UILabel *totalManey; //总金额

@property (nonatomic, strong) UILabel *interestDays; //利息天数

@property (nonatomic, strong) UILabel *summary;  //底部总结

@property (nonatomic, assign) LoanHandlingTypes loanHandlingType; //贷款类型

@property (nonatomic, strong) UIButton *btnCommit;

+ (CGFloat)heightView:(LoanHandlingTypes)loanHandlingType;
@end
