//
//  WareDetailModel.h
//  personMerchants
//
//  Created by 史长硕 on 2017/4/24.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class WareDetailHead,WareDetailBody,WareDetailLoan,WareDetailPics,WareDetailMenus,WareDetailGood,WareDetailStores,WareDetailPerNo;
@interface WareDetailModel : NSObject

@property(nonatomic,strong)WareDetailBody *body;

@property(nonatomic,strong)WareDetailHead *head;


@end

@interface WareDetailHead : NSObject

@property(nonatomic,copy)NSString *retFlag;

@property(nonatomic,copy)NSString *retMsg;

@end

@interface WareDetailBody : NSObject

@property(nonatomic,copy)NSString *goodsHtmlUrl;

@property(nonatomic,strong)NSArray<WareDetailLoan *> *loans;

@property(nonatomic,strong)NSArray<WareDetailMenus *> *menus;

@property(nonatomic,strong)WareDetailGood *good;

@property(nonatomic,strong)WareDetailPics *pics;

@property(nonatomic,strong)NSArray<WareDetailStores *>*stores;

@end

@interface WareDetailLoan : NSObject

@property(nonatomic,copy)NSString *loanCode;

@property(nonatomic,copy)NSString *loanName;

@property(nonatomic,strong)NSArray <WareDetailPerNo*>*psPerdNo;


@end

@interface WareDetailPerNo : NSObject

@property(nonatomic,copy)NSString *money;

@property(nonatomic,copy)NSString *nper;

@end

@interface WareDetailPics : NSObject

@property(nonatomic,copy)NSString *goodsCode;

@property(nonatomic,strong)NSArray *pics;

@end

@interface WareDetailMenus : NSObject

@property(nonatomic,copy)NSString *Id;

@property(nonatomic,copy)NSString *goodsCode;

@property(nonatomic,copy)NSString *setMenuCode;

@property(nonatomic,copy)NSString *setMenuPrice;

@property(nonatomic,copy)NSString *showIndex;

@property(nonatomic,copy)NSString *isDefault;



@end


@interface WareDetailStores : NSObject

@property(nonatomic,copy)NSString *storeName;

@property(nonatomic,copy)NSString *storeCode;


@end

@interface WareDetailGood : NSObject

@property(nonatomic,copy)NSString *goodsName;

@property(nonatomic,copy)NSString *goodsCode;

@property(nonatomic,copy)NSString *brandCode;

@property(nonatomic,copy)NSString *brandName;

@property(nonatomic,copy)NSString *goodsPrice;

@property(nonatomic,copy)NSString *kindCode;

@property(nonatomic,copy)NSString *kindName;

@property(nonatomic,copy)NSString *goodsModel;

@property(nonatomic,copy)NSString *merchantCode;

@property(nonatomic,copy)NSString *state;

@property(nonatomic,copy)NSString *goodsLine;

@property(nonatomic,copy)NSString *haveMenu;

@property(nonatomic,copy)NSString *goodsDesc;

@property(nonatomic,copy)NSString *skuCode;



@end

