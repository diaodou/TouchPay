//
//  InquiryModel.m
//  personMerchants
//
//  Created by 百思为科 on 16/5/7.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "InquiryModel.h"
#import <MJExtension.h>

@implementation InquiryModel

//- (instancetype)initWithGoodsinfo:(Goodsinfo *)Goodsinfo
//{
//    self = [super init];
//    if(self)
//    {
//        self.head.retFlag = @"00000";
//        self.head.retMsg = @"处理成功";
//        
//        self.body = [[InquiryBody alloc] initWithGoodInfo:Goodsinfo];
//    }
//    
//    return self;
//}
//
//- (instancetype)initWithScanMsgBody:(ScanMsgBody *)scanMsgBody
//{
//    self = [super init];
//    if(self)
//    {
//        self.head.retFlag = @"00000";
//        self.head.retMsg = @"处理成功";
//        
//        self.body = [[InquiryBody alloc] initWithScanMsgBody:scanMsgBody];
//    }
//    
//    return self;
//}
//
//-(instancetype)initWithAdvertGoodsBody:(WareDetailBody *)scanMsgBody{
//    
//    self = [super init];
//    if(self)
//    {
//        self.head.retFlag = @"00000";
//        self.head.retMsg = @"处理成功";
//        
//        self.body = [[InquiryBody alloc] initWithAdvertGoodsBody:scanMsgBody];
//    }
//    
//    return self;
//    
//}

@end

@implementation InquiryHead

@end


@implementation InquiryBody

+ (NSDictionary *)objectClassInArray{
    return @{@"listmenu" : [InquiryListmenu class],@"store" : [InquiryStore class], @"loan" : [InquiryLoan class]};
}

//-(instancetype)initWithAdvertGoodsBody:(WareDetailBody *)scanMsgBody{
//    
//    
//    self = [super init];
//    if(self)
//    {
//        self.goodsCode = scanMsgBody.good.goodsCode;
//        self.goodsLine = scanMsgBody.good.goodsLine;
//        if (scanMsgBody.stores.count > 0) {
//            WareDetailStores *store = scanMsgBody.stores[0];
//            self.storeCode = store.storeCode;
//            self.storeName = store.storeName;
//        }
//       
//      
//        self.goodsName = scanMsgBody.good.goodsName;
//        
//        self.kindCode = scanMsgBody.good.kindCode;
//        self.goodsModel = scanMsgBody.good.goodsModel;
//        self.goodsPrice = scanMsgBody.good.goodsPrice;
//        //self.pictureUrl = scanMsgBody.good.pictureUrl;
//        self.brandCode = scanMsgBody.good.brandCode;
//        self.brandName = scanMsgBody.good.brandName;
//        self.kindName = scanMsgBody.good.kindName;
//        self.haveMenu = scanMsgBody.good.haveMenu;
//        self.goodsDesc = scanMsgBody.good.goodsDesc;
//        self.state = scanMsgBody.good.state;
//        self.merchantCode = scanMsgBody.good.merchantCode;
//        self.goodsHtmlUrl = scanMsgBody.goodsHtmlUrl;
//        
//        NSMutableArray *loanArray = [[NSMutableArray alloc] init];
//        for (int i=0; i<scanMsgBody.loans.count; i++) {
//            [loanArray addObject:[InquiryLoan initWithLoans:scanMsgBody.loans[i]]];
//        }
//        self.loan = loanArray;
//        
//        NSMutableArray *storeArray = [[NSMutableArray alloc] init];
//        for(int i=0;i<scanMsgBody.stores.count;i++)
//        {
//            [storeArray addObject:[[InquiryStore alloc] initWithStores:scanMsgBody.stores[i]]];
//        }
//        self.store = storeArray;
//        
//        NSMutableArray *listMenu = [[NSMutableArray alloc] init];
//        for(int i =0;i<scanMsgBody.menus.count;i++)
//        {
//            [listMenu addObject:[[InquiryListmenu alloc] initWithListMenus:scanMsgBody.menus[i]]];
//        }
//        self.listmenu = listMenu;
//    }
//    return self;
//
//    
//}
//
//- (instancetype)initWithGoodInfo:(Goodsinfo *)goodsInfo
//{
//    self = [super init];
//    if(self)
//    {
//        self.goodsCode = goodsInfo.goodsCode;
//        self.goodsLine = goodsInfo.goodsLine;
//        self.storeCode = goodsInfo.storeCode;
//        self.goodsName = goodsInfo.goodsName;
//        self.storeName = goodsInfo.storeName;
//        self.kindCode = goodsInfo.kindCode;
//        self.goodsModel = goodsInfo.goodsModel;
//        self.goodsPrice = [NSString stringWithFormat:@"%f",goodsInfo.goodsPrice];
//        self.pictureUrl = goodsInfo.pictureUrl;
//        self.brandCode = goodsInfo.brandCode;
//        self.brandName = goodsInfo.brandName;
//        self.kindName = goodsInfo.kindName;
//        self.haveMenu = goodsInfo.haveMenu;
//        self.goodsDesc = goodsInfo.goodsDesc;
//        self.state = goodsInfo.state;
//        self.merchantCode = goodsInfo.merchantCode;
//        NSMutableArray *loanArray = [[NSMutableArray alloc] init];
//        for (int i=0; i<goodsInfo.loan.count; i++) {
//            [loanArray addObject:[[InquiryLoan alloc] initWithLoan:goodsInfo.loan[i]]];
//        }
//        self.loan = loanArray;
//        
//        NSMutableArray *storeArray = [[NSMutableArray alloc] init];
//        for(int i=0;i<goodsInfo.store.count;i++)
//        {
//            [storeArray addObject:[[InquiryStore alloc] initWithStore:goodsInfo.store[i]]];
//        }
//        self.store = storeArray;
//
//        NSMutableArray *listMenu = [[NSMutableArray alloc] init];
//        for(int i =0;i<goodsInfo.listmenu.count;i++)
//        {
//            [listMenu addObject:[[InquiryListmenu alloc] initWithListMenu:goodsInfo.listmenu[i]]];
//        }
//        self.listmenu = listMenu;
//    }
//    return self;
//}
//
//- (instancetype)initWithScanMsgBody:(ScanMsgBody *)scanMsgBody
//{
//    self = [super init];
//    if(self)
//    {
//        self.goodsCode = scanMsgBody.good.goodsCode;
//        self.goodsLine = scanMsgBody.good.goodsLine;
//        self.goodsName = scanMsgBody.good.goodsName;
//        self.storeName = scanMsgBody.storeName;
//        self.kindCode = scanMsgBody.good.kindCode;
//        self.goodsModel = scanMsgBody.good.goodsModel;
//        self.goodsPrice = scanMsgBody.good.goodsPrice;
//        self.brandCode = scanMsgBody.good.brandCode;
//        self.brandName = scanMsgBody.good.brandName;
//        self.kindName = scanMsgBody.good.kindName;
//        self.haveMenu = scanMsgBody.good.haveMenu;
//        self.goodsDesc = scanMsgBody.good.goodsDesc;
//        self.state = scanMsgBody.good.state;
//        self.merchantCode = scanMsgBody.good.merchantCode;
//        NSMutableArray *loanArray = [[NSMutableArray alloc] init];
//        for (int i=0; i<scanMsgBody.loans.count; i++) {
//            [loanArray addObject:[[InquiryLoan alloc] initWithLoan:scanMsgBody.loans[i]]];
//        }
//        self.loan = loanArray;
//        
//        NSMutableArray *storeArray = [[NSMutableArray alloc] init];
//        for(int i=0;i<scanMsgBody.stores.count;i++)
//        {
//            [storeArray addObject:[[InquiryStore alloc] initWithStore:scanMsgBody.stores[i]]];
//        }
//        self.store = storeArray;
//        
//        NSMutableArray *listMenu = [[NSMutableArray alloc] init];
//        for(int i =0;i<scanMsgBody.menus.count;i++)
//        {
//            [listMenu addObject:[[InquiryListmenu alloc] initWithListMenu:scanMsgBody.menus[i]]];
//        }
//        self.listmenu = listMenu;
//    }
//    return self;
//}

