//
//  LoanDetailModel.h
//  personMerchants
//  贷款详情
//  Created by 张久健 on 16/6/1.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LoanDetailHead,LoanDetailBody,LoanGoods;
@interface LoanDetailModel : NSObject

@property (nonatomic, strong) LoanDetailHead *head;

@property (nonatomic, strong) LoanDetailBody *body;

@end


@interface LoanDetailHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface LoanDetailBody : NSObject

@property (nonatomic, assign) float proPurAmt;//商品总额

@property (nonatomic, copy) NSString *contNo;//合同号

@property (nonatomic, copy) NSString *applCde;//贷款编号

@property (nonatomic, copy) NSString *indivMobile;//客户手机号

@property (nonatomic, copy) NSString *idNo;//客户证件号码

@property (nonatomic, copy) NSString *applSeq;//申请流水号

@property (nonatomic, copy) NSString *applyTnr;//还款期限

@property (nonatomic, copy) NSString *applAcBankDesc;//放款开户银行名

@property (nonatomic, copy) NSString *feeAmt;//费用总额

@property (nonatomic, copy) NSString *appOutAdvice;//退回原因

@property (nonatomic, copy) NSString *applAcBank;//放款开户银行代码

@property (nonatomic, copy) NSString *payMtd;//还款方式代码

@property (nonatomic, copy) NSString *mailOpt;//送货地址选项

@property (nonatomic, copy) NSString *custId;//客户编号（信贷）此客户编号为信贷系统生成，与其他接口查询到的客户编号不同

@property (nonatomic, copy) NSString *applyDt;//申请日期

@property (nonatomic, copy) NSString *loanNo;//借据号

@property (nonatomic, copy) NSString *payMtdDesc;//还款方式名称

@property (nonatomic, copy) NSString *applyAmt;//借款总额

@property (nonatomic, copy) NSString *loanTypName;//贷款品种名称

@property (nonatomic, copy) NSString *setlPrcpAmt;//已还本金

@property (nonatomic, copy) NSString *mtdDesc;

@property (nonatomic, copy) NSString *mthAmt;//每期还款额

@property (nonatomic, copy) NSString *repayPrcpAmt;//剩余本金

@property (nonatomic, copy) NSString *fstPay;//首付金额

@property (nonatomic, copy) NSString *superCoopr;//商户编号

@property (nonatomic, copy) NSString *mailAddr;//送货地址

@property (nonatomic, copy) NSString *mtdCde;

@property (nonatomic, copy) NSString *repayApplCardNo;

@property (nonatomic, copy) NSString *repayAccBankName;

@property (nonatomic, copy) NSString *applCardNo;

@property (nonatomic, copy) NSString *accBankName;

@property (nonatomic, copy) NSString *typGrp;//贷款类型

@property (nonatomic, strong) NSArray<LoanGoods *> *goods;

@property (nonatomic, copy) NSString *idTyp;//客户证件类型

@property (nonatomic, copy) NSString *applyTnrTyp;//还款期限类型

@property (nonatomic, copy) NSString *loanTyp;//贷款品种代码

@property (nonatomic, copy) NSString *cooprCde;//门店编号

@property (nonatomic, copy) NSString *applAcBch;//放款开户银行分支行代码

@property (nonatomic, copy) NSString *applAcBchDesc;//放款开户银行分支行名

@property (nonatomic, copy) NSString *custName;//客户姓名

@property (nonatomic, copy) NSString *psNormIntAmt;//总利息金额

@property (nonatomic, copy) NSString *channelNo;

@property (nonatomic, copy) NSString *apprvAmt;//贷款审批金额

@property (nonatomic, copy) NSString *appInAdvice;//备注

@property (nonatomic, copy) NSString *expectCredit;//额度期望值

@property (nonatomic, copy) NSString *rlx; //日利息

@property (nonatomic, copy) NSString *isAllowReturn;  //是否可以申请退货

@property (nonatomic, copy) NSString *formTyp;  //订单状态

@property (nonatomic, copy) NSString *outSts;//状态

@end

@interface LoanGoods : NSObject

@property (nonatomic, assign) NSInteger goodsNum;//数量

@property (nonatomic, copy) NSString *goodsCode;//编号

@property (nonatomic, assign) float goodsPrice;//价格

@property (nonatomic, copy) NSString *goodsName;//名称

@end

