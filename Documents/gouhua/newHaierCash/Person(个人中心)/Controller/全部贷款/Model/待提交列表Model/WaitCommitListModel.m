//
//  WaitCommitListModel.m
//  personMerchants
//
//  Created by xuxie on 16/5/14.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "WaitCommitListModel.h"

@implementation WaitCommitListModel

@end
@implementation WaitCommitListHead

@end


@implementation WaitCommitListBoby

+ (NSDictionary *)objectClassInArray{
    return @{@"orders" : [WaitCommitListOrders class]};
}

@end


@implementation WaitCommitListOrders

@end


