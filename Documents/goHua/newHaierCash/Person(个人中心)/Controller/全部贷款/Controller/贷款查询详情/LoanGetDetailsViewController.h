//
//  LoanGetDetailsViewController.h
//  personMerchants
//
//  Created by 百思为科 on 16/6/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SubSignContractModel.h"
//#import "SubSignContModel.h"
typedef NS_ENUM(NSInteger ,LoanGetDetailType) {
    
    ExaminationCash,          //审批中现金贷
    
    ExaminationLoan,          //审批中商品贷
    
    BeReturnCash,             //被退回 现金贷

    BeReturnLoan,             //被退回 商品贷

    CashHaveCancel,           //现金贷已取消

    LoanHaveCancel,           //商品贷已取消

    AuditCash,                //放款审核中

    WaitPickUp,               //待取货

    waitCashDischarge,        //审批 申请放款

    LoanBeRefuse,             //贷款被拒绝

    WaitCashHaveExamination,  //审批通过 等待放款

    BeCancelLoan,             //取消放款

    MsgExaminationLoan,       //消息审批中商品贷

    MsgExaminationCash       //消息审批中现金贷

};

@interface LoanGetDetailsViewController : UIViewController

@property(nonatomic,assign)LoanGetDetailType loanName;

@property (nonatomic,copy)NSString *msgId;

@property (nonatomic,copy)NSString * haveContract;

@property (nonatomic,copy)NSString * formTyp;
@property(nonatomic,assign)BOOL returnLastView;//是否返回上一页面
@end
