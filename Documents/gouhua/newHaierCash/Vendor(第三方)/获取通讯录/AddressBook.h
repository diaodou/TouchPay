//
//  AddressBook.h
//  读取通讯录
//
//  Created by mac on 15/4/21.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneModel.h"

@interface AddressBook : NSObject
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSArray *phone;
@end
