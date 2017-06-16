//
//  WhiteSearchModel.m
//  personMerchants
//
//  Created by 百思为科 on 16/6/4.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import "WhiteSearchModel.h"
#import "BSVKHttpClient.h"
@implementation WhiteSearchModel

@end
@implementation WhiteSearchHead

@end


@implementation WhiteSearchBody
-(void)setIsPass:(NSString *)isPass{
    
    _isPass = isPass;
    if ([isPass isEqualToString:@"shh"]) {
        [[BSVKHttpClient shareInstance].requestSerializer setValue:@"19" forHTTPHeaderField:@"channel_no"];
    }
}
-(void)setLevel:(NSString *)level{
    
    _level = level;
    if ([level isEqualToString:@"A"]) {
        [[BSVKHttpClient shareInstance].requestSerializer setValue:@"17" forHTTPHeaderField:@"channel_no"];
    }else if ([level isEqualToString:@"B"]){
        [[BSVKHttpClient shareInstance].requestSerializer setValue:@"18" forHTTPHeaderField:@"channel_no"];
    }else{
        [[BSVKHttpClient shareInstance].requestSerializer setValue:@"19" forHTTPHeaderField:@"channel_no"];
    }
}
@end




