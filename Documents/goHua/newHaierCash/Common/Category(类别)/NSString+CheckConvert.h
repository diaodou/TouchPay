//
//  NSString+CheckConvert.h
//  newHaierCash
//
//  Created by Will on 2017/5/25.
//  Copyright © 2017年 haier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CheckConvert)
#pragma mark - NSString Check
//判断字符串是否为有效字符
- (BOOL)isValidateString;

//姓名格式校验
- (BOOL) isValidateName;

//手机号码格式验证(是否为11位数字)
- (BOOL)isValidateMobileNum;

//判断输入的字符串是否只含有字母和数字并且长度在6-20以内
- (BOOL)isValidateInput;

//是否输入正确的金钱数
- (BOOL)isValidateMoneyInput;


#pragma mark - NSString Convert

//隐藏中间4位号码
-(NSString *)hiddenCenterNum;

//隐藏电话号的中间号码
- (NSString *)convertToTelNum;

//去除电话号码+86
- (NSString *)buildPrefixString;


//隐藏身份证的中间号码
- (NSString *)convertToIdCardNum;

//隐藏银行卡的中间号码
- (NSString *)convertToBankNum;

//删除空格字符
- (NSString *)deleteSpeaceString;

//数字转化千分位
- (NSString *)changeTensofThousands;

//仅限于生日格式转码
-(NSString *)buildChangeDay;

//仅限于转换身份证开始生效日期
-(NSString *)buildReplaceCertStartDt;
//仅限于转换身份证开始失效日期
-(NSString *)buildReplaceCertEndDt;


@end
