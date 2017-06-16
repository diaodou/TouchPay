//
//  ReadManager.m
//  读取通讯录
//
//  Created by mac on 15/4/21.
//  Copyright (c) 2015年 MAC. All rights reserved.
//

#import "ReadManager.h"


@implementation ReadManager
+(NSArray*)readUserPhoneAddress{
    CFErrorRef error;
    //    //新建一个通讯录类
    ABAddressBookRef _addressBook = ABAddressBookCreateWithOptions(NULL,&error);
    NSMutableArray* _dataSource = [[NSMutableArray alloc]init];
    if (_addressBook)
    {
        //获取通讯录中的所有人
        
        CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(_addressBook);
        
        for(int i = 0; i < CFArrayGetCount(results); i++)
        {
            AddressBook* addressBook = [[AddressBook alloc]init];
            ABRecordRef person = CFArrayGetValueAtIndex(results, i);
            //获取个人名字
            CFTypeRef abFirstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
            CFStringRef abFullName = ABRecordCopyCompositeName(person);
            
            
            addressBook.firstName = @"";
            addressBook.lastName = @"";
            addressBook.fullName = @"";
            
            if (abFirstName) {
                NSString* firstString = (__bridge NSString*)abFirstName;
                addressBook.firstName = firstString;
                CFRelease(abFirstName);
            }
            if (abLastName) {
                NSString* lastString = (__bridge NSString*)abLastName;
                addressBook.lastName = lastString;
                CFRelease(abLastName);
            }
            if (abFullName) {
                NSString *fullNameString = (__bridge NSString*)abFullName;
                addressBook.fullName = fullNameString;
                CFRelease(abFullName);
            }
            
            NSMutableArray *arrPhonte = [NSMutableArray array];
            //读取电话多值
            ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
            CFIndex phoneCount = ABMultiValueGetCount(phone);
            for (int k = 0; k < phoneCount; k++)
            {
                PhoneModel *phoneModel = [[PhoneModel alloc]init];
                //获取电话Label
                CFStringRef cfPersonPhoneLabel = ABMultiValueCopyLabelAtIndex(phone, k);
                CFStringRef cflocalLabel = ABAddressBookCopyLocalizedLabel(cfPersonPhoneLabel);
                NSString * personPhoneLabel = (__bridge NSString*)cflocalLabel;
                //获取該Label下的电话值
                CFStringRef cfPersonPhone = ABMultiValueCopyValueAtIndex(phone, k);
                NSString * personPhone = (__bridge NSString*)cfPersonPhone;
                NSLog(@"手机%@",personPhone);
                phoneModel.telName = personPhoneLabel;
                phoneModel.telNo = personPhone;
                [arrPhonte addObject:phoneModel];
                
                if (cflocalLabel) {
                    CFRelease(cflocalLabel);
                }
                if (cfPersonPhoneLabel) {
                    CFRelease(cfPersonPhoneLabel);
                }
                if (cfPersonPhone) {
                    CFRelease(cfPersonPhone);
                }
            }
            addressBook.phone = arrPhonte;
            [_dataSource addObject:addressBook];
            if (phone) {
                CFRelease(phone);
            }
        }
        if (_addressBook) {
            CFRelease(_addressBook);
        }
        if (results) {
            CFRelease(results);
        }
        return _dataSource;
    }
    else{
        return nil;
    }
}

+(void)shouquan:(grantref)ref{
    CFErrorRef error = NULL;
    //ios6以后访问地址簿是要先有用户授权的
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    if (status == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, &error), ^(bool granted, CFErrorRef error) {
            //第一次的时候系统就会弹出一个提示框告诉用户是否允许该应用访问通讯录
            if (ref) {
                ref(granted);
            }
        });
    }
    else if (status == kABAuthorizationStatusAuthorized) {
        //说明可以访问
        ref(YES);
    }
    else {
        //可能是用户关闭了访问通讯的权限。
        ref(NO);
    }
}

@end
