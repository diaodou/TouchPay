//
//  MessageCenterModel.m
//  newHaierCash
//
//  Created by 百思为科 on 2017/6/7.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMessageCenterModel.h"

@implementation HCMessageCenterModel

+ (NSDictionary *)objectClassInArray{
    return @{@"body" : [MessageCenterBody class]};
}
@end
@implementation MessageCenterHead

@end


@implementation MessageCenterBody
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

@end
