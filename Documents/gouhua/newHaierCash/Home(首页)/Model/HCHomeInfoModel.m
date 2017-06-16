//
//  HCHomeInfoModel.m
//  newHaierCash
//
//  Created by Will on 2017/6/13.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCHomeInfoModel.h"

@implementation HCHomeInfoModel
+ (NSDictionary *)objectClassInArray{
    return @{@"info" : [HomeSectionModel class], @"child1Node" : [HomeChildModel class]};
}

+ (HCHomeInfoModel *)GetHCHomeInfoModel {
    HCHomeInfoModel *model = [HCHomeInfoModel new];
    model.head = [HCHomeInfoHead new];
    model.head.retFlag = @"00000";
    model.head.retMsg = @"";
    
    model.body = [HCHomeInfoBody new];
    
    HomeChildModel *child1 = [HomeChildModel new];
    child1.title = @"卡萨帝智能冰箱，打造品质生活";
    child1.secondTitle = @"0首付";
    child1.note = @"3333*3期";
    child1.picPath = @"/testshare01/storage/appmanage/154.jpg";
    child1.jumpType = @"goods";
    
    HomeChildModel *child2 = [HomeChildModel new];
    child2.title = @"海尔空调";
    child2.secondTitle = @"0首付";
    child2.note = @"3333*3期";
    child2.picPath = @"/testshare01/storage/appmanage/155.jpg";
    child2.jumpType = @"goods";
    
    HomeSectionModel *sectionModel1 = [HomeSectionModel new];
    sectionModel1.title = @"精品分期";
    sectionModel1.jumpType = @"JPFQ";
    sectionModel1.style = @"vertical";
    sectionModel1.childNode = [NSArray arrayWithObjects:child1,child2, nil];
    
    HomeChildModel *child3 = [HomeChildModel new];
    child3.title = @"随借随还";
    child3.secondTitle = @"利率低至万4/天";
    child3.picPath = @"/testshare01/storage/appmanage/156.jpg";
    child3.jumpType = @"ed";
    
    HomeSectionModel *sectionModel2 = [HomeSectionModel new];
    sectionModel2.title = @"现金分期";
    sectionModel2.jumpType = @"XJFQ";
    sectionModel2.style = @"vertical";
    sectionModel2.childNode = [NSArray arrayWithObjects:child3, nil];
    
    HomeChildModel *child4 = [HomeChildModel new];
    child4.title = @"";
    child4.secondTitle = @"";
    child4.note = @"";
    child4.picPath = @"/testshare01/storage/appmanage/154.jpg";
    child4.jumpType = @"goods";
    
    HomeSectionModel *sectionModel3 = [HomeSectionModel new];
    sectionModel3.id = @"12";
    sectionModel3.title = @"轮播图";
    sectionModel3.jumpType = @"JPFQ";
    sectionModel3.style = @"slideshow";
    sectionModel3.childNode = [NSArray arrayWithObjects:child4, nil];
    
    HomeChildModel *child5 = [HomeChildModel new];
    child5.title = @"新用户专享";
    child5.secondTitle = @"激活额度送IMAX电影票";
    child5.picPath = @"/testshare01/storage/appmanage/154.jpg";
    child5.jumpType = @"";
    
    HomeChildModel *child6 = [HomeChildModel new];
    child6.title = @"新用户专享";
    child6.secondTitle = @"贷款成功后即可参与";
    child6.picPath = @"/testshare01/storage/appmanage/155.jpg";
    child6.jumpType = @"";
    
    HomeChildModel *child7 = [HomeChildModel new];
    child7.title = @"新用户专享";
    child7.secondTitle = @"贷款成功送惊喜大礼盒";
    child7.note = @"";
    child7.picPath = @"/testshare01/storage/appmanage/156.jpg";
    child7.jumpType = @"";
    
    HomeSectionModel *sectionModel4 = [HomeSectionModel new];
    sectionModel4.id = @"12";
    sectionModel4.title = @"精彩权益";
    sectionModel4.jumpType = @"JPFQ";
    sectionModel4.style = @"horizontal";
    sectionModel4.childNode = [NSArray arrayWithObjects:child5,child6,child7, nil];
    
    model.body.info = [NSArray arrayWithObjects:sectionModel4,sectionModel3,sectionModel2,sectionModel1, nil];
    
    return model;
}

@end

@implementation HCHomeInfoHead

@end

@implementation HCHomeInfoBody

@end

@implementation HomeSectionModel

@end

@implementation HomeChildModel

@end
