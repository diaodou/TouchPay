//
//  HCHomeInfoModel.h
//  newHaierCash
//
//  Created by Will on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HCHomeInfoHead,HCHomeInfoBody,HomeSectionModel,HomeChildModel;
@interface HCHomeInfoModel : NSObject
@property (nonatomic, strong) HCHomeInfoHead *head;

@property (nonatomic, strong) HCHomeInfoBody *body;

+ (HCHomeInfoModel *)GetHCHomeInfoModel;

@end
@interface HCHomeInfoHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface HCHomeInfoBody : NSObject

@property (nonatomic, strong) NSArray<HomeSectionModel *> *info;

@end

@interface HomeSectionModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *secondTitle;

@property (nonatomic, copy) NSString *note;

@property (nonatomic, copy) NSString *picPath;


@property (nonatomic, copy) NSString *sizeType;

@property (nonatomic, copy) NSString *level; //显示层级 1：最高层级2：次高层级

@property (nonatomic, copy) NSString *order;

@property (nonatomic, copy) NSString *fatherId;

@property (nonatomic, copy) NSString *style; //显示风格
//vertical：纵向列表（精品分期样式;horizontal: 横向列表（精彩权益样式）;slideshow: 层叠列表（头部轮播样式）

@property (nonatomic, copy) NSString *jumpType; //跳转方式
//JPFQ：跳转到精品分期页面;XJFQ：现金分期介绍;JCQY：精彩权益;DEZX：大额专享


@property (nonatomic, copy) NSString *jumpKey; //跳转关键字
//1.跳转方式为goods：返回goodsCode；2.h5、XJFQ：网页连接；3.activity：活动id

@property (nonatomic, strong) NSArray<HomeChildModel *> *childNode;

@end

@interface HomeChildModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *secondTitle;

@property (nonatomic, copy) NSString *note;

@property (nonatomic, copy) NSString *picPath;


@property (nonatomic, copy) NSString *sizeType;

@property (nonatomic, copy) NSString *level; //显示层级 1：最高层级2：次高层级

@property (nonatomic, copy) NSString *order;


@property (nonatomic, copy) NSString *fatherId;


@property (nonatomic, copy) NSString *style;


@property (nonatomic, copy) NSString *jumpType; //跳转方式
//ed:跳转额度;goods:跳转商品页面;h5:跳转网页;activity:跳转活动页面;JPFQ：跳转到精品分期页面;
//XJFQ：跳转到现金分期介绍页面;JCQY：跳转到精彩权益页面;DEZX：跳转到大额专享页面

@property (nonatomic, copy) NSString *jumpKey; //跳转关键字
//1.跳转方式为goods：返回goodsCode；2.h5、XJFQ：网页连接；3.activity：活动id

@end
