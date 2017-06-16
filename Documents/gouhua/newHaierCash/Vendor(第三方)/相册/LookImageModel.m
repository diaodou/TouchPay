//
//  LookImageModel.m
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/6/2.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "LookImageModel.h"

@implementation LookImageModel


+ (NSDictionary *)objectClassInArray{
    return @{@"body" : [LookImageBody class]};
}
@end
@implementation LookImageHead

@end


@implementation LookImageBody

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

@end


