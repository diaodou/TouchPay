//
//  StartBrAgent.h
//  personMerchants
//
//  Created by 百思为科 on 16/10/18.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StartBrAgent : NSObject

+ (NSString *)startBrAgentLogin;//登录

+ (NSString *)startBrAgentlend;//借款

+ (NSString *)startBrAgentregister;//注册

@property(nonatomic,assign)NSInteger postHttpNum;//发起网络请求次数

@end
