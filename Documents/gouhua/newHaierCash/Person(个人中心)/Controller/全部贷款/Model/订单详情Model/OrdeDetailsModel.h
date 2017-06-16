//
//  OrdeDetailsModel.h
//  personMerchants
//  订单详情
//  Created by 百思为科 on 16/6/5.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OrderDetailsHead,OrderDetailsBody,OrderDetailsGoods;
@interface OrdeDetailsModel : NSObject

@property (nonatomic, strong) OrderDetailsHead *head;

@property (nonatomic, strong) OrderDetailsBody *body;

@end


@interface OrderDetailsHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface OrderDetailsBody : NSObject

@property (nonatomic, copy) NSString *proPurAmt;

@property (nonatomic, copy) NSString *crtUsr;

@property (nonatomic, copy) NSString *indivMobile;

@property (nonatomic, copy) NSString *typCde;

@property (nonatomic, copy) NSString *totalnormint;

@property (nonatomic, copy) NSString *idNo;

@property (nonatomic, copy) NSString *repayAccBchName;

@property (nonatomic, copy) NSString *applyTnr;

@property (nonatomic, copy) NSString *backReason;

@property (nonatomic, copy) NSString *payMtd;

@property (nonatomic, copy) NSString *isConfirmContract;

@property (nonatomic, copy) NSString *applyDt;

@property (nonatomic, copy) NSString *accAcBchName;

@property (nonatomic, copy) NSString *deliverAddrTyp;

@property (nonatomic, copy) NSString *isCustInfoCompleted;

@property (nonatomic, copy) NSString *payMtdDesc;

@property (nonatomic, copy) NSString *cooprName; //地址

@property (nonatomic, copy) NSString *applyAmt;

@property (nonatomic, copy) NSString *merchNo;

@property (nonatomic, copy) NSString *repayAccBankCde;

@property (nonatomic, copy) NSString *typDesc;

@property (nonatomic, copy) NSString *fstPay;

@property (nonatomic, copy) NSString *accBankName;

@property (nonatomic, copy) NSString *applCardNo;

@property (nonatomic, copy) NSString *repayAccBchCde;

@property (nonatomic, copy) NSString *accBankCde;

@property (nonatomic, copy) NSString *typGrp;

@property (nonatomic, copy) NSString *accAcBchCde;

@property (nonatomic, copy) NSString *repayApplCardNo;

@property (nonatomic, copy) NSString *repayAccBankName;

@property (nonatomic, copy) NSString *custNo;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, strong) NSArray<OrderDetailsGoods *> *goods;

@property (nonatomic, copy) NSString *idTyp;

@property (nonatomic, copy) NSString *applyTnrTyp;

@property (nonatomic, copy) NSString *applseq;

@property (nonatomic, copy) NSString *cooprCde;

@property (nonatomic, copy) NSString *custName;

@property (nonatomic, copy) NSString *totalfeeamt;

@property (nonatomic, copy) NSString *purpose;

@property (nonatomic, copy) NSString *isConfirmAgreement;

@property (nonatomic, copy) NSString *deliverAddr;

@property (nonatomic, copy) NSString *deliverProvince;

@property (nonatomic, copy) NSString *deliverCity;

@property (nonatomic, copy) NSString *deliverArea;

@property (nonatomic, copy) NSString *xfze;

@property (nonatomic, copy) NSString *rlx;
#pragma mark - 这三个属性是信贷退回独有的
@property (nonatomic, copy) NSString *appInAdvice;

@property (nonatomic, copy) NSString *countCommonRepaymentPerson;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, assign) float mthAmt;

@end

@interface OrderDetailsGoods : NSObject

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *seqNo;

@property (nonatomic, copy) NSString *goodsModel;

@property (nonatomic, copy) NSString *goodsBrand;

@property (nonatomic, copy) NSString *goodsNum;

@property (nonatomic, copy) NSString *goodsPrice;

@property (nonatomic, copy) NSString *goodsCode;

@property (nonatomic, copy) NSString *goodsKind;

@end

