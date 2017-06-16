//
//  WareDetailViewController.h
//  商品详情
//
//  Created by 史长硕 on 2017/4/21.
//  Copyright © 2017年 史长硕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCBaseViewController.h"
#import "OrdeDetailsModel.h"
@interface WareDetailViewController : HCBaseViewController

@property(nonatomic,copy)NSString *goodsCode;//商品代码

@property(nonatomic,copy)NSString *salerCode;//销售代表编号

@property(nonatomic,strong)OrdeDetailsModel *detailModel;//订单详情model

@property(nonatomic,assign)BOOL isIfHaveLogistics;//是否有物流

@property(nonatomic,assign)BOOL ifOnLine;//是否线上

@end
