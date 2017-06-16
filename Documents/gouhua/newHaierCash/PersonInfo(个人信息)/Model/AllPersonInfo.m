//
//  AllPersonInfo.m
//  HaiFu
//
//  Created by 史长硕 on 17/2/9.
//  Copyright © 2017年 百思为科. All rights reserved.
//

#import "AllPersonInfo.h"

@implementation AllPersonInfo

@end

@implementation AllPersonInfoHead



@end

@implementation AllPersonInfoBody

+ (NSDictionary *)objectClassInArray{
    return @{@"lxrList" : [ContactItem class]};
}


@end

@implementation ContactItem

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"Id":@"id"};
    
}

@end
