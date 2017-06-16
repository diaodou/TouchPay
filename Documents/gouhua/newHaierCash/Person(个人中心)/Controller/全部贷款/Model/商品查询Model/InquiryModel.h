//
//  InquiryModel.h
//  personMerchants
//  商品详情
//  Created by 百思为科 on 16/5/7.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AdvertInfo.h"
//#import "ScanMsgModel.h"
//#import "WareDetailModel.h"
@class InquiryHead,InquiryBody,InquiryStore,InquiryLoan,InquiryListmenu;
@interface InquiryModel : NSObject

@property (nonatomic, strong) InquiryHead *head;

@property (nonatomic, strong) InquiryBody *body;

//- (instancetype)initWithGoodsinfo:(Goodsinfo *)Goodsinfo;
//
//- (instancetype)initWithScanMsgBody:(ScanMsgBody *)scanMsgBody;
//
//- (instancetype)initWithAdvertGoodsBody:(WareDetailBody *)scanMsgBody;

@end

@interface InquiryHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface InquiryBody : NSObject

@property (nonatomic, copy) NSString *goodsCode;

@property (nonatomic, strong) NSArray<InquiryLoan *> *loan;

@property (nonatomic, copy) NSString *storeCode;

@property (nonatomic, copy) NSString *goodsLine;

@property (nonatomic, copy) NSString *goodsName;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *kindCode;

@property (nonatomic, copy) NSString *goodsModel;

@property (nonatomic, copy) NSString *goodsPrice;

@property (nonatomic, strong) NSArray<InquiryStore *> *store;

@property (nonatomic, copy) NSString *pictureUrl;

@property (nonatomic, assign) NSInteger countGoodsCode;

@property (nonatomic, copy) NSString *brandCode;

@property (nonatomic, copy) NSString *kindName;

@property (nonatomic, copy) NSString *haveMenu;

@property (nonatomic, copy) NSString *brandName;

@property (nonatomic, copy) NSString *goodsDesc;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, copy) NSString *lastChgUser;

@property (nonatomic, copy) NSString *merchantCode;

@property (nonatomic, strong) NSArray<InquiryListmenu *> *listmenu;

@property (nonatomic, copy) NSString *loanCode;

@property (nonatomic, copy) NSString *goodsHtml;

@property (nonatomic ,copy) NSString *psPerdNo;

@property (nonatomic, copy) NSString *goodsHtmlUrl;

//- (instancetype)initWithGoodInfo:(Goodsinfo *)goodsInfo;
//
//- (instancetype)initWithScanMsgBody:(ScanMsgBody *)scanMsgBody;
//
//- (instancetype)initWithAdvertGoodsBody:(WareDetailBody *)scanMsgBody;

@end

@interface InquiryStore : NSObject

@property (nonatomic, copy) NSString *storeCode;

@property (nonatomic, copy) NSString *storeName;

//- (instancetype)initWithStore:(Store *)store;
//
//- (instancetype)initWithStores:(WareDetailStores *)store;

@end

@interface InquiryLoan : NSObject

@property (nonatomic, copy) NSString *loanCode;

@property (nonatomic, copy) NSString *loanName;

//- (instancetype)initWithLoan:(Loan *)loan;
//
//+ (instancetype)initWithLoans:(WareDetailLoan *)loan;

@end

@interface InquiryListmenu : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *goodsCode;

@property (nonatomic, copy) NSString *setMenuCode;

@property (nonatomic, copy) NSString *setMenuPrice;

@property (nonatomic, copy) NSString *showIndex;

@property (nonatomic, copy) NSString *isDefault;

//- (instancetype)initWithListMenu:(ListMenu *)listMenu;
//
//- (instancetype)initWithListMenus:(WareDetailMenus *)listMenu;


@end

