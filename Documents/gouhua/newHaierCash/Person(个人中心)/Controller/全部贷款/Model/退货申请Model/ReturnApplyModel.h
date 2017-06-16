//
//  ReturnApplyModel.h
//  personMerchants
//
//  Created by 百思为科 on 2017/4/26.
//  Copyright © 2017年 海尔金融. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@class ReturnApplyHead,ReturnApplyBody;
@interface ReturnApplyModel : NSObject

@property (nonatomic, strong) ReturnApplyHead *head;

@property (nonatomic, strong) ReturnApplyBody *body;

@end

@interface ReturnApplyHead : NSObject

@property (nonatomic, copy) NSString *retFlag;

@property (nonatomic, copy) NSString *retMsg;

@end

@interface ReturnApplyBody : NSObject

@property (nonatomic, copy) NSString *applSeq;

@property (nonatomic, copy) NSString *sysSts;

@end
