//
//  LoanDetailsViewController.h
//  personMerchants
//
//  Created by Apple on 16/3/18.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanDetailModel.h"

@interface LoanDetailsViewController : UIViewController

@property(nonatomic,strong) NSString *applseq ;//申请流水号

@property(nonatomic,strong) NSString *loanNo;//借据号

@property(nonatomic,strong) LoanDetailModel *loanDetailModel ;//贷款详情model

@property(nonatomic,strong) NSString * from;//判断有那个界面进入

@property(nonatomic,strong) NSString * haveContract;//合同展示

@property(nonatomic,copy) NSString *ifSettled;//是否已结清

@property(nonatomic, copy) NSString *stateStr; //状态

@property(nonatomic, assign) BOOL onLine;  //是否是线上商品
@end
