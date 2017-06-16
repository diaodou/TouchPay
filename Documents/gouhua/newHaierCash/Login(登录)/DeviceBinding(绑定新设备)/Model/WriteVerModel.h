//
//  WriteVerModel.h
//  personMerchants
//
//  Created by 百思为科 on 16/5/9.
//  Copyright © 2016年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class WriteHead;
@interface WriteVerModel : NSObject


@property (nonatomic, strong) WriteHead *head;


@end
@interface WriteHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

