//
//  PersonBack.h
//  personMerchants
//
//  Created by 张久健 on 16/5/6.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class PersonBackHead;
@interface PersonBack : NSObject

@property (nonatomic, strong) PersonBackHead *head;

@end
@interface PersonBackHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