@end


@implementation InquiryStore

//- (instancetype)initWithStore:(Store *)store
//{
//    self = [super init];
//    if (self) {
//        self.storeCode = store.storeCode;
//        self.storeName = store.storeName;
//    }
//    return self;
//}
//
//- (instancetype)initWithStores:(WareDetailStores *)store
//{
//    self = [super init];
//    if (self) {
//        self.storeCode = store.storeCode;
//        self.storeName = store.storeName;
//    }
//    return self;
//}
//
//
@end


@implementation InquiryLoan

//- (instancetype)initWithLoan:(Loan *)loan
//{
//    self = [super init];
//    if(self)
//    {
//        self.loanCode = loan.loanCode;
//        self.loanName = loan.loanName;
//    }
//    return self;
//}
//
//+ (instancetype)initWithLoans:(WareDetailLoan *)loan {
//    InquiryLoan *newloan = [InquiryLoan new];
//    newloan.loanCode = loan.loanCode;
//    newloan.loanName = loan.loanName;
//    return newloan;
//}
//
@end

@implementation InquiryListmenu

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

//- (instancetype)initWithListMenu:(ListMenu *)listMenu
//{
//    self = [super init];
//    if(self)
//    {
//        self.ID = listMenu.ID;
//        self.goodsCode = listMenu.goodsCode;
//        self.setMenuCode = listMenu.setMenuCode;
//        self.setMenuPrice = listMenu.setMenuPrice;
//        self.showIndex = listMenu.showIndex;
//        self.isDefault = listMenu.isDefault;
//    }
//    return self;
//}
//- (instancetype)initWithListMenus:(WareDetailMenus *)listMenu
//{
//    self = [super init];
//    if(self)
//    {
//        self.ID = listMenu.Id;
//        self.goodsCode = listMenu.goodsCode;
//        self.setMenuCode = listMenu.setMenuCode;
//        self.setMenuPrice = listMenu.setMenuPrice;
//        self.showIndex = listMenu.showIndex;
//        self.isDefault = listMenu.isDefault;
//    }
//    return self;
//}
@end
