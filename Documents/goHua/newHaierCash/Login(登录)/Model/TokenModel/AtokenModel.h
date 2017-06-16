//
//  AtokenModel.h
//  HaiercashMerchantsAPP
//
//  Created by 史长硕 on 16/4/27.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface AtokenModel : NSObject

@property (nonatomic, copy) NSString *scope;

@property (nonatomic, copy) NSString *token_type;

@property (nonatomic, copy) NSString *access_token;

@property (nonatomic, assign) NSInteger expires_in;

@property (nonatomic, copy) NSString *refresh_token;

@end
