//
//  ReadManager.h
//  读取通讯录
//
//  Created by mac on 15/4/21.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressBook.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
typedef void (^grantref)(bool bGrant);
@interface ReadManager : NSObject

+(NSArray*)readUserPhoneAddress;
+(void)shouquan:(grantref)ref;

@end
