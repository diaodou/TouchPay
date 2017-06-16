//
//  PortraitImageModel.m
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/5/31.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "PortraitImageModel.h"

@implementation PortraitImageModel


+ (NSDictionary *)objectClassInArray{
    return @{@"body" : [PortraitBody class]};
}
@end
@implementation PortraitHead

@end


@implementation PortraitBody

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    
    return @{@"ID":@"id"};
}

@end


