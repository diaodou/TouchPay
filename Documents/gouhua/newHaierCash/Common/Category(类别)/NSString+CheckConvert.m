//
//  NSString+CheckConvert.m
//  newHaierCash
//
//  Created by Will on 2017/5/25.
//  Copyright © 2017年 haier. All rights reserved.
//

#import "HCMacro.h"

#import "NSString+CheckConvert.h"

@implementation NSString (CheckConvert)

#pragma mark - NSString Check
//判断字符串是否为有效字符
- (BOOL)isValidateString {
    BOOL isNoValidate = isNull(self) || [self isEqualToString:@""] || [self isEqualToString:@"(null)"] || !self;
    return !isNoValidate;
}

- (BOOL) isValidateName {
    NSString *NAME=@"[\u4E00-\u9FA5]{2,10}(?:(·|•)[\u4E00-\u9FA5]{2,10})*$";
    
    NSPredicate *nameText=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",NAME];
    
    return [nameText evaluateWithObject:self];
}

- (BOOL )isValidateMobileNum {
    NSString *checkedNumString = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (checkedNumString.length <= 0 && self.length == 11) {
        return YES;
    }
    return NO;
    
    /*
     if (self.length >= 11) {
     // 移动号段正则表达式
     NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
     //联通号段正则表达式
     NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
     //电信号段正则表达式
     NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
     
     NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
     if ([pred1 evaluateWithObject:self]) {
     return  YES;
     }
     NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
     if ([pred2 evaluateWithObject:self]) {
     return YES;
     }
     NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
     if ([pred3 evaluateWithObject:self]) {
     return YES;
     }
     }
     return NO;
     */
}

- (BOOL)isValidateInput {
    if (self.length >= 6 && self.length <= 20) {
        
        for (int i = 0; i < self.length; i++) {
            
            unichar num = [self characterAtIndex:i];
            
            if (!isnumber(num) && !isalpha(num)) {
                return NO;
            }
        }
        return YES;
    }
    
    return NO;
}

- (BOOL)isValidateMoneyInput {
    BOOL basicTest;
    for (int i = 0 ; i < self.length; i ++ ) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
        NSString *str = [self substringWithRange:NSMakeRange(i, 1)];
        NSString *filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        basicTest = [str isEqualToString:filtered];
        if(!basicTest)
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark - NSString Convert

-(NSString *)hiddenCenterNum{
    
    
    NSMutableString *stringOne = [NSMutableString stringWithString:self];
    
    NSMutableString *stringTwo = [NSMutableString stringWithString:self];
    
    if (stringOne.length > 7) {
        
        NSString *first = [stringOne substringToIndex:3];
        
        NSString *end = [stringTwo substringFromIndex:7];
        
        NSString *string = [NSString stringWithFormat:@"%@****%@",first,end];
        
        return string;
        
    }else{
        
        return self;
    }
    
    
    
    
}

- (NSString *)convertToTelNum {
    if (!self) {
        return @"";
    }else if (self.length == 11) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }
    return self;
}

- (NSString *)convertToIdCardNum {
    if (!self) {
        return @"";
    }else if (self.length > 15) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(3, self.length - 7) withString:@"*** **** **** "];
    }
    return self;
}

- (NSString *)convertToBankNum {
    if (!self) {
        return @"";
    }else if (self.length >= 15) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(0, self.length - 4) withString:@"**** **** **** "];
    }
    return self;
}

//去除电话号码+86
-(NSString *)buildPrefixString{
    
    NSString *strO = self;
    
    strO = [strO stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    
    NSString *strDest  = [self findNumFromStr:strO];
    
    
    return strDest;
    
}

-(NSString *)findNumFromStr:(NSString *)strSource
{
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:strSource.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:strSource];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    return strippedString;
    
}

//删除空格字符
- (NSString *)deleteSpeaceString {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//数字转化千分位
- (NSString *)changeTensofThousands {
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    
    formatter.numberStyle = kCFNumberFormatterCurrencyStyle;
    
    NSString * newString = [NSString stringWithFormat:@"%.2f",[self floatValue]];
    
    NSString * lastString = [formatter stringFromNumber:[NSNumber numberWithFloat:newString.floatValue]];
    
    NSString * changeStr = [lastString substringFromIndex:1];
    
    return changeStr;
}

//身份证生日日期
-(NSString *)buildChangeDay{
    
    NSMutableString *string = [NSMutableString stringWithString:self];
    
    if (string.length > 5) {
        
        [string replaceCharactersInRange:NSMakeRange(4, 1) withString:@"-"];
        
    }
    
    if (string.length > 8) {
        
        [string replaceCharactersInRange:NSMakeRange(7, 1) withString:@"-"];
        
    }
    
    [string deleteCharactersInRange:NSMakeRange(string.length-1, 1)];
    
    return string;
    
}

-(NSString *)buildReplaceCertEndDt{
    
    if (self.length > 8) {
        
        NSMutableString *string = [NSMutableString stringWithString:self];
        
        for (int n = 0; n < string.length; n ++) {
            
            NSString * error = [string substringWithRange:NSMakeRange(n, 1)];
            
            if ([error isEqualToString:@"."]||[error isEqualToString:@"-"]) {
                
                [string deleteCharactersInRange:NSMakeRange(n, 1)];
                
                n --;
            }
        }
        
        NSString * newString = [NSString stringWithString:string];
        
        NSString *startString = [newString substringFromIndex:8];
        
        return startString;
        
        
    }else{
        
        return @"";
    }
    
}

-(NSString *)buildReplaceCertStartDt{
    
    if (self.length >= 8) {
        
        NSMutableString *string = [NSMutableString stringWithString:self];
        
        for (int n = 0; n < 8; n ++) {
            
            NSString * error = [string substringWithRange:NSMakeRange(n, 1)];
            
            if ([error isEqualToString:@"."]||[error isEqualToString:@"-"]) {
                
                [string deleteCharactersInRange:NSMakeRange(n, 1)];
                
                n --;
            }
        }
        
        NSString * newString = [NSString stringWithString:string];
        
        NSString *startString = [newString substringToIndex:8];
        
        return startString;
        
        
    }else{
        
        return @"";
    }
    
}




@end
