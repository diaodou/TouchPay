//
//  WareTopView.h
//  商品详情
//
//  Created by 史长硕 on 2017/4/21.
//  Copyright © 2017年 史长硕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView.h>

typedef NS_ENUM(NSInteger,TouchType){
    
     TouchAddre,//点击送货地址
     TouchStoke,//点击库存
     TouchLocation,//点击定位
    
};

@protocol SendTouchDelegate <NSObject>

@optional

-(void)sendTouchType:(TouchType)type;

@end

@interface WareTopView : UIView

@property(nonatomic,strong)SDCycleScrollView *topImageScroll;//听不商品图片轮播图

@property(nonatomic,strong)UILabel *wareNameLabel;//商品名称介绍

@property(nonatomic,strong)UILabel *moneyLabel;//商品价格

@property(nonatomic,strong)UILabel *locationLabel;//定位

@property(nonatomic,strong)UILabel *addressLabel;//地址

@property(nonatomic,strong)UILabel *stockLabel;//库存

@property(nonatomic,strong)NSArray *imageArray;//图片数组

@property(nonatomic,strong)UILabel *wareTypeLabel;//商品类型

@property(nonatomic,strong)UILabel *compareLabel;//商品比较

@property(nonatomic,strong)UILabel *typCdeLabel;//商品贷款信息




@property(nonatomic,weak)id<SendTouchDelegate>delegate;

-(void)creatTopImageView;

-(float)buildChangeUiframe;

@end
