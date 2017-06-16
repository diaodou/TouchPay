//
//  HCCommitOffLineOrderController.h
//  newHaierCash
//
//  Created by Will on 2017/6/15.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCBaseViewController.h"

#import "HCUserModel.h"
typedef NS_ENUM(NSInteger , GoodsEnterType) {
    GoodsUnKnowMenu,   //商品未知是否有套餐
    GoodsNoMenuEnter,  //商品无套餐
    GoodsHasMenuEnter,   // 商品有套餐
    StoreEnter, //门店
    MerchantEnter //商户
};


@interface HCCommitOffLineOrderController : HCBaseViewController

@property (nonatomic, assign) GoodsEnterType scantype; //商品类型

@end
